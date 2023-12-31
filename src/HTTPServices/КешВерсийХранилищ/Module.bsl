
#Область ОбработкаЗапросов

Функция ВерсияGET(Запрос)
	ВерсияСервиса = "1.0.0.1";
	Возврат ОтветСервиса(200, ВерсияСервиса);
КонецФункции

Функция ПолучениеФайлаВерсииGET(Запрос)
	
	СтруктураОтвета = КонструкторСтруктурыОтвета();
	
	ХранилищеНаименование = Запрос.ПараметрыЗапроса.Получить("repo_name");
	ВерсияНомер = Запрос.ПараметрыЗапроса.Получить("version_id");
	ПутьКХранилищу = Запрос.ПараметрыЗапроса.Получить("repo_path");
	
	Отказ = Ложь;
	Ошибки = Новый Массив;
	Попытка
		Если Не ЗначениеЗаполнено(ХранилищеНаименование) И Не ЗначениеЗаполнено(ПутьКХранилищу) Тогда
			Отказ = Истина;
			Ошибки.Добавить("Не установлен один из обязательных параметров ""repo_id"" или ""repo_path"".");
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ВерсияНомер) Тогда
			Отказ = Истина;
			Ошибки.Добавить("Не установлен обязательный параметр ""version_id"" номер версии хранилища.");
		КонецЕсли;
		Если Отказ Тогда
			ВызватьИсключение СтрСоединить(Ошибки, Символы.ПС);
		КонецЕсли;
		
		//ВерсияХранилища = ПолучитьВерсиюХранилищаПоИдентификаторам(ХранилищеНаименование, НомерВерсии);
		ПараметрыПоискаВерсии = Новый Структура("ХранилищеНаименование,ВерсияНомер,ПутьКХранилищу", ХранилищеНаименование, Число(ВерсияНомер), ПутьКХранилищу);
		ВерсияХранилища = КешВерсийХранилищ.ВерсияИсторииХранилищаПоРеквизитам(ПараметрыПоискаВерсии);
		Если Не ЗначениеЗаполнено(ВерсияХранилища) Тогда
			ВызватьИсключение "Запрашиваемая версия не найдена.";
		КонецЕсли;
		
		ПутьКФайлу = КешВерсийХранилищ.ПолучитьПутьФайлаВерсииЕслиЕстьВКеше(ВерсияХранилища);
		Если ПутьКФайлу = Неопределено Или ПутьКФайлу = ""Тогда
			Если ПутьКФайлу = Неопределено Тогда
				КешВерсийХранилищ.ДобавитьВерсиюВОчередьВыгрузки(ВерсияХранилища);
			КонецЕсли;
			КешВерсийХранилищ.ВыгрузитьВерсиюВКешАсинх(ВерсияХранилища);
			СтруктураОтвета.Статус = СтатусВОчереди();
			ТекстОтвета = СтроковыеФункцииУККлиентСервер.ЗаписатьЗначениеJSON(СтруктураОтвета);
			Возврат ОтветСервиса(202, ТекстОтвета);
		КонецЕсли;
		
		СтруктураОтвета.Статус = СтатусУспех();
		СтруктураОтвета.ПутьКФайлу = ПутьКФайлу;
		ТекстОтвета = СтроковыеФункцииУККлиентСервер.ЗаписатьЗначениеJSON(СтруктураОтвета);
		Возврат ОтветСервиса(200, ТекстОтвета);
		
	Исключение
		СтруктураОтвета.Статус = СтатусОшибка();
		СтруктураОтвета.ОписаниеОшибки = ОписаниеОшибки();
		ТекстОтвета = СтроковыеФункцииУККлиентСервер.ЗаписатьЗначениеJSON(СтруктураОтвета);
		Возврат ОтветСервиса(400, ТекстОтвета);
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Конструктор структуры для ответа сервиса
//
// Возвращаемое значение:
//  Структура
//
Функция КонструкторСтруктурыОтвета()
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("Статус", ""); //{“ready”|”queue”|”error”}
	СтруктураОтвета.Вставить("ПутьКФайлу", "");
	СтруктураОтвета.Вставить("ОписаниеОшибки", "");
	
	Возврат СтруктураОтвета;
КонецФункции

// Формирует ответ сервиса
//
// Параметры:
//  КодОтвета	 - Число - код ответа сервиса.
//  СтрокаОтвета - Строка - будет передана в теле ответа.
// 
// Возвращаемое значение:
//  HTTPСервисОтвет
//
Функция ОтветСервиса(КодОтвета, ТелоОтвета, ТипТелаОтвета = Неопределено)
	
	Ответ = Новый HTTPСервисОтвет(КодОтвета);
	
	Если ТипТелаОтвета = Неопределено Или ТипТелаОтвета = Тип("Строка") Тогда
		Ответ.УстановитьТелоИзСтроки(ТелоОтвета);
		ТипСодержимого = "application/json;charset=utf-8";
	ИначеЕсли ТипТелаОтвета = Тип("ДвоичныеДанные") Тогда
		Ответ.УстановитьТелоИзДвоичныхДанных(ТелоОтвета);
		ТипСодержимого = "application/octet-stream";
	КонецЕсли;
	Ответ.Заголовки.Вставить("Content-Type", ТипСодержимого);
	
	Возврат Ответ;
	
КонецФункции

Функция СтатусОшибка()
	Возврат "error";
КонецФункции

Функция СтатусУспех()
	Возврат "ready";
КонецФункции

Функция СтатусВОчереди()
	Возврат "queue";
КонецФункции

//Функция ПолучитьВерсиюХранилищаПоИдентификаторам(ХранилищеНаименование, ВерсияНомер)
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	ИсторияХранилища.Ссылка КАК Ссылка
//		|ИЗ
//		|	Справочник.ИсторияХранилища КАК ИсторияХранилища
//		|ГДЕ
//		|	ИсторияХранилища.Владелец.Наименование = &ХранилищеНаименование
//		|	И ИсторияХранилища.Код = &ВерсияНомер";
//	Запрос.УстановитьПараметр("ВерсияНомер", Число(ВерсияНомер));
//	Запрос.УстановитьПараметр("ХранилищеНаименование", ХранилищеНаименование);
//	РезультатЗапроса = Запрос.Выполнить();
//	Если РезультатЗапроса.Пустой() Тогда
//		Возврат Справочники.ИсторияХранилища.ПустаяСсылка();
//	КонецЕсли;
//	
//	Выборка = РезультатЗапроса.Выбрать();
//	Выборка.Следующий();
//	Возврат Выборка.Ссылка;

//КонецФункции

#КонецОбласти
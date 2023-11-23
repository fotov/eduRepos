//////////////////////////////////////////////////////////////////////////
// HTTP сервис Дополнения.
// Версия: см. метод ВерсияGET
// Предназначен для работы с дополнениями: 
// расширения, дополнительные отчёты/обработки и пр.
//////////////////////////////////////////////////////////////////////////
// Код ответа:
//    * Успех - 200
//    * Ошибка - 400.
// В теле ответа:
// - Если необходимо передать двоичные данные
//    * Успех - запрашиваемые двоичные данные
//    * Ошибка - строка ошибки в двоичных данных
// - Если передаётся строка
//    * Успех - структура в JSON. см. КонструкторСтруктурыОтвета
//    * Ошибка - текст ошибки.
//////////////////////////////////////////////////////////////////////////

#Область ОбработкаЗапросов

Функция ВерсияGET(Запрос)
	ВерсияСервиса = "1.0.0.3";
	Возврат ОтветСервиса(200, ВерсияСервиса);
КонецФункции

Функция ДанныеGET(Запрос)
	Возврат ДанныеGETОтвет(Запрос);
КонецФункции

Функция СписокGET(Запрос)
	Возврат СписокGETОтвет(Запрос);
КонецФункции

Функция СписокВерсийДополненияGET(Запрос)
	Возврат СписокВерсийДополненияGETОтвет(Запрос);
КонецФункции

Функция СписокУстановленныхДополненийGET(Запрос)
	Возврат СписокУстановленныхДополненийGETОтвет(Запрос);
КонецФункции

Функция ДанныеУстановленногоДополненияGET(Запрос)
	Возврат ДанныеУстановленногоДополненияGETОтвет(Запрос);
КонецФункции

#КонецОбласти

#Область ПолучениеОтветов

Функция СписокGETОтвет(Запрос)
		
	СловарьЗначенийПараметров = РаботаСДополнениями.СловарьКонвертацииПараметровУК();
	ПараметрыЗапроса = РаботаСДополнениямиИнтеграция.КонвертированныеПараметрыЗапроса(Запрос.ПараметрыЗапроса, СловарьЗначенийПараметров);
	
	ТипДополнения = Неопределено;
	ИдентификаторБазы = Неопределено;
	
	Ошибки = Новый Массив;
	Если Не ПараметрыЗапроса.Свойство("ТипДополнения", ТипДополнения) Или ТипДополнения = Неопределено Тогда
		Ошибки.Добавить(ТекстОшибкиОбязательныйПараметр("ТипДополнения"));
	КонецЕсли;
	Если Не ПараметрыЗапроса.Свойство("ИдентификаторБазы", ИдентификаторБазы) Или ИдентификаторБазы = Неопределено Тогда
		Ошибки.Добавить(ТекстОшибкиОбязательныйПараметр("ИдентификаторБазы"));
	КонецЕсли;
	Если Ошибки.Количество() Тогда
		Возврат ОтветСервиса(400, СтрСоединить(Ошибки, Символы.ПС));		
	КонецЕсли;
	Статус = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыЗапроса, "Статус");
	
	СписокДополнений = ПолучитьДополненияJSON(ТипДополнения, ИдентификаторБазы, Статус);
	ОтветСервиса = ОтветСервиса(200, СписокДополнений);
	
	Возврат ОтветСервиса;
	
КонецФункции

Функция ДанныеGETОтвет(Запрос)
	
	СловарьЗначенийПараметров = РаботаСДополнениями.СловарьКонвертацииПараметровУК();
	ПараметрыЗапроса = РаботаСДополнениямиИнтеграция.КонвертированныеПараметрыЗапроса(Запрос.ПараметрыЗапроса, СловарьЗначенийПараметров);
	Если Не ПараметрыЗапроса.Свойство("УникальныйИдентификатор") Тогда
		ТекстОшибки = ПолучитьДвоичныеДанныеИзСтроки("Необходимо указать параметр УникальныйИдентификатор");
		Возврат ОтветСервиса(400, ТекстОшибки, Тип("ДвоичныеДанные"));
	КонецЕсли;
	
	ВерсияДополнения = Справочники.ВерсииДополнений.ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрыЗапроса.УникальныйИдентификатор));
	Если Не ОбщегоНазначения.СсылкаСуществует(ВерсияДополнения) Тогда
		ТекстОшибки = ПолучитьДвоичныеДанныеИзСтроки("Неверно передан параметр УникальныйИдентификатор. Версия дополнения не найдена.");
		Возврат ОтветСервиса(400, ТекстОшибки, Тип("ДвоичныеДанные"));
	КонецЕсли;
	
	СписокФайлов = Новый Массив;
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(ВерсияДополнения, СписокФайлов);
	Если Не СписокФайлов.Количество() Или СписокФайлов[0] = Неопределено Тогда
		ТекстОшибки = ПолучитьДвоичныеДанныеИзСтроки("Не найден файл версии дополнения.");
		Возврат ОтветСервиса(400, ТекстОшибки, Тип("ДвоичныеДанные"));
	КонецЕсли;
	// Файл у версии должен быть только один. Если их несколько, используем первый.
	ДвоичныеДанныеДополнения = РаботаСФайлами.ДвоичныеДанныеФайла(СписокФайлов[0], Ложь);
	Если ДвоичныеДанныеДополнения = Неопределено Тогда
		ТелоОтвета = ПолучитьДвоичныеДанныеИзСтроки("Не удалось получить двоичные данные дополнения");
		ОтветСервиса = ОтветСервиса(400, ТелоОтвета, Тип("ДвоичныеДанные"));
	КонецЕсли;
	
	Попытка
		КодОтвета = 200;
		ОтветСервиса = ОтветСервиса(КодОтвета, ДвоичныеДанныеДополнения, Тип("ДвоичныеДанные"));
	Исключение
		КодОтвета = 400;
		ТелоОтвета = ПолучитьДвоичныеДанныеИзСтроки(ОписаниеОшибки());
		ОтветСервиса = ОтветСервиса(КодОтвета, ТелоОтвета, Тип("ДвоичныеДанные"));
	КонецПопытки;
	
	Возврат ОтветСервиса;
	
КонецФункции

Функция СписокВерсийДополненияGETОтвет(Запрос)
		
	СловарьЗначенийПараметров = РаботаСДополнениями.СловарьКонвертацииПараметровУК();
	ПараметрыЗапроса = РаботаСДополнениямиИнтеграция.КонвертированныеПараметрыЗапроса(Запрос.ПараметрыЗапроса, СловарьЗначенийПараметров);
	Если Не ПараметрыЗапроса.Свойство("УникальныйИдентификатор") Тогда
		ТекстОшибки = ПолучитьДвоичныеДанныеИзСтроки("Необходимо указать параметр УникальныйИдентификатор");
		Возврат ОтветСервиса(400, ТекстОшибки, Тип("ДвоичныеДанные"));
	КонецЕсли;
	
	Дополнение = Справочники.Дополнения.ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрыЗапроса.УникальныйИдентификатор));
	Если Не ОбщегоНазначения.СсылкаСуществует(Дополнение) Тогда
		ТекстОшибки = ПолучитьДвоичныеДанныеИзСтроки("Неверно передан параметр УникальныйИдентификатор. Дополнение - владелец версий не найдено.");
		Возврат ОтветСервиса(400, ТекстОшибки, Тип("ДвоичныеДанные"));
	КонецЕсли;
	
	СписокВерсий = ПолучитьВерсииJSON(Дополнение);
	ОтветСервиса = ОтветСервиса(200, СписокВерсий);
	
	Возврат ОтветСервиса;
	
КонецФункции

Функция СписокУстановленныхДополненийGETОтвет(Запрос)
		
	СловарьЗначенийПараметров = РаботаСДополнениями.СловарьКонвертацииПараметровУК();
	ПараметрыЗапроса = РаботаСДополнениямиИнтеграция.КонвертированныеПараметрыЗапроса(Запрос.ПараметрыЗапроса, СловарьЗначенийПараметров);
	
	ТипДополнения = Неопределено;
	ИдентификаторБазы = Неопределено;
	
	Ошибки = Новый Массив;
	Если Не ПараметрыЗапроса.Свойство("ТипДополнения", ТипДополнения) Или ТипДополнения = Неопределено Тогда
		Ошибки.Добавить(ТекстОшибкиОбязательныйПараметр("ТипДополнения"));
	КонецЕсли;
	Если Не ПараметрыЗапроса.Свойство("ИдентификаторБазы", ИдентификаторБазы) Или ИдентификаторБазы = Неопределено Тогда
		Ошибки.Добавить(ТекстОшибкиОбязательныйПараметр("ИдентификаторБазы"));
	КонецЕсли;
	Если Ошибки.Количество() Тогда
		Возврат ОтветСервиса(400, СтрСоединить(Ошибки, Символы.ПС));		
	КонецЕсли;
	База = Справочники.Базы1С.НайтиПоРеквизиту("ИдентификаторКлиентаДополнений", ИдентификаторБазы);
	
	СостояниеДополнений = РаботаСДополнениями.ПолучитьСостояниеДополнений(ТипДополнения, База);
	
	// Фильтрация дополнений, по которым не запланировано отключение (расширения)
	Если ПараметрыЗапроса.Свойство("disable_isnt_planned") Тогда
		КодЭтапаСогласованиеПлановогоОтключения = "000001262";
		КодЭтапаСогласованиеСрочногоОтключения = "000001260";
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СостояниеДополнений", СостояниеДополнений);
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СостояниеДополнений.База КАК База,
			|	СостояниеДополнений.Конфигурация КАК Конфигурация,
			|	СостояниеДополнений.Имя КАК Имя,
			|	СостояниеДополнений.ИмяФайла КАК ИмяФайла,
			|	СостояниеДополнений.Синоним КАК Синоним,
			|	СостояниеДополнений.Версия КАК Версия,
			|	СостояниеДополнений.БезопасныйРежим КАК БезопасныйРежим,
			|	СостояниеДополнений.ЗащитаОтОпасныхДействий КАК ЗащитаОтОпасныхДействий,
			|	СостояниеДополнений.УникальныйИдентификатор КАК УникальныйИдентификатор,
			|	СостояниеДополнений.Активно КАК Активно,
			|	СостояниеДополнений.ТипДополнения КАК ТипДополнения,
			|	СостояниеДополнений.ХешСумма КАК ХешСумма
			|ПОМЕСТИТЬ СостояниеДополнений
			|ИЗ
			|	&СостояниеДополнений КАК СостояниеДополнений
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	СостояниеДополнений.База КАК База,
			|	СостояниеДополнений.Конфигурация КАК Конфигурация,
			|	СостояниеДополнений.Имя КАК Имя,
			|	СостояниеДополнений.ИмяФайла КАК ИмяФайла,
			|	СостояниеДополнений.Синоним КАК Синоним,
			|	СостояниеДополнений.Версия КАК Версия,
			|	СостояниеДополнений.БезопасныйРежим КАК БезопасныйРежим,
			|	СостояниеДополнений.ЗащитаОтОпасныхДействий КАК ЗащитаОтОпасныхДействий,
			|	СостояниеДополнений.УникальныйИдентификатор КАК УникальныйИдентификатор,
			|	СостояниеДополнений.Активно КАК Активно,
			|	СостояниеДополнений.ТипДополнения КАК ТипДополнения,
			|	СостояниеДополнений.ХешСумма КАК ХешСумма,
			|	ЕСТЬNULL(ЗадачиМетеорДополнений.ЗадачаМетеор, ЗНАЧЕНИЕ(Справочник.ЗадачиМетеор.ПустаяСсылка)) КАК ЗадачаМетеор
			|ИЗ
			|	СостояниеДополнений КАК СостояниеДополнений
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВерсииДополнений КАК ВерсииДополнений
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗадачиМетеорДополнений КАК ЗадачиМетеорДополнений
			|			ПО ВерсииДополнений.Ссылка = ЗадачиМетеорДополнений.ВерсияДополнения
			|		ПО СостояниеДополнений.Конфигурация = ВерсииДополнений.Владелец.Конфигурация
			|			И СостояниеДополнений.ТипДополнения = ВерсииДополнений.Владелец.ТипДополнения
			|			И СостояниеДополнений.Имя = ВерсииДополнений.ИмяОбъекта
			|			И СостояниеДополнений.Версия = ВерсииДополнений.Версия";
		
		СостояниеДополнений = Запрос.Выполнить().Выгрузить();
		ИсключаемыеСтроки = Новый Массив();
		Для Каждого СтрокаДополнений Из СостояниеДополнений Цикл
			Если Не ЗначениеЗаполнено(СтрокаДополнений.ЗадачаМетеор) Тогда
				Продолжить;
			КонецЕсли;
			Попытка
				ДанныеЗадачи = ИнтеграцияСМетеор.ПолучитьДанныеЗадачиИзМетеор(СтрокаДополнений.ЗадачаМетеор);
				Если ДанныеЗадачи.КодЭтапа = КодЭтапаСогласованиеПлановогоОтключения
						Или ДанныеЗадачи.КодЭтапа = КодЭтапаСогласованиеСрочногоОтключения Тогда
					ИсключаемыеСтроки.Добавить(СтрокаДополнений);
				КонецЕсли;
			Исключение
				ЗаписьЖурналаРегистрации(
					"Метеор.Получение данных задачи",
					УровеньЖурналаРегистрации.Ошибка,
					,
					СтрокаДополнений.ЗадачаМетеор,
					ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		КонецЦикла;
		Для Каждого ИсключаемаяСтрока Из ИсключаемыеСтроки Цикл
			СостояниеДополнений.Удалить(ИсключаемаяСтрока);
		КонецЦикла;
	КонецЕсли;
	
	// Удаляем несериализуемые колонки
	КоличествоКолонок = СостояниеДополнений.Колонки.Количество();
	Для Сч = 1 По КоличествоКолонок Цикл
		ИндексКолонки = КоличествоКолонок - Сч;
		Колонка =  СостояниеДополнений.Колонки[ИндексКолонки];
		ДопустимыйТипКолонки = 
			Колонка.ТипЗначения.СодержитТип(Тип("Число"))
			Или Колонка.ТипЗначения.СодержитТип(Тип("Строка"))
			Или Колонка.ТипЗначения.СодержитТип(Тип("Дата"))
			Или Колонка.ТипЗначения.СодержитТип(Тип("Булево"));
		Если Не ДопустимыйТипКолонки Тогда
			СостояниеДополнений.Колонки.Удалить(ИндексКолонки);
		КонецЕсли;
	КонецЦикла;
	
	Результат = СтроковыеФункцииУККлиентСервер.ЗаписатьЗначениеJSON(
		ОбщегоНазначения.ТаблицаЗначенийВМассив(СостояниеДополнений));
	ОтветСервиса = ОтветСервиса(200, Результат);
	
	Возврат ОтветСервиса;
	
КонецФункции

Функция ДанныеУстановленногоДополненияGETОтвет(Запрос)
		
	СловарьЗначенийПараметров = РаботаСДополнениями.СловарьКонвертацииПараметровУК();
	ПараметрыЗапроса = РаботаСДополнениямиИнтеграция.КонвертированныеПараметрыЗапроса(Запрос.ПараметрыЗапроса, СловарьЗначенийПараметров);
	
	ТипДополнения = Неопределено;
	ИдентификаторБазы = Неопределено;
	База = Неопределено;
	
	Ошибки = Новый Массив;
	Если Не ПараметрыЗапроса.Свойство("ТипДополнения", ТипДополнения) Или ТипДополнения = Неопределено Тогда
		Ошибки.Добавить(ТекстОшибкиОбязательныйПараметр("ТипДополнения"));
	КонецЕсли;
	Если Не ПараметрыЗапроса.Свойство("УникальныйИдентификатор") И Не ПараметрыЗапроса.Свойство("Имя") Тогда
		Ошибки.Добавить(ТекстОшибкиОбязательныйПараметр("УникальныйИдентификатор или Имя"));
	КонецЕсли;
	Если Не ПараметрыЗапроса.Свойство("ИдентификаторБазы", ИдентификаторБазы) Или ИдентификаторБазы = Неопределено Тогда
		Ошибки.Добавить(ТекстОшибкиОбязательныйПараметр("ИдентификаторБазы"));
	Иначе
		База = Справочники.Базы1С.НайтиПоРеквизиту("ИдентификаторКлиентаДополнений", ИдентификаторБазы);
		Если Не ЗначениеЗаполнено(База) Тогда
			Ошибки.Добавить("Не удалось определить базу по идентификатору");
		КонецЕсли;
	КонецЕсли;
	Если Ошибки.Количество() Тогда
		ТекстОшибки = ПолучитьДвоичныеДанныеИзСтроки(СтрСоединить(Ошибки, Символы.ПС));
		Возврат ОтветСервиса(400, ТекстОшибки, Тип("ДвоичныеДанные"));
	КонецЕсли;
	ДанныеДополнений = РаботаСДополнениями.ПолучитьДанныеДополнения(База, ТипДополнения, ПараметрыЗапроса);
	ОтветСервиса = ОтветСервиса(200, ДанныеДополнений, Тип("ДвоичныеДанные"));
	
	Возврат ОтветСервиса;
	
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
	СтруктураОтвета.Вставить("Результат", "");
	СтруктураОтвета.Вставить("Статус", "");
	СтруктураОтвета.Вставить("ПредставлениеОшибки", "");
	
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
	Ответ.Заголовки.Вставить("Content-Type", "application/json;charset=utf-8");
	
	Если ТипТелаОтвета = Неопределено Или ТипТелаОтвета = Тип("Строка") Тогда
		Ответ.УстановитьТелоИзСтроки(ТелоОтвета);
	ИначеЕсли ТипТелаОтвета = Тип("ДвоичныеДанные") Тогда
		Ответ.УстановитьТелоИзДвоичныхДанных(ТелоОтвета);
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ПолучитьДополненияJSON(ТипДополнения, ИдентификаторБазы, Статус = Неопределено)
	
	Результат = СтроковыеФункцииУККлиентСервер.ЗаписатьЗначениеJSON(Новый Массив);
	Статус = ?(Статус = Неопределено, Перечисления.СтатусыИсторииХранилищ.Перенос, Статус);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТипДополнения", ТипДополнения);
	Запрос.УстановитьПараметр("ИдентификаторБазы", ИдентификаторБазы);
	Запрос.УстановитьПараметр("Статус", Статус);
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СтатусыДополненийСрезПоследних.ВерсияДополнения.Владелец КАК ВерсияДополненияВладелец
		|ПОМЕСТИТЬ СоласованныеДополнения
		|ИЗ
		|	РегистрСведений.СтатусыДополнений.СрезПоследних КАК СтатусыДополненийСрезПоследних
		|ГДЕ
		|	СтатусыДополненийСрезПоследних.Статус = &Статус
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Дополнения.Ссылка КАК УникальныйИдентификатор,
		|	Дополнения.Наименование КАК Наименование,
		|	ПРЕДСТАВЛЕНИЕ(Дополнения.ТипДополнения) КАК ТипДополнения
		|ИЗ
		|	СоласованныеДополнения КАК СоласованныеДополнения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Дополнения КАК Дополнения
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Базы1С КАК Базы1С
		|			ПО Дополнения.Конфигурация = Базы1С.Владелец
		|			И (Базы1С.ИдентификаторКлиентаДополнений = &ИдентификаторБазы)
		|		ПО СоласованныеДополнения.ВерсияДополненияВладелец = Дополнения.Ссылка
		|ГДЕ
		|	Дополнения.ТипДополнения = &ТипДополнения";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Модификация ОбщегоНазначения.ТаблицаЗначенийВМассив()
	СтруктураСтрокой = "";
	НужнаЗапятая = Ложь;
	Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
		Если НужнаЗапятая Тогда
			СтруктураСтрокой = СтруктураСтрокой + ",";
		КонецЕсли;
		СтруктураСтрокой = СтруктураСтрокой + Колонка.Имя;
		НужнаЗапятая = Истина;
	КонецЦикла;

	МассивСтруктур = Новый Массив;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Новый Структура(СтруктураСтрокой);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка,, "УникальныйИдентификатор");
		НоваяСтрока.УникальныйИдентификатор = Строка(Выборка.УникальныйИдентификатор.УникальныйИдентификатор());
		МассивСтруктур.Добавить(НоваяСтрока);
	КонецЦикла;
	
	Результат = СтроковыеФункцииУККлиентСервер.ЗаписатьЗначениеJSON(МассивСтруктур);
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьВерсииJSON(Дополнение)
	
	Результат = СтроковыеФункцииУККлиентСервер.ЗаписатьЗначениеJSON(Новый Массив);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дополнение", Дополнение);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииДополнений.Наименование КАК Наименование,
		|	ВерсииДополнений.Версия КАК Версия,
		|	ПРЕДСТАВЛЕНИЕ(ВерсииДополнений.Автор) КАК Автор,
		|	ВерсииДополнений.Ссылка КАК УникальныйИдентификатор,
		|	ВерсииДополненийПрисоединенныеФайлы.Наименование + ""."" + ВерсииДополненийПрисоединенныеФайлы.Расширение КАК ИмяФайла,
		|	ВерсииДополнений.ДатаСоздания КАК ДатаСоздания,
		|	ВерсииДополнений.Описание КАК Описание,
		|	ЕСТЬNULL(ЗадачиМетеорДополнений.ЗадачаМетеор.Код, """") КАК ЗадачаМетеор
		|ИЗ
		|	РегистрСведений.СтатусыДополнений.СрезПоследних КАК СтатусыДополненийСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВерсииДополнений КАК ВерсииДополнений
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВерсииДополненийПрисоединенныеФайлы КАК ВерсииДополненийПрисоединенныеФайлы
		|			ПО (ВерсииДополненийПрисоединенныеФайлы.ВладелецФайла = ВерсииДополнений.Ссылка)
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗадачиМетеорДополнений КАК ЗадачиМетеорДополнений
		|			ПО ВерсииДополнений.Ссылка = ЗадачиМетеорДополнений.ВерсияДополнения
		|		ПО СтатусыДополненийСрезПоследних.ВерсияДополнения = ВерсииДополнений.Ссылка
		|			И (СтатусыДополненийСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыИсторииХранилищ.Перенос))
		|ГДЕ
		|	ВерсииДополнений.Владелец = &Дополнение";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Модификация ОбщегоНазначения.ТаблицаЗначенийВМассив()
	СтруктураСтрокой = "";
	НужнаЗапятая = Ложь;
	Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
		Если НужнаЗапятая Тогда
			СтруктураСтрокой = СтруктураСтрокой + ",";
		КонецЕсли;
		СтруктураСтрокой = СтруктураСтрокой + Колонка.Имя;
		НужнаЗапятая = Истина;
	КонецЦикла;

	МассивСтруктур = Новый Массив;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Новый Структура(СтруктураСтрокой);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка,, "УникальныйИдентификатор");
		НоваяСтрока.УникальныйИдентификатор = Строка(Выборка.УникальныйИдентификатор.УникальныйИдентификатор());
		МассивСтруктур.Добавить(НоваяСтрока);
	КонецЦикла;
	
	Результат = СтроковыеФункцииУККлиентСервер.ЗаписатьЗначениеJSON(МассивСтруктур);
	
	Возврат Результат;
	
КонецФункции

Функция ТекстОшибкиОбязательныйПараметр(ИмяПраметра)
	Возврат СтрШаблон("Не передан обязательный параметр ""%1"".", ИмяПраметра);
КонецФункции

#КонецОбласти

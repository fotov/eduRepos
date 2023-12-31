
#Область ПрограммныйИнтерфейс

Функция ДобавитьВерсиюВОчередьВыгрузки(ВерсияХранилища) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Если ВерсияЕстьВОчереди(ВерсияХранилища) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Менеджер = РегистрыСведений.ОчередьПолученияВерсийКонфигурации.СоздатьМенеджерЗаписи();
	Менеджер.ВерсияХранилища = ВерсияХранилища;
	Менеджер.ДатаЗапроса = ТекущаяДатаСеанса();
	Менеджер.Записать(Ложь);
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьПутьФайлаВерсии(ВерсияХранилища) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ПутьФайла = ПолучитьПутьФайлаВерсииЕслиЕстьВКеше(ВерсияХранилища);
	Если ЗначениеЗаполнено(ПутьФайла) Тогда
		Возврат ПутьФайла;
	КонецЕсли;
	Если ДобавитьВерсиюВОчередьВыгрузки(ВерсияХранилища) Тогда
		ПутьФайла = ВыгрузитьВерсиюВКеш(Новый Структура("ВерсияХранилища", ВерсияХранилища));
	КонецЕсли;

	Возврат ПутьФайла;
	
КонецФункции

Функция ПолучитьПутьФайлаВерсииПоИдентификаторам(ПараметрыПолучения) Экспорт
	
	Перем ВерсияХранилища;
	Перем Хранилище;
	Перем ХранилищеНаименование;
	Перем ВерсияНомер;
	
	УстановитьПривилегированныйРежим(Истина);
	Если Не ПараметрыПолучения.Свойство("ВерсияХранилища", ВерсияХранилища) Тогда
		ПараметрыВерсии = Новый Структура("Хранилище,ХранилищеНаименование,ВерсияНомер");
		ЗаполнитьЗначенияСвойств(ПараметрыВерсии, ПараметрыПолучения);
		ВерсияХранилища = ВерсияИсторииХранилищаПоРеквизитам(ПараметрыВерсии);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ВерсияХранилища) Тогда
		ВызватьИсключение "Необходимо указать версию хранилища для выгрузки.";
	КонецЕсли;
	
	Возврат ПолучитьПутьФайлаВерсии(ВерсияХранилища);
	
КонецФункции

Функция ПолучитьПутьФайлаВерсииЕслиЕстьВКеше(ВерсияХранилища) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаписатьЗапросВерсии(ВерсияХранилища);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОчередьПолученияВерсийКонфигурации.ПутьКФайлу КАК ПутьКФайлу
		|ИЗ
		|	РегистрСведений.ОчередьПолученияВерсийКонфигурации КАК ОчередьПолученияВерсийКонфигурации
		|ГДЕ
		|	ОчередьПолученияВерсийКонфигурации.ВерсияХранилища = &ВерсияХранилища";
	Запрос.УстановитьПараметр("ВерсияХранилища", ВерсияХранилища);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ПутьКФайлу;
	
КонецФункции

Функция ПолучитьПутьФайлаВерсииЕслиЕстьВКешеПоИдентификаторам(ХранилищеНаименование, ВерсияНомер) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыВерсии = Новый Структура("ХранилищеНаименование,ВерсияНомер", ХранилищеНаименование, ВерсияНомер);
	ВерсияХранилища = ВерсияИсторииХранилищаПоРеквизитам(ПараметрыВерсии);
	Если Не ЗначениеЗаполнено(ВерсияХранилища) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат ПолучитьПутьФайлаВерсииЕслиЕстьВКеше(ВерсияХранилища);
	
КонецФункции

Функция ВыгрузитьВерсиюВКеш(ПараметрыВыгрузки) Экспорт
	
	Перем ВерсияХранилища;
	Перем Хранилище;
	Перем ВерсияНомер;
	
	УстановитьПривилегированныйРежим(Истина);
	ЕстьПараметрВерсияХранилища = ПараметрыВыгрузки.Свойство("ВерсияХранилища", ВерсияХранилища);
	ЕстьПараметрХранилище = ПараметрыВыгрузки.Свойство("Хранилище", Хранилище);
	ЕстьПараметрВерсияНомер = ПараметрыВыгрузки.Свойство("ВерсияНомер", ВерсияНомер);
	
	Если Не ЕстьПараметрВерсияХранилища И ЕстьПараметрХранилище И ЕстьПараметрВерсияНомер Тогда
		ПараметрыВерсии = Новый Структура("Хранилище,ВерсияНомер", Хранилище, ВерсияНомер);
		ВерсияХранилища = ВерсияИсторииХранилищаПоРеквизитам(ПараметрыВерсии);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ВерсияХранилища) Тогда
		ВызватьИсключение "Необходимо указать версию хранилища для выгрузки.";
	КонецЕсли;
	Если Не ПараметрыВыгрузки.Свойство("Хранилище", Хранилище) Или Не ПараметрыВыгрузки.Свойство("ВерсияНомер", ВерсияНомер) Тогда
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВерсияХранилища, "Код,Владелец");
		Хранилище = Реквизиты.Владелец;
		ВерсияНомер = Реквизиты.Код;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОчередьПолученияВерсийКонфигурации");
		ЭлементБлокировки.УстановитьЗначение("ВерсияХранилища", ВерсияХранилища);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Менеджер = РегистрыСведений.ОчередьПолученияВерсийКонфигурации.СоздатьМенеджерЗаписи();
		Менеджер.ВерсияХранилища = ВерсияХранилища;
		Менеджер.Прочитать();
		Если Не Менеджер.Выбран() Тогда
			ВызватьИсключение "Не найдена запись очереди для выгрузки версии.";
		КонецЕсли;
		Менеджер.Записать();
		ПутьКФайлу = КонвейерОбработкиСервер.ПолучениеФайлаКонфигурацииИзХранилища(
			Хранилище,
			ВерсияНомер);
		Если ПустаяСтрока(ПутьКФайлу) Тогда
			ВызватьИсключение "При выгрузке файла версии возникла ошибка.";
		КонецЕсли;
		Менеджер.ПутьКФайлу = ПутьКФайлу;
		ФайлВерсии = Новый Файл(Менеджер.ПутьКФайлу);
		Менеджер.РазмерФайла = ФайлВерсии.Размер();
		Менеджер.Записать();
		ЗафиксироватьТранзакцию();
		Возврат Менеджер.ПутьКФайлу;
	Исключение
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		Возврат "";
	КонецПопытки;
	
КонецФункции

Процедура ВыгрузитьВерсиюВКешАсинх(ВерсияХранилища) Экспорт
	ПараметрПроцедуры = Новый Структура("ВерсияХранилища", ВерсияХранилища);
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияПроцедуры();
	ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, "КешВерсийХранилищ.ВыгрузитьВерсиюВКеш", ПараметрПроцедуры);
КонецПроцедуры

Функция ВерсияИсторииХранилищаПоРеквизитам(ПараметрыПоискаВерсии) Экспорт
	
	РезультатПоУмолчанию = Справочники.ИсторияХранилища.ПустаяСсылка();
	Хранилище = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПоискаВерсии, "Хранилище");
	ХранилищеНаименование = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПоискаВерсии, "ХранилищеНаименование");
	ВерсияНомер = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПоискаВерсии, "ВерсияНомер");
	ПутьКХранилищу = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПоискаВерсии, "ПутьКХранилищу");
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ИсторияХранилища.Ссылка КАК ВерсияХранилища
		|ИЗ
		|	Справочник.ИсторияХранилища КАК ИсторияХранилища
		|ГДЕ
		|	ИсторияХранилища.Владелец = &ХранилищеПоиск
		|	И ИсторияХранилища.Код = &ВерсияНомер";
	Если Не ЗначениеЗаполнено(ВерсияНомер) Тогда
		Возврат РезультатПоУмолчанию;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Хранилище) И Не ЗначениеЗаполнено(ХранилищеНаименование) И Не ЗначениеЗаполнено(ПутьКХранилищу) Тогда
		Возврат РезультатПоУмолчанию;
	ИначеЕсли Не ЗначениеЗаполнено(Хранилище) И ЗначениеЗаполнено(ХранилищеНаименование) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИсторияХранилища.Владелец = &ХранилищеПоиск", "ИсторияХранилища.Владелец.Наименование = &ХранилищеПоиск");
		ХранилищеПоиск = ХранилищеНаименование;
	ИначеЕсли Не ЗначениеЗаполнено(Хранилище) И ЗначениеЗаполнено(ПутьКХранилищу) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИсторияХранилища.Владелец = &ХранилищеПоиск", "ВЫРАЗИТЬ(ИсторияХранилища.Владелец.Путь КАК Строка(1024)) = &ХранилищеПоиск");
		ХранилищеПоиск = ПутьКХранилищу;
	Иначе
		ХранилищеПоиск = Хранилище;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ВерсияНомер", ВерсияНомер);
	Запрос.УстановитьПараметр("ХранилищеПоиск", ХранилищеПоиск);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат РезультатПоУмолчанию;
	КонецЕсли;
	Выборка = РезультатЗапроса.Выбрать();		
	Выборка.Следующий();
	
	Возврат Выборка.ВерсияХранилища;
	
КонецФункции

Процедура ЗаписатьЗапросВерсии(ВерсияХранилища) Экспорт
	Менеджер = РегистрыСведений.ИсторияЗапросовВерсийХранилища.СоздатьМенеджерЗаписи();
	Менеджер.ВерсияХранилища = ВерсияХранилища;
	Менеджер.Период = ТекущаяДатаСеанса();
	Менеджер.ДатаЗаписиУниверсальная = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Менеджер.Записать(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВерсияЕстьВОчереди(ВерсияХранилища)
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК ЕстьВОчереди
		|ИЗ
		|	РегистрСведений.ОчередьПолученияВерсийКонфигурации КАК ОчередьПолученияВерсийКонфигурации
		|ГДЕ
		|	ОчередьПолученияВерсийКонфигурации.ВерсияХранилища = &ВерсияХранилища";
	Запрос.УстановитьПараметр("ВерсияХранилища", ВерсияХранилища);
	РезультатЗапроса = Запрос.Выполнить();
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

#КонецОбласти
#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьСоответсивеТиповОбъектов() Экспорт
	Результат = Новый Соответствие;
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТипыОбъектов.Код КАК Код,
		|	ТипыОбъектов.Наименование КАК Наименование,
		|	ТипыОбъектов.СкрыватьВНазванииОбъекта КАК СкрыватьВНазванииОбъекта,
		|	ТипыОбъектов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ТипыОбъектов КАК ТипыОбъектов";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Значение = Новый Структура("Ссылка, Наименование, СкрыватьВНазванииОбъекта");
		ЗаполнитьЗначенияСвойств(Значение, Выборка);
		Результат.Вставить(Выборка.Код, Значение);
	КонецЦикла;
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьСправочник() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТипыОбъектов.Код КАК Код,
		|	ТипыОбъектов.Наименование КАК Наименование,
		|	ТипыОбъектов.НаименованиеВоМножественномЧисле КАК НаименованиеВоМножественномЧисле,
		|	ТипыОбъектов.СкрыватьВНазванииОбъекта КАК СкрыватьВНазванииОбъекта,
		|	ТипыОбъектов.ЭтоКорень КАК ЭтоКорень
		|ИЗ
		|	Справочник.ТипыОбъектов КАК ТипыОбъектов
		|ГДЕ
		|	ЛОЖЬ";
	СоответствиеОбъектов = Запрос.Выполнить().Выгрузить();
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "cf4abeab-37b2-11d4-940f-008048da11f9", "Конфигурация", "Конфигурация", Истина, Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "37f2fa9a-b276-11d4-9435-004095e12fc7", "Подсистема", "Подсистемы");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "0fe48980-252d-11d6-a3c7-0050bae0a776", "ОбщийМодуль", "ОбщиеМодули");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "24c43748-c938-45d0-8d14-01424a72b11e", "ПараметрCеанса", "ПараметрыCеанса");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "09736b02-9cac-4e3f-b4f7-d3e9576ab948", "Роль", "Роли");
	//СоответствиеОбъектовВставить(СоответствиеОбъектов, "???", "ОбщийРеквизит", "ОбщиеРеквизиты");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "857c4a91-e5f4-4fac-86ec-787626f1c108", "ПланОбмена", "ПланыОбмена");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "3e7bfcc0-067d-11d6-a3c7-0050bae0a776", "КритерийОтбора", "КритерииОтбора");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "4e828da6-0f44-4b5b-b1c0-a2b3cfe7bdcc", "ПодпискаНаСобытие", "ПодпискиНаСобытие");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "11bdaf85-d5ad-4d91-bb24-aa0eee139052", "РегламентноеЗадание", "РегламентныеЗадания");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "af547940-3268-434f-a3e7-e47d6d2638c3", "ФункциональнаяОпция", "ФункциональныеОпции");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "30d554db-541e-4f62-8970-a1c6dcfeb2bc", "ПараметрФункциональнойОпций", "ПараметрыФункциональныхОпций");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "c045099e-13b9-4fb6-9d50-fca00202971e", "ОпределяемыйТип", "ОпределяемыеТипы");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "46b4cd97-fd13-4eaa-aba2-3bddd7699218", "ХранилищеВариантовОтчетов", "ХранилищаВариантовОтчетов");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "2f1a5187-fb0e-4b05-9489-dc5dd6412348", "ОбщаяКоманда", "ОбщиеКоманды");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "1c57eabe-7349-44b3-b1de-ebfeab67b47d", "ГруппаКоманд", "ГруппыКоманд");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "07ee8426-87f1-11d5-b99c-0050bae0a95d", "ОбщаяФорма", "ОбщиеФормы");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "39bddf6a-0c3c-452b-921c-d99cfa1c2f1b", "Интерфейс", "Интерфейсы");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "0c89c792-16c3-11d5-b96b-0050bae0a95d", "ОбщийМакет", "ОбщиеМакеты");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "7dcd43d9-aca5-4926-b549-1842e6a4e8cf", "ОбщаяКартинка", "ОбщиеКартинки");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "cc9df798-7c94-4616-97d2-7aa0b7bc515e", "XDTOПакет", "XDTOПакеты");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "8657032e-7740-4e1d-a3ba-5dd6e8afb78f", "WebСервис", "WebСервисы");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "0fffc09c-8f4c-47cc-b41c-8d5c5a221d79", "HTTPСервис", "HTTPСервисы");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "d26096fb-7a5d-4df9-af63-47d04771fa9b", "WSСсылка", "WSСсылки");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "58848766-36ea-4076-8800-e91eb49590d7", "ЭлементСтиля", "ЭлементыСтиля");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "3e5404af-6ef8-4c73-ad11-91bd2dfac4c8", "Стиль", "Стили");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "9cd510ce-abfc-11d4-9434-004095e12fc7", "Язык", "Языки");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "0195e80c-b157-11d4-9435-004095e12fc7", "Константа", "Константы");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "cf4abea6-37b2-11d4-940f-008048da11f9", "Справочник", "Справочники");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "061d872a-5787-460e-95ac-ed74ea3a3e84", "Документ", "Документы");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "bc587f20-35d9-11d6-a3c7-0050bae0a776", "Последовательность", "Последовательности");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "36a8e346-9aaa-4af9-bdbd-83be3c177977", "НумераторДокументов", "НумераторыДокументов");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "4612bd75-71b7-4a5c-8cc5-2b0b65f9fa0d", "ЖурналДокументов", "ЖурналыДокументов");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "f6a80749-5ad7-400b-8519-39dc5dff2542", "Перечисление", "Перечисления");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "631b75a0-29e2-11d6-a3c7-0050bae0a776", "Отчет", "Отчеты");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "bf845118-327b-4682-b5c6-285d2a0eb296", "Обработка", "Обработки");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "82a1b659-b220-4d94-a9bd-14d757b95a48", "ПланВидовХарактеристик", "ПланыВидовХарактеристик");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "2deed9b8-0056-4ffe-a473-c20a6c32a0bc", "ПланСчетов", "ПланыСчетов");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "30b100d6-b29f-47ac-aec7-cb8ca8a54767", "ПланВидовРасчета", "ПланыВидовРасчета");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "13134201-f60b-11d5-a3c7-0050bae0a776", "РегистрСведений", "РегистрыСведений");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "b64d9a40-1642-11d6-a3c7-0050bae0a776", "РегистрНакоплений", "РегистрыНакоплений");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "238e7e88-3c5f-48b2-8a3b-81ebbecb20ed", "РегистрБухгалтерии", "РегистрыБухгалтерии");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "f2de87a8-64e5-45eb-a22d-b3aedab050e7", "РегистрРасчета", "РегистрыРасчета");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "fcd3404e-1523-48ce-9bc0-ecdb822684a1", "БизнесПроцесс", "БизнесПроцессы");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "3e63355c-1378-4953-be9b-1deb5fb6bec5", "Задача", "Задачи");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "5274d9fc-9c3a-4a71-8f5e-a0db8ab23de5", "ВнешнийИсточник", "ВнешниеИсточники");
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "e3403acd-1c95-421b-87e4-4dfa29d38b52", "Таблица", "Таблицы");
	
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "fdf816d2-1ead-11d5-b975-0050bae0a95d", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "fdf816d2-1ead-11d5-b975-0050bae0a95d", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "13134204-f60b-11d5-a3c7-0050bae0a776", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "d5b0e5ed-256d-401c-9c36-f630cafd8a62", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "eb2b78a8-40a6-4b7e-b1b3-6ca9966cbc94", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "17816ebc-4068-496e-adc4-8879945a832f", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "a3b368c0-29e2-11d6-a3c7-0050bae0a776", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "00867c40-06b1-11d6-a3c7-0050bae0a776", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "87c509ab-3d38-4d67-b379-aca796298578", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "5372e285-03db-4f8c-8565-fe56f1aea40e", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "ec81ad10-ca07-11d5-b9a5-0050bae0a95d", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "87c509ab-3d38-4d67-b379-aca796298578", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "fb880e93-47d7-4127-9357-a20e69c17545", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "33f2e54b-37ce-4a7a-a569-b648d7aa4634", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "3f58cbfb-4172-4e54-be49-561a579bb38b", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "3f7a8120-b71a-4265-98bf-4d9bc09b7719", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "a2cb086c-db98-43e4-a1a9-0760ab048f8d", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "b64d9a44-1642-11d6-a3c7-0050bae0a776", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "d3b5d6eb-4ea2-4610-a3e2-624d4e815934", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "b8533c0c-2342-4db3-91a2-c2b08cbf6b23", "*Форма", "*Форма", Истина);
	СоответствиеОбъектовВставить(СоответствиеОбъектов, "3daea016-69b7-4ed4-9453-127911372fe6", "*Макет", "*Макет", Истина);
	
	Для Каждого Эл Из СоответствиеОбъектов Цикл
		СоздатьЭлементСправочника(Эл);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоответствиеОбъектовВставить(СоответствиеОбъектов, Код, Наименование, НаименованиеВоМножественномЧисле = "", СкрыватьВНазванииОбъекта = Ложь, ЭтоКорень = Ложь)
	Строка = СоответствиеОбъектов.Добавить();
	Строка.Код = Код;
	Строка.Наименование = Наименование;
	Строка.НаименованиеВоМножественномЧисле = НаименованиеВоМножественномЧисле;
	Строка.СкрыватьВНазванииОбъекта = СкрыватьВНазванииОбъекта;
	Строка.ЭтоКорень = ЭтоКорень;
КонецПроцедуры

Процедура СоздатьЭлементСправочника(Данные)
	Ссылка = Справочники.ТипыОбъектов.НайтиПоНаименованию(Данные.Наименование, Истина);
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Объект = Ссылка.ПолучитьОбъект();
	Иначе
		Объект = Справочники.ТипыОбъектов.СоздатьЭлемент();
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Объект, Данные);
	Объект.Записать();
КонецПроцедуры

#КонецОбласти

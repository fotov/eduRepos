//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Методы для получения и изменения данных, связанных с Метеор
//  
//////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция НомерЗадачиИзСтроки(ПроверяемаяСтрока) Экспорт

	НомерЗадачи = "";

	Для Итератор = 1 По СтрДлина(ПроверяемаяСтрока) Цикл
		Символ = Сред(ПроверяемаяСтрока, Итератор, 1);
		Если Символ = " " Или Символ = Символы.Таб Или Символ = Символы.ПС Тогда
			Прервать;
		КонецЕсли;
		НомерЗадачи = НомерЗадачи + Символ;
	КонецЦикла;
	Если СтрЗаканчиваетсяНа(НомерЗадачи, ".") Тогда
		НомерЗадачи = Лев(НомерЗадачи, СтрДлина(НомерЗадачи) - 1);
	КонецЕсли;
	Возврат НомерЗадачи;

КонецФункции

#КонецОбласти

#Область СлужебныеПрограммныйИнтерфейс

Процедура ЗагрузкаИсторииЭтаповЗадачМетеорОбработчикЗадания() Экспорт
	
	Настройка = ПланыВидовХарактеристик.НастройкиПрограммы.ОтметкаВремениЗагрузкиЭтаповМетеор;
	НачалоПериода = РегистрыСведений.ЗначенияНастроекПрограммы.ПолучитьЗначениеНастройки(Настройка);
	НачалоПериода = Макс(НачалоПериода, ТекущаяДатаСеанса() - 7 * 24 * 3600); // старые данные не актуальны
	НачалоПериода = Макс(НачалоПериода, '20231003'); // Дата с которой даты этапов стали совпадать
	
	КонецПериода = ТекущаяДатаСеанса();
	ЗагрузкаИсторииЭтаповЗадачМетеорЗаПериод(НачалоПериода, КонецПериода);
	РегистрыСведений.ЗначенияНастроекПрограммы.ЗаписатьЗначениеНастройки(Настройка, КонецПериода);
	
КонецПроцедуры

Функция ЗагрузкаИсторииЭтаповЗадачМетеорЗаПериод(НачалоПериода, КонецПериода) Экспорт
	
	ЭтапыМетеор = ИнтеграцияСМетеор.ИзмененияЭтаповЗадачМетеорЗаПериод(НачалоПериода, КонецПериода);
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЭтапыМетеор.Дата КАК Дата,
		|	ЭтапыМетеор.ЗадачаМетеор КАК ЗадачаМетеор,
		|	ЭтапыМетеор.ЭтапМетеор КАК ЭтапМетеор,
		|	ЭтапыМетеор.Исполнитель КАК Исполнитель,
		|	ЭтапыМетеор.стрИсполнитель КАК стрИсполнитель
		|ПОМЕСТИТЬ ЭтапыМетеор
		|ИЗ
		|	&ЭтапыМетеор КАК ЭтапыМетеор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЭтапыМетеор.ЗадачаМетеор КАК ЗадачаМетеор,
		|	ЭтапыМетеор.Дата КАК Дата,
		|	ЭтапыМетеор.ЭтапМетеор КАК Этап,
		|	ЭтапыМетеор.Исполнитель КАК Исполнитель,
		|	ЭтапыМетеор.стрИсполнитель КАК стрИсполнитель,
		|	NULL КАК Тип,
		|	""Дозагрузка"" КАК Комментарий
		|ИЗ
		|	ЭтапыМетеор КАК ЭтапыМетеор
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияЭтаповЗадачиМетеор КАК ЭтапыРепос
		|		ПО ЭтапыМетеор.ЗадачаМетеор = ЭтапыРепос.ЗадачаМетеор
		|			И ЭтапыМетеор.Дата = ЭтапыРепос.Дата
		|			И ЭтапыМетеор.ЭтапМетеор = ЭтапыРепос.Этап
		|ГДЕ
		|	ЭтапыРепос.Этап ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	ЗадачаМетеор";
	Запрос.УстановитьПараметр("ЭтапыМетеор", ЭтапыМетеор);
	
	НедостающиеСтатусы = Запрос.Выполнить().Выгрузить();
	Для Каждого НедостающийСтатус Из НедостающиеСтатусы Цикл
		РегистрыСведений.ИсторияЭтаповЗадачиМетеор.Отразить(
			НедостающийСтатус.ЗадачаМетеор, 
			НедостающийСтатус.Этап, 
			НедостающийСтатус.Исполнитель, 
			НедостающийСтатус.стрИсполнитель, 
			НедостающийСтатус.Тип, 
			НедостающийСтатус.Комментарий, 
			НедостающийСтатус.Дата
		);
	КонецЦикла;
	
	Возврат НедостающиеСтатусы.Количество();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

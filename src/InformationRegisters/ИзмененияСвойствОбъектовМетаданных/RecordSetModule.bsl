
Процедура ПриЗаписи(Отказ, Замещение)
	
	ЗаписатьИзмененияВОчередьОповещения();
	
КонецПроцедуры

Процедура ЗаписатьИзмененияВОчередьОповещения()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИзмененияСвойств", ЭтотОбъект.Выгрузить());
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ИзмененияСвойств.ВерсияХранилища КАК Справочник.ИсторияХранилища) КАК ВерсияХранилища,
		|	ИзмененияСвойств.ИмяОбъектаМетаданных КАК ИмяОбъектаМетаданных
		|ПОМЕСТИТЬ ИзмененияСвойств
		|ИЗ
		|	&ИзмененияСвойств КАК ИзмененияСвойств
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИзмененияСвойств.ИмяОбъектаМетаданных КАК ИмяОбъектаМетаданных,
		|	ИзмененияСвойств.ВерсияХранилища.Владелец.Владелец КАК Конфигурация
		|ИЗ
		|	ИзмененияСвойств КАК ИзмененияСвойств";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Менеджер = РегистрыСведений.ОчередьОповещенийИзмененияМетаданныхRMQ.СоздатьМенеджерЗаписи();
		Менеджер.Период = ТекущаяДатаСеанса();
		Менеджер.Конфигурация = Выборка.Конфигурация;
		Менеджер.ИмяОбъектаМетаданных = Выборка.ИмяОбъектаМетаданных;
		Менеджер.Статус = Перечисления.СтатусыОперацийОбработкиОчереди.ОжидаетОбработки;
		Менеджер.Записать();
	КонецЦикла;
		
КонецПроцедуры

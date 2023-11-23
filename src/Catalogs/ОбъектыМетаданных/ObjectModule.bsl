#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	ДатаИзменения = ТекущаяДата();
	
	ПредыдущееНаименование = ?(ЭтоНовый(), "", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Наименование"));
	ДополнительныеСвойства.Вставить("ПредыдущееНаименование", ПредыдущееНаименование);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Не ДополнительныеСвойства.ПредыдущееНаименование = Наименование Тогда
		Набор = РегистрыСведений.ИсторияИменОбъектовМетаданных.СоздатьНаборЗаписей();
		Запись = Набор.Добавить();
		Запись.Период = ТекущаяДатаСеанса();
		Запись.ОбъектМетаданных = Ссылка;
		Запись.Наименование = Наименование;
		Набор.Записать(Ложь);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти

#Иначе
  ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли


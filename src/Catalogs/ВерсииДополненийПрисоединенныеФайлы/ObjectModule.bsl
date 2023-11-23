
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область ОбработчикиПроведения
#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОчередьВыгрузкиДополнений");
	ЭлементБлокировки.УстановитьЗначение("ВерсияДополнения", ВладелецФайла);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	РаботаСДополнениямиСлужебный.ЗаписатьСтатусВыгрузки(ВладелецФайла, ТекущаяДатаСеанса(), Перечисления.СтатусыВыгрузкиДополнений.ВОчереди);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти

#Иначе
  ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
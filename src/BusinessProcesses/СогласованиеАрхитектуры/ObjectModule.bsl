#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытийКартыМаршрута

Процедура ПеревестиНаСледующийЭтапПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	Если Не ИнтеграцияСМетеор.ПроверитьТекущийЭтапЗадачиВМетеоре(ЗадачаМетеор, Справочники.ЭтапыЗадачиМетеор.СогласоватьАрхитектуру) Тогда
		Возврат;
	КонецЕсли;
	
	Этапы = РегистрыСведений.СледующиеЭтапыЗадачиПоТочкеМаршрута.ПолучитьЭтапыПоТочкеМаршрута(
		Бизнеспроцессы.СогласованиеАрхитектуры.ТочкиМаршрута.ПеревестиНаСледующийЭтап,
		Согласовано);
	ИнтеграцияСМетеор.ПеревестиЗадачуНаЭтапВМетеоре(ЗадачаМетеор, Этапы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийМодуля

#КонецОбласти

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#Иначе
  ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
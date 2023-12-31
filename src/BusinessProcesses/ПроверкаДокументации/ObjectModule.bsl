#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытийКартыМаршрута

Процедура ПеревестиНаСледующийЭтапПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	Если Не ИнтеграцияСМетеор.ПроверитьТекущийЭтапЗадачиВМетеоре(ЗадачаМетеор, Справочники.ЭтапыЗадачиМетеор.ПроверкаДокументации) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК ПроверкиСогласованы
		|ИЗ
		|	РегистрСведений.РезультатыПроверкиДокументации.СрезПоследних КАК РезультатыПроверкиДокументацииСрезПоследних
		|ГДЕ
		|	РезультатыПроверкиДокументацииСрезПоследних.ЗадачаМетеор = &ЗадачаМетеор
		|
		|ИМЕЮЩИЕ
		|	СУММА(ВЫБОР
		|			КОГДА РезультатыПроверкиДокументацииСрезПоследних.Результат = ЗНАЧЕНИЕ(Перечисление.ВариантыРезультатовПроверкиДокументации.НеСогласовано)
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) = 0 И
		|	КОЛИЧЕСТВО(РезультатыПроверкиДокументацииСрезПоследних.ЗадачаМетеор) > 0";
	
	Запрос.УстановитьПараметр("ЗадачаМетеор", ЗадачаМетеор);
	РезультатЗапроса = Запрос.Выполнить();
	Согласовано = Не РезультатЗапроса.Пустой();
	
	Этапы = РегистрыСведений.СледующиеЭтапыЗадачиПоТочкеМаршрута.ПолучитьЭтапыПоТочкеМаршрута(
		Бизнеспроцессы.ПроверкаДокументации.ТочкиМаршрута.Действие1,
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
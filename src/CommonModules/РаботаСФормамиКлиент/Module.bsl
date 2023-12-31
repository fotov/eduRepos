#Область ПрограммныйИнтерфейс

Процедура ОбработкаКликаПоСсылке(Элемент, ДанныеСобытия, СтандартнаяОбработка) Экспорт
	Если ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда
		Если СтрНачинаетсяС(ДанныеСобытия.Href, "e1c") Тогда
			СтандартнаяОбработка = Ложь;
			ПерейтиПоНавигационнойСсылке(ДанныеСобытия.Href);
		ИначеЕсли СтрНачинаетсяС(нрег(ДанныеСобытия.Href), "srvr") Тогда
			СтандартнаяОбработка = Ложь;
			Запуск1СПредприятия(ДанныеСобытия.Href);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура Запуск1СПредприятия(СтрокаСоединения) Экспорт
	Части = СтрРазделить(СтрокаСоединения, "=;'""", Ложь);
	Если Части.Количество()<4 Тогда
		ВызватьИсключение "Не верный формат строки соединения " + СтрокаСоединения;
	КонецЕсли;
	РежимЗапуска = "";
	Приложение = "ENTERPRISE";
	Если Части.Количество()>4 Тогда
		Если Части[4] = "DESIGNER" Тогда
			Приложение = "DESIGNER";
		Иначе 	
			РежимЗапуска = "/"+Части[4]; // RunModeManagedApplication или RunModeOrdinaryApplication
		КонецЕсли;
	КонецЕсли;
	
	Стартер = "C:\Program Files\1cv8\common\1cestart.exe";
	Файл = Новый Файл(Стартер);
	Если Не Файл.Существует() Тогда
		Стартер = СтрЗаменить(Стартер, "\Program Files\", "\Program Files (x86)\");
	КонецЕсли;
	
	НачатьЗапускПриложения(Новый ОписаниеОповещения, СтрШаблон(
		"""%5"" %4 /S%1\%2 %3", Части[1], Части[3], РежимЗапуска, Приложение, Стартер
	));
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура КонфликтыИзмененийВыбор(Элемент, Поле) Экспорт
	ИмяПоля = СтрЗаменить(Поле.Имя, "КонфликтыИзменений", "");
	ТекущееЗначение = Элемент.ТекущиеДанные[ИмяПоля];
	Если Не ЗначениеЗаполнено(ТекущееЗначение) Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(ТекущееЗначение) = Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(ТекущееЗначение) = Тип("Дата") Тогда
		Возврат;
	КонецЕсли;
	ПоказатьЗначение(Неопределено, ТекущееЗначение);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

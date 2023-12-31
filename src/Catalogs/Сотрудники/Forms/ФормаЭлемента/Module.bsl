
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		РолиПоСотруднику, "Сотрудник", Объект.Ссылка,,,,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		КомандыПоСотруднику, "Сотрудник", Объект.Ссылка,,,,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ВедущиеПоСотруднику, "Сотрудник", Объект.Ссылка,,,,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		РолиПоСотруднику, "Период", ТекущаяДатаСеанса());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		КомандыПоСотруднику, "Период", ТекущаяДатаСеанса());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ВедущиеПоСотруднику, "Период", ТекущаяДатаСеанса());
		
		
	ЗаполнитьВедущего();
	ЗаполнитьКоманду();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_
#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьВедущего()
	Ведущий = РегистрыСведений.ВедущиеПоСотрудникам.ПолучитьПоследнее(, Новый Структура("Сотрудник", Объект.Ссылка)).Ведущий;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКоманду()
	Команда = РегистрыСведений.КомандыСотрудников.ПолучитьПоследнее(, Новый Структура("Сотрудник", Объект.Ссылка)).Команда;
КонецПроцедуры

#КонецОбласти
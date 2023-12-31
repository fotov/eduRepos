#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область СведенияОВнешнейОбработке
// Возвращает сведения о внешней обработке.
//
// Возвращаемое значение:
//   Структура - Подробнее см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке().
//
Функция СведенияОВнешнейОбработке() Экспорт
		
	Мета = Метаданные();
	Версия = Мета.Комментарий;
	ВерсияБСП = "3.1.7.82";
	ТекущаяВерсияБСП = СтандартныеПодсистемыСервер.ВерсияБиблиотеки();
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке(ВерсияБСП);
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет();
	ПараметрыРегистрации.Версия = Версия;
	ПараметрыРегистрации.Наименование = Мета.Представление();
	ПараметрыРегистрации.Информация = Мета.Представление();
	ПараметрыРегистрации.Назначение.Добавить("Подсистема.НепрерывнаяИнтеграция");
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = "_" + Мета.Представление();
	НоваяКоманда.Идентификатор = Мета.ПолноеИмя();
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	НоваяКоманда.ПоказыватьОповещение = Ложь;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции
#КонецОбласти

#Область ВариантыОтчетов
// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриОпределенииИспользуемыхТаблиц = Истина;
КонецПроцедуры

// Список регистров и других объектов метаданных, по которым формируется отчет.
//   Используется для проверки что отчет может содержать не обновленные данные.
//
// Параметры:
//   КлючВарианта - Строка
//                - Неопределено -
//       Имя предопределенного или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов для варианта расшифровки или без контекста.
//   ИспользуемыеТаблицы - Массив - 
//       Полные имена объектов метаданных (регистров, документов и других таблиц),
//       данные которых выводятся в отчете.
//
Процедура ПриОпределенииИспользуемыхТаблиц(КлючВарианта, ИспользуемыеТаблицы) Экспорт
	ИспользуемыеТаблицы.Добавить(Метаданные.Справочники.ЗадачиМетеор.ПолноеИмя());
	ИспользуемыеТаблицы.Добавить(Метаданные.РегистрыСведений.ИсторияЭтаповЗадачиМетеор.ПолноеИмя());
	ИспользуемыеТаблицы.Добавить(Метаданные.РегистрыСведений.ТекущийЭтапЗадачиМетеор.ПолноеИмя());
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УстановитьОтключениеБезопасногоРежима(Истина);
	
	СхемаКомпоновки = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	НастройкиКомпоновки = КомпоновщикНастроек.ПолучитьНастройки();
	ПараметрПериод = ОтчетыКлиентСервер.НайтиПараметр(НастройкиКомпоновки, Неопределено, "ПериодОтчета");
	
	ЭтапыЗадачМетеор = ЭтапыЗадачМетеор(ПараметрПериод.Значение.ДатаНачала, ПараметрПериод.Значение.ДатаОкончания);
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ЭтапыЗадачМетеор", ЭтапыЗадачМетеор);
	
	КомпановщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;    
	МакетКомпановки = КомпановщикМакета.Выполнить(СхемаКомпоновки, НастройкиКомпоновки, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпановки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтапыЗадачМетеор(НачалоПериода, КонецПериода)
	
	Результат = ИнтеграцияСМетеор.ИзмененияЭтаповЗадачМетеорЗаПериод(НачалоПериода, КонецПериода);
	
	Результат.Колонки.Добавить("Источник", ОбщегоНазначения.ОписаниеТипаСтрока(15));
	Для Каждого Строка Из Результат Цикл
		Строка.Источник = "Метеор";
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Иначе
  ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли

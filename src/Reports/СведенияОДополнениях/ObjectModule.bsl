#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область СведенияОВнешнейОбработке
// Возвращает сведения о внешней обработке.
//
// Возвращаемое значение:
//   Структура - Подробнее см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке().
//
Функция СведенияОВнешнейОбработке() Экспорт
		
	Мета = ЭтотОбъект.Метаданные();
	Версия = Мета.Комментарий;
	ВерсияБСП = "3.1.7.82";
	ТекущаяВерсияБСП = СтандартныеПодсистемыСервер.ВерсияБиблиотеки();
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке(ВерсияБСП);
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет();
	ПараметрыРегистрации.Версия = Версия;
	ПараметрыРегистрации.Наименование = Мета.Представление();
	ПараметрыРегистрации.Информация = Мета.Представление();
	ПараметрыРегистрации.Назначение.Добавить("Подсистема.Дополнения");
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
  ИспользуемыеТаблицы.Добавить(Метаданные.Справочники.Базы1С.ПолноеИмя());
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УстановитьОтключениеБезопасногоРежима(Истина);
	//УстановитьБезопасныйРежим(Ложь);
	
	СхемаКомпоновки = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	НастройкиКомпоновки = КомпоновщикНастроек.ПолучитьНастройки();
	
	База = Неопределено;
	ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(НастройкиКомпоновки.Отбор, "База");
	Если ЭлементыОтбора.Количество() 
			И ЭлементыОтбора[0].Использование 
			И ЭлементыОтбора[0].ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
		База = ЭлементыОтбора[0].ПравоеЗначение;
	КонецЕсли;
	
	ПараметрТипДополнения = ОтчетыКлиентСервер.НайтиПараметр(НастройкиКомпоновки, Неопределено, "ТипДополнения");
	ТипДополнения = ПараметрТипДополнения.Значение;
	
	СведенияОДополнениях = СведенияОДополнениях(База, ТипДополнения);
	
	ВнешниеНаборыДанных = Новый Структура;
    ВнешниеНаборыДанных.Вставить("СведенияОДополнениях", СведенияОДополнениях);
	
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

Функция СведенияОДополнениях(База, ТипДополнения)
	
	Результат = РаботаСДополнениями.ПолучитьСостояниеДополнений(ТипДополнения, База);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Иначе
  ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли

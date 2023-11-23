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
	ПараметрыРегистрации.Назначение.Добавить("Подсистема.ТехническийПроект");
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
  //Настройки.События.ПриОпределенииИспользуемыхТаблиц = Истина;
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
  //ИспользуемыеТаблицы.Добавить(Метаданные.РегистрыСведений.ОценкаТрудозатратПоЗадачам.ПолноеИмя());
  //ИспользуемыеТаблицы.Добавить(Метаданные.РегистрыСведений.РезультатыКонтроляТрудозатрат.ПолноеИмя());
  //ИспользуемыеТаблицы.Добавить(Метаданные.Справочники.ЗадачиМетеор.ПолноеИмя());
  //ИспользуемыеТаблицы.Добавить(Метаданные.Справочники.Пользователи.ПолноеИмя());
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

//Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
//	СхемаКомпоновки = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
//	НастройкиКомпановки = КомпоновщикНастроек.ПолучитьНастройки();
//	ПараметрТочкаПредварительнойПроверки = ОтчетыКлиентСервер.НайтиПараметр(НастройкиКомпановки,, "ТочкаМаршрутаПредварительнаяПроверка");
//    ПараметрТочкаПредварительнойПроверки.Значение = БизнесПроцессы.ПредварительнаяПроверка.ТочкиМаршрута.ПроверкаКода;
//	а = ПредопределенноеЗначение("БизнесПроцесс.ПредварительнаяПроверка.ТочкаМаршрута.ПроверкаКода");
//КонецПроцедуры



//Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
//	
//	СтандартнаяОбработка = Ложь;
//	
//	СхемаКомпоновки = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
//	НастройкиКомпановки = КомпоновщикНастроек.ПолучитьНастройки();
//	
//	ЗадачаМетеор = ОтчетыКлиентСервер.НайтиПараметр(НастройкиКомпановки,, "ЗадачаМетеор").Значение;
//    ДанныеАнализаТрудозатрат = ДанныеАнализаТрудозатрат(ЗадачаМетеор);
//    ВнешниеНаборыДанных = Новый Структура;
//    ВнешниеНаборыДанных.Вставить("ДанныеАнализаТрудозатрат", ДанныеАнализаТрудозатрат);
//	
//	КомпановщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;    
//	МакетКомпановки = КомпановщикМакета.Выполнить(СхемаКомпоновки, НастройкиКомпановки, ДанныеРасшифровки);
//	
//	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
//	ПроцессорКомпоновки.Инициализировать(МакетКомпановки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
//	
//	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
//	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
//	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
//	
//КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Функция ДанныеАнализаТрудозатрат(ЗадачаМетеор)
//	
//	СведенияПоЗадаче = ТаблицаСведенияПоЗадаче();
//	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
//		Справочники.ЗадачиМетеор.ПолучитьЧасыПоЗадачеМетеор(ЗадачаМетеор),
//		СведенияПоЗадаче);
//	СведенияПоЗадаче.Свернуть("Пользователь, Роль", "Затрачено");
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("ЧасыПоЗадаче", СведенияПоЗадаче);
//	Запрос.УстановитьПараметр("ЗадачаМетеор", ЗадачаМетеор);
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	ЧасыПоЗадаче.Пользователь КАК Пользователь,
//		|	ЧасыПоЗадаче.Роль КАК Роль,
//		|	ЧасыПоЗадаче.Затрачено КАК Затрачено
//		|ПОМЕСТИТЬ ЧасыПоЗадаче
//		|ИЗ
//		|	&ЧасыПоЗадаче КАК ЧасыПоЗадаче
//		|;
//		|
//		|////////////////////////////////////////////////////////////////////////////////
//		|ВЫБРАТЬ
//		|	Пользователи.Ссылка КАК Исполнитель,
//		|	ЧасыПоЗадаче.Пользователь КАК ИсполнительСтрокой,
//		|	ЧасыПоЗадаче.Роль КАК РольСтрокой,
//		|	ЧасыПоЗадаче.Затрачено КАК Затрачено,
//		|	РолиИсполнителей.Ссылка КАК РольИсполнителя
//		|ПОМЕСТИТЬ ИсполнителиЗадачи
//		|ИЗ
//		|	(ВЫБРАТЬ
//		|		ЧасыПоЗадаче.Пользователь КАК Пользователь,
//		|		ЧасыПоЗадаче.Роль КАК Роль,
//		|		СУММА(ЧасыПоЗадаче.Затрачено) КАК Затрачено
//		|	ИЗ
//		|		ЧасыПоЗадаче КАК ЧасыПоЗадаче
//		|	
//		|	СГРУППИРОВАТЬ ПО
//		|		ЧасыПоЗадаче.Пользователь,
//		|		ЧасыПоЗадаче.Роль) КАК ЧасыПоЗадаче
//		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
//		|		ПО ЧасыПоЗадаче.Пользователь = Пользователи.Наименование
//		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиИсполнителей КАК РолиИсполнителей
//		|		ПО ЧасыПоЗадаче.Роль = РолиИсполнителей.Наименование
//		|;
//		|
//		|////////////////////////////////////////////////////////////////////////////////
//		|ВЫБРАТЬ
//		|	ИсполнителиЗадачи.Исполнитель КАК Исполнитель,
//		|	ИсполнителиЗадачи.РольИсполнителя КАК РольИсполнителя,
//		|	ИсполнителиЗадачи.Затрачено КАК КоличествоЗатрачено,
//		|	ОценкаТрудозатратПоЗадачам.Количество КАК КоличествоОценка
//		|ИЗ
//		|	ИсполнителиЗадачи КАК ИсполнителиЗадачи
//		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОценкаТрудозатратПоЗадачам КАК ОценкаТрудозатратПоЗадачам
//		|		ПО ИсполнителиЗадачи.РольИсполнителя = ОценкаТрудозатратПоЗадачам.РольИсполнителяЗадачи
//		|			И (ОценкаТрудозатратПоЗадачам.ЗадачаМетеор = &ЗадачаМетеор)";
//	
//	
//	Возврат Запрос.Выполнить().Выгрузить();
//	
//КонецФункции

//Функция ТаблицаСведенияПоЗадаче()
//	
//	Результат = Новый ТаблицаЗначений;
//	Результат.Колонки.Добавить("Пользователь", ОбщегоНазначения.ОписаниеТипаСтрока(150));
//	Результат.Колонки.Добавить("Роль", ОбщегоНазначения.ОписаниеТипаСтрока(150));
//	Результат.Колонки.Добавить("Затрачено", ОбщегоНазначения.ОписаниеТипаЧисло(5,2));
//	
//	Возврат Результат
//	
//КонецФункции

#КонецОбласти

#Иначе
  ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Поиск дублей для указанного значения ЭталонныйОбъект.
//
// Параметры:
//     ОбластьПоиска - Строка - имя таблицы данных (полное имя метаданных) области поиска.
//                              Например, "Справочник.Номенклатура". Поддерживается поиск в справочниках, 
//                              планах видов характеристик, видах расчетов, планах счетов.
//
//     ЭталонныйОбъект - Произвольный - объект с данными элемента, для которого производится поиск дублей.
//
//     ДополнительныеПараметры - Произвольный - параметр для передачи в обработчики событий менеджера.
//
// Возвращаемое значение:
//     ТаблицаЗначений:
//       * Ссылка       - ЛюбаяСсылка - ссылка элемента.
//       * Код          - Строка
//                      - Число - код элемента.
//       * Наименование - Строка - наименование элемента.
//       * Родитель     - Произвольный - родитель группы дублей. Если Родитель пустой, то элемент является
//                                       родителем группы дублей.
//       * ДругиеПоля - Произвольный - значение соответствующего полей отборов и критериев сравнения дублей.
// 
Функция НайтиДублиЭлемента(Знач ОбластьПоиска, Знач ЭталонныйОбъект, Знач ДополнительныеПараметры) Экспорт
	
	ПараметрыПоискаДублей = Новый Структура;
	ПараметрыПоискаДублей.Вставить("КомпоновщикПредварительногоОтбора");
	ПараметрыПоискаДублей.Вставить("ОбластьПоискаДублей", ОбластьПоиска);
	ПараметрыПоискаДублей.Вставить("УчитыватьПрикладныеПравила", Истина);
	
	// Из параметров
	ПараметрыПоискаДублей.Вставить("ПравилаПоиска", Новый ТаблицаЗначений);
	ПараметрыПоискаДублей.ПравилаПоиска.Колонки.Добавить("Реквизит", Новый ОписаниеТипов("Строка"));
	ПараметрыПоискаДублей.ПравилаПоиска.Колонки.Добавить("Правило",  Новый ОписаниеТипов("Строка"));
	
	// См. Обработка.ПоискИУдалениеДублей
	ПараметрыПоискаДублей.КомпоновщикПредварительногоОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	ОбластьПоискаМетаданные = Метаданные.НайтиПоПолномуИмени(ОбластьПоиска);
	ДоступныеРеквизитыОтбора = ДоступныеИменаРеквизитовОтбора(ОбластьПоискаМетаданные.СтандартныеРеквизиты);
	ДоступныеРеквизитыОтбора = ?(ПустаяСтрока(ДоступныеРеквизитыОтбора), ",", ДоступныеРеквизитыОтбора)
		+ ДоступныеИменаРеквизитовОтбора(ОбластьПоискаМетаданные.Реквизиты);
	ТекстЗапроса = "ВЫБРАТЬ * ИЗ #Таблица";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "*", Сред(ДоступныеРеквизитыОтбора, 2));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#Таблица", ОбластьПоиска);
	
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СхемаКомпоновки.ИсточникиДанных.Добавить();
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Запрос = ТекстЗапроса;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	
	ПараметрыПоискаДублей.КомпоновщикПредварительногоОтбора.Инициализировать( Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки) );
	
	// Вызов прикладного кода
	ОбработкаПоиска = Обработки.ПоискИУдалениеДублей.Создать();
	
	ИспользоватьПрикладныеПравила = ОбработкаПоиска.ЕстьПрикладныеПравилаОбластиПоискаДублей(ОбластьПоиска);
	Если ИспользоватьПрикладныеПравила Тогда
		ПрикладныеПараметры = ПараметрыПоискаДублей(ПараметрыПоискаДублей.ПравилаПоиска, ПараметрыПоискаДублей.КомпоновщикПредварительногоОтбора);
		МенеджерОбластиПоиска = ОбработкаПоиска.МенеджерОбластиПоискаДублей(ОбластьПоиска);
		МенеджерОбластиПоиска.ПараметрыПоискаДублей(ПрикладныеПараметры, ДополнительныеПараметры);
		ПараметрыПоискаДублей.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	КонецЕсли;
	
	ГруппыДублей = ОбработкаПоиска.ГруппыДублей(ПараметрыПоискаДублей, ЭталонныйОбъект);
	Результат = ГруппыДублей.ТаблицаДублей;
	
	// Там ровно одна группа, возвращаем нужные элементы.
	Для Каждого Строка Из Результат.НайтиСтроки(Новый Структура("Родитель", Неопределено)) Цикл
		Результат.Удалить(Строка);
	КонецЦикла;
	ПустаяСсылка = МенеджерОбластиПоиска.ПустаяСсылка();
	Для Каждого Строка Из Результат.НайтиСтроки(Новый Структура("Ссылка", ПустаяСсылка)) Цикл
		Результат.Удалить(Строка);
	КонецЦикла;
	
	Возврат Результат; 
КонецФункции

// Добавляет к коллекции дублей связанные подчиненные объекты.
//
// Параметры:
//  ПарыЗамен		 - см. ОбщегоНазначения.ЗаменитьСсылки.ПарыЗамен
//  ПараметрыЗамены	 - см. ОбщегоНазначения.ПараметрыЗаменыСсылок
//
Процедура ДополнитьДублиСвязаннымиПодчиненнымиОбъектами(ПарыЗамен, ПараметрыЗамены) Экспорт
	
	СвязиОбъектов = ОбщегоНазначения.ПодчиненныеОбъекты();
	СвязиПодчиненныхОбъектов = СвязиПодчиненныхОбъектовПоТипам();
	ОписаниеПодчиненныхОбъектов = Новый Соответствие;

	Для каждого СтрокаСвязи Из СвязиОбъектов Цикл
		ДобавитьСвязиПодчиненныхОбъектов(СвязиПодчиненныхОбъектов, СтрокаСвязи);	
    	ЗаполнитьОписаниеОбъекта(ОписаниеПодчиненныхОбъектов, СтрокаСвязи);
	КонецЦикла;
	
	ТаблицыЗамен = Новый Соответствие;
	Для каждого ОригиналДубль Из ПарыЗамен Цикл
		ОтметитьИспользуемыеСвязи(ОригиналДубль.Значение, СвязиПодчиненныхОбъектов);
		ДобавитьВТаблицыЗамены(ОригиналДубль, ТаблицыЗамен, СвязиПодчиненныхОбъектов);
	КонецЦикла;

	Фильтр = Новый Структура("Используется", Истина);
	ИспользуемыеСвязи = СвязиПодчиненныхОбъектов.Скопировать(Фильтр);
	Если ИспользуемыеСвязи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ИспользуемыеСвязи.Сортировать("Ключ");
	
	МВТ = Новый МенеджерВременныхТаблиц;
	ПоместитьТаблицыЗаменВЗапрос(МВТ, ТаблицыЗамен);

	ТаблицыНайденныхДублей = Новый Соответствие;
	ЧастиПакета = Новый Массив;
	Позиция = 0;
	Пока Позиция <= ИспользуемыеСвязи.Количество() - 1 Цикл
		
		ИмяПодчиненногоОбъекта = ИспользуемыеСвязи[Позиция].Ключ;
		ОписаниеПодчиненногоОбъекта = ОписаниеПодчиненныхОбъектов[ИмяПодчиненногоОбъекта];
		Фильтр = Новый Структура("Ключ, Используется", ИмяПодчиненногоОбъекта, Истина);
		СвязиПодчиненногоОбъекта = СвязиПодчиненныхОбъектов.НайтиСтроки(Фильтр);
		ЧастиПакета.Добавить(ТекстЗапросаОбъектовДляЗамены(
			 ОписаниеПодчиненногоОбъекта
			,СвязиПодчиненногоОбъекта));
		
		ТаблицыНайденныхДублей.Вставить(ОписаниеПодчиненногоОбъекта.Ключ, ЧастиПакета.Количество()*3-1);// 3 - количество добавляемых пакетов 
		Позиция = Позиция + СвязиПодчиненногоОбъекта.Количество();
	
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.Текст = СтрСоединить(ЧастиПакета, ОбщегоНазначения.РазделительПакетаЗапросов());	
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого Замена Из ТаблицыНайденныхДублей Цикл
		
		НеподобранныеЗамены = Новый Массив;
		ОписаниеПодчиненногоОбъекта = ОписаниеПодчиненныхОбъектов[Замена.Ключ];
		ПодобранныеЗамены = Результат[Замена.Значение].Выгрузить();
		
		ДобавитьНайденныеКлючиВДубли(ПодобранныеЗамены, ПарыЗамен, НеподобранныеЗамены);
		
		Если ЗначениеЗаполнено(ОписаниеПодчиненногоОбъекта.ИмяМодуляМетодаПоиска) 
			И НеподобранныеЗамены.Количество() > 0 Тогда
			
			ВыполнитьПоискПоПрикладнымПравилам(
				ИспользуемыеСвязи,
				НеподобранныеЗамены,
				ОписаниеПодчиненногоОбъекта,
				ПарыЗамен);
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при поиске возможных дублей для фильтрации мест появления возможных дублей
// в рабочем месте поиска дублей на последнем шаге помощника
//
// Возвращаемое значение:
//   Массив из Тип
//
Функция ТипыИсключаемыеИзВозможныхДублей() Экспорт

	ИсключаемыеТипы = Новый Массив;
	ИнтеграцияПодсистемБСП.ПриДобавленииТиповИсключаемыхИзВозможныхДублей(ИсключаемыеТипы);		
	Возврат ИсключаемыеТипы;

КонецФункции

Функция ПроверитьВозможностьЗаменыЭлементовСтрока(ПарыЗамен, ПараметрыЗамены) Экспорт
	
	Результат = "";
	Ошибки = ПроверитьВозможностьЗаменыЭлементов(ПарыЗамен, ПараметрыЗамены);
	Для Каждого КлючЗначение Из Ошибки Цикл
		Результат = Результат + Символы.ПС + КлючЗначение.Значение;
	КонецЦикла;
	Возврат СокрЛП(Результат);
	
КонецФункции

Функция ПроверитьВозможностьЗаменыЭлементов(ПарыЗамен, ПараметрыЗамены) Экспорт
	
	Если ПарыЗамен.Количество() = 0 Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
	
	Для Каждого Элемент Из ПарыЗамен Цикл
		ПервыйЭлемент = Элемент.Ключ;
		Прервать;
	КонецЦикла;
	
	Результат = Новый Соответствие;
	
	ИмяОбъектаМетаданных = ПервыйЭлемент.Метаданные().ПолноеИмя();
	СведенияОбОбъекте = ОбъектыСПоискомДублей()[ИмяОбъектаМетаданных];
	Если СведенияОбОбъекте <> Неопределено И (СведенияОбОбъекте = "" Или СтрНайти(СведенияОбОбъекте, "ВозможностьЗаменыЭлементов") > 0) Тогда
		МодульМенеджера = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ПервыйЭлемент);
		Результат = МодульМенеджера.ВозможностьЗаменыЭлементов(ПарыЗамен, ПараметрыЗамены);
	КонецЕсли;
	
	ПоискИУдалениеДублейПереопределяемый.ПриОпределенииВозможностиЗаменыЭлементов(ИмяОбъектаМетаданных, ПарыЗамен, ПараметрыЗамены, Результат);
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.МестаИспользованияСсылок);
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииВидовПодключаемыхКоманд
Процедура ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд) Экспорт
	
	Если ВидыПодключаемыхКоманд.Найти("Администрирование", "Имя") = Неопределено Тогда
		
		Вид = ВидыПодключаемыхКоманд.Добавить();
		Вид.Имя         = "Администрирование";
		Вид.ИмяПодменю  = "Сервис";
		Вид.Заголовок   = НСтр("ru = 'Сервис'");
		Вид.Порядок     = 80;
		Вид.Картинка    = БиблиотекаКартинок.ПодменюСервис;
		Вид.Отображение = ОтображениеКнопки.КартинкаИТекст;	
		
	КонецЕсли;
	
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту
Процедура ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды) Экспорт
	
	ПодключенныеОбъекты = ОбъектыСКомандамиОбъединенияДублей();
	Для каждого ПодключенныйОбъект Из ПодключенныеОбъекты Цикл
		
		Если ПравоДоступа("Изменение", ПодключенныйОбъект)
			И Источники.Строки.Найти(ПодключенныйОбъект, "Метаданные") <> Неопределено Тогда
			
			Команда = Команды.Добавить();
			Команда.Вид = "Администрирование";
			Команда.Важность = "СмТакже";
			Команда.Представление = НСтр("ru = 'Объединить выделенные...'");
			Команда.РежимЗаписи = "НеЗаписывать";
			Команда.ВидимостьВФормах = "ФормаСписка";
			Команда.МножественныйВыбор = Истина;
			Команда.Обработчик = "ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные";
			Команда.ТолькоВоВсехДействиях = Истина;
			Команда.Порядок = 40;
			
			Команда = Команды.Добавить();
			Команда.Вид = "Администрирование";
			Команда.Важность = "СмТакже";
			Команда.Представление = НСтр("ru = 'Заменить выделенные...'");
			Команда.РежимЗаписи = "НеЗаписывать";
			Команда.ВидимостьВФормах = "ФормаСписка";
			Команда.МножественныйВыбор = Истина;
			Команда.Обработчик = "ПоискИУдалениеДублейКлиент.ЗаменитьВыделенные";
			Команда.ТолькоВоВсехДействиях = Истина;
			Команда.Порядок = 40;
			
		КонецЕсли;	
	
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// см. Обработка.ПоискИУдалениеДублей.
Функция ДоступныеИменаРеквизитовОтбора(Знач КоллекцияМетаданных)
	Результат = "";
	ТипХранилища = Тип("ХранилищеЗначения");
	
	Для Каждого Реквизит Из КоллекцияМетаданных Цикл
		ЭтоХранилище = Реквизит.Тип.СодержитТип(ТипХранилища);
		Если Не ЭтоХранилище Тогда
			Результат = Результат + "," + Реквизит.Имя;
		КонецЕсли
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Процедура ОпределитьМестаИспользования(Знач НаборСсылок, Знач АдресРезультата) Экспорт
	
	ТаблицаПоиска = ОбщегоНазначения.МестаИспользования(НаборСсылок);
	
	Фильтр = Новый Структура("ЭтоСлужебныеДанные", Ложь);
	АктуальныеСтроки = ТаблицаПоиска.НайтиСтроки(Фильтр);
	
	Результат = ТаблицаПоиска.Скопировать(АктуальныеСтроки, "Ссылка");
	Результат.Колонки.Добавить("Вхождения", Новый ОписаниеТипов("Число"));
	Результат.ЗаполнитьЗначения(1, "Вхождения");
	
	Результат.Индексы.Добавить("Ссылка");
	
	Результат.Свернуть("Ссылка", "Вхождения");
	Для Каждого Ссылка Из НаборСсылок Цикл
		Если Результат.Найти(Ссылка, "Ссылка") = Неопределено Тогда
			Результат.Добавить().Ссылка = Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
КонецПроцедуры

// Производит замену ссылок во всех данных информационной базы. 
//
// Параметры:
//     Параметры - Структура:
//       * ПарыЗамен - Соответствие из КлючИЗначение:
//           * Ключ     - ЛюбаяСсылка - что ищем (дубль).
//           * Значение - ЛюбаяСсылка - на что заменяем (оригинал).
//           Ссылки сами на себя и пустые ссылки для поиска будут проигнорированы.
//       * СпособУдаления - Строка - необязательный. Что делать с дублем после успешной замены.
//           ""                - По умолчанию. Не предпринимать никаких действий.
//           "Пометка"         - Помечать на удаление.
//           "Непосредственно" - Удалять непосредственно.
//     АдресРезультата - Строка - адрес временного хранилища, куда будет помещен результат замены - ТаблицаЗначений:
//       * Ссылка - ЛюбаяСсылка - ссылка, которую заменяли.
//       * ОбъектОшибки - Произвольный - объект - причина ошибки.
//       * ПредставлениеОбъектаОшибки - Строка - строковое представление объекта ошибки.
//       * ТипОшибки - Строка - маркер типа ошибки. Возможны варианты:
//                              "ОшибкаБлокировки"  - при обработке ссылки некоторые объекты были заблокированы
//                              "ДанныеИзменены"    - в процессе обработки данные были изменены другим пользователем
//                              "ОшибкаЗаписи"      - не смогли записать объект
//                              "НеизвестныеДанные" - при обработке были найдены данные, которые
//                                                    не планировались к анализу, замена не реализована
//                              "ЗаменаЗапрещена"   - обработчик ВозможностьЗаменыЭлементов вернул отказ.
//       * ТекстОшибки - Строка - подробное описание ошибки.
//
Процедура ЗаменитьСсылки(Параметры, Знач АдресРезультата) Экспорт
	
	ПараметрыЗаменыСсылок = ОбщегоНазначения.ПараметрыЗаменыСсылок();
	ПараметрыЗаменыСсылок.СпособУдаления = Параметры.СпособУдаления;
	ПараметрыЗаменыСсылок.ВключатьБизнесЛогику = Истина;
	ПараметрыЗаменыСсылок.ЗаменаПарыВТранзакции = Ложь;
	
	Результат = ОбщегоНазначения.ЗаменитьСсылки(Параметры.ПарыЗамен, ПараметрыЗаменыСсылок);
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

// Формирует таблицу обслуживаемых объектов метаданных и их общие настройки.
//
// Возвращаемое значение:
//   ТаблицаЗначений:
//       * ПолноеИмя             - Строка   - полное имя метаданных объекта-таблицы.
//       * ПредставлениеЭлемента - Строка   - представление элемента для пользователя.
//       * ПредставлениеСписка   - Строка   - представление списка для пользователя.
//       * Удален                - Булево   - это объект метаданных с префиксом "Удалить".
//       * СобытиеПараметрыПоискаДублей      - Булево - в модуле менеджера определен обработчик ВозможностьЗаменыЭлементов.
//       * СобытиеПриПоискеДублей            - Булево - в модуле менеджера определен обработчик ПараметрыПоискаДублей.
//       * СобытиеВозможностьЗаменыЭлементов - Булево - в модуле менеджера определен обработчик ПриПоискеДублей.
//
Функция НастройкиОбъектовМетаданных() Экспорт
	Настройки = Новый ТаблицаЗначений;
	Настройки.Колонки.Добавить("Вид",                   Новый ОписаниеТипов("Строка"));
	Настройки.Колонки.Добавить("ПолноеИмя",             Новый ОписаниеТипов("Строка"));
	Настройки.Колонки.Добавить("ПредставлениеЭлемента", Новый ОписаниеТипов("Строка"));
	Настройки.Колонки.Добавить("ПредставлениеСписка",   Новый ОписаниеТипов("Строка"));
	Настройки.Колонки.Добавить("Удален",                Новый ОписаниеТипов("Булево"));
	Настройки.Колонки.Добавить("СобытиеПараметрыПоискаДублей",      Новый ОписаниеТипов("Булево"));
	Настройки.Колонки.Добавить("СобытиеПриПоискеДублей",            Новый ОписаниеТипов("Булево"));
	Настройки.Колонки.Добавить("СобытиеВозможностьЗаменыЭлементов", Новый ОписаниеТипов("Булево"));
	
	СписокОбъектов = ОбъектыСПоискомДублей();
	ЗарегистрироватьКоллекциюМетаданных(Настройки, СписокОбъектов, Метаданные.Справочники, "Справочник");
	ЗарегистрироватьКоллекциюМетаданных(Настройки, СписокОбъектов, Метаданные.Документы, "Документ");
	ЗарегистрироватьКоллекциюМетаданных(Настройки, СписокОбъектов, Метаданные.ПланыСчетов, "ПланСчетов");
	ЗарегистрироватьКоллекциюМетаданных(Настройки, СписокОбъектов, Метаданные.ПланыВидовРасчета, "ПланВидовРасчета");
	ЗарегистрироватьКоллекциюМетаданных(Настройки, СписокОбъектов, Метаданные.ПланыВидовХарактеристик, "ПланВидовХарактеристик");
	
	Результат = Настройки.Скопировать(Новый Структура("Удален", Ложь));
	Результат.Сортировать("ПредставлениеСписка");
	
	Возврат Результат;
КонецФункции

Функция ОбъектыСПоискомДублей() Экспорт
	
	СписокОбъектов = Новый Соответствие;
	ИнтеграцияПодсистемБСП.ПриОпределенииОбъектовСПоискомДублей(СписокОбъектов);
	ПоискИУдалениеДублейПереопределяемый.ПриОпределенииОбъектовСПоискомДублей(СписокОбъектов);
	Возврат СписокОбъектов;

КонецФункции

Процедура ЗарегистрироватьКоллекциюМетаданных(Настройки, СписокОбъектов, КоллекцияМетаданных, Вид)
	
	Для Каждого ОбъектМетаданных Из КоллекцияМетаданных Цикл
		Если Не ПравоДоступа("Просмотр", ОбъектМетаданных)
			Или Не ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда
			Продолжить; // Нет доступа, не выводим в список.
		КонецЕсли;
		
		СтрокаТаблицы = Настройки.Добавить();
		СтрокаТаблицы.Вид = Вид;
		СтрокаТаблицы.ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
		СтрокаТаблицы.Удален = СтрНачинаетсяС(ОбъектМетаданных.Имя, "Удалить");
		СтрокаТаблицы.ПредставлениеЭлемента = ОбщегоНазначения.ПредставлениеОбъекта(ОбъектМетаданных);
		СтрокаТаблицы.ПредставлениеСписка = ОбщегоНазначения.ПредставлениеСписка(ОбъектМетаданных);
		
		События = СписокОбъектов[СтрокаТаблицы.ПолноеИмя];
		Если ТипЗнч(События) = Тип("Строка") Тогда
			Если ПустаяСтрока(События) Тогда
				СтрокаТаблицы.СобытиеПараметрыПоискаДублей      = Истина;
				СтрокаТаблицы.СобытиеПриПоискеДублей            = Истина;
				СтрокаТаблицы.СобытиеВозможностьЗаменыЭлементов = Истина;
			Иначе
				СтрокаТаблицы.СобытиеПараметрыПоискаДублей      = СтрНайти(События, "ПараметрыПоискаДублей") > 0;
				СтрокаТаблицы.СобытиеПриПоискеДублей            = СтрНайти(События, "ПриПоискеДублей") > 0;
				СтрокаТаблицы.СобытиеВозможностьЗаменыЭлементов = СтрНайти(События, "ВозможностьЗаменыЭлементов") > 0;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Представление подсистемы. Используется при записи в журнал регистрации и в других местах.
Функция НаименованиеПодсистемы(ДляПользователя) Экспорт
	КодЯзыка = ?(ДляПользователя, ОбщегоНазначения.КодОсновногоЯзыка(), "");
	Возврат НСтр("ru = 'Поиск и удаление дублей'", КодЯзыка);
КонецФункции

// Параметры:
//  ПравилаПоиска - ТаблицаЗначений:
//    * Реквизит - Строка 
//    * Правило - Строка 
//  КомпоновщикПредварительногоОтбора - КомпоновщикНастроекКомпоновкиДанных
//
// Возвращаемое значение:
//  Структура:
//    * ПравилаПоиска - ТаблицаЗначений:
//        ** Реквизит - Строка
//        ** Правило - Строка
//    * СравнениеСтрокНаПодобие - Структура:
//        ** ПроцентСовпаденияСтрок - Число
//        ** ПроцентСовпаденияНебольшихСтрок - Число
//        ** ДлинаНебольшихСтрок - Число
//        ** СловаИсключения - Массив
//    * КомпоновщикОтбора - КомпоновщикНастроекКомпоновкиДанных
//    * ОграниченияСравнения - Массив
//    * КоличествоЭлементовДляСравнения - Число
//
Функция ПараметрыПоискаДублей(ПравилаПоиска, КомпоновщикПредварительногоОтбора) Экспорт
	
	СравнениеСтрокНаПодобие = Новый Структура;
	СравнениеСтрокНаПодобие.Вставить("ПроцентСовпаденияСтрок", 90);
	СравнениеСтрокНаПодобие.Вставить("ПроцентСовпаденияНебольшихСтрок", 80);
	СравнениеСтрокНаПодобие.Вставить("ДлинаНебольшихСтрок", 30);
	СравнениеСтрокНаПодобие.Вставить("СловаИсключения", Новый Массив);
	
	Результат = Новый Структура;
	Результат.Вставить("ПравилаПоиска",        ПравилаПоиска);
	Результат.Вставить("СравнениеСтрокНаПодобие", СравнениеСтрокНаПодобие);
	Результат.Вставить("КомпоновщикОтбора",    КомпоновщикПредварительногоОтбора);
	Результат.Вставить("ОграниченияСравнения", Новый Массив);
	Результат.Вставить("КоличествоЭлементовДляСравнения", 1500);
	Результат.Вставить("СкрыватьНезначимыеДубли", Истина);
	Возврат Результат;
	
КонецФункции

#Область ЗаменаДублейВКлючахАналитики

// Возвращает связи подчиненных объектов с указанием типа поля связи.
//
// Возвращаемое значение:
//   ТаблицаЗначений:
//    * Ключ - Строка
//    * ТипРеквизита - Тип
//    * ИмяРеквизита - Строка
//    * Используется - Булево
//    * Метаданные - ОбъектМетаданных
//
Функция СвязиПодчиненныхОбъектовПоТипам() Экспорт

	СвязиПодчиненныхОбъектовПоТипам = Новый ТаблицаЗначений;
	СвязиПодчиненныхОбъектовПоТипам.Колонки.Добавить("ТипРеквизита", Новый ОписаниеТипов("Тип"));
	СвязиПодчиненныхОбъектовПоТипам.Колонки.Добавить("ИмяРеквизита", ОбщегоНазначения.ОписаниеТипаСтрока(0));
	СвязиПодчиненныхОбъектовПоТипам.Колонки.Добавить("Ключ", ОбщегоНазначения.ОписаниеТипаСтрока(0));
	СвязиПодчиненныхОбъектовПоТипам.Колонки.Добавить("Используется", Новый ОписаниеТипов("Булево"));
	СвязиПодчиненныхОбъектовПоТипам.Колонки.Добавить("Метаданные");
	
	Возврат СвязиПодчиненныхОбъектовПоТипам;

КонецФункции 

Процедура ДобавитьСвязиПодчиненныхОбъектов(СвязиПодчиненныхОбъектов, СтрокаСвязи)
	
	КлючевыеРеквизиты = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаСвязи.ПоляСвязей,",",,Истина);
	ИмяПодчиненногоОбъекта = СтрокаСвязи.ПодчиненныйОбъект.ПолноеИмя();
	Для каждого ИмяРеквизита Из КлючевыеРеквизиты Цикл
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(
				СтрокаСвязи.ПодчиненныйОбъект.СтандартныеРеквизиты, ИмяРеквизита) Тогда
		
			ТипРеквизита = СтрокаСвязи.ПодчиненныйОбъект.СтандартныеРеквизиты[ИмяРеквизита];
			Для каждого ТипРеквизита Из ТипРеквизита.Тип.Типы() Цикл
				
				Запись = СвязиПодчиненныхОбъектов.Добавить();	
				Запись.Ключ = ИмяПодчиненногоОбъекта;
				Запись.ТипРеквизита = ТипРеквизита;
				Запись.ИмяРеквизита = ИмяРеквизита;
				
			КонецЦикла;
			
		ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(
				СтрокаСвязи.ПодчиненныйОбъект.Реквизиты, ИмяРеквизита) Тогда
			
			ТипРеквизита = СтрокаСвязи.ПодчиненныйОбъект.Реквизиты[ИмяРеквизита];
			Для каждого ТипРеквизита Из ТипРеквизита.Тип.Типы() Цикл
				
				Запись = СвязиПодчиненныхОбъектов.Добавить();	
				Запись.Ключ = ИмяПодчиненногоОбъекта;
				Запись.ТипРеквизита = ТипРеквизита;
				Запись.ИмяРеквизита = ИмяРеквизита;
				
			КонецЦикла;
			
		Иначе 
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не существует поле связи %1 в объекте метаданных %2'"), 
				ИмяРеквизита, ИмяПодчиненногоОбъекта);
			ВызватьИсключение ОписаниеОшибки;
		КонецЕсли;
			
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьОписаниеОбъекта(ОписаниеПодчиненныхОбъектов, СтрокаСвязи)
	
	ИмяПодчиненногоОбъекта = СтрокаСвязи.ПодчиненныйОбъект.ПолноеИмя();
	КлючевыеРеквизиты = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаСвязи.ПоляСвязей,",",,Истина);
	
	ОписаниеОбъекта = НовыйОписаниеПодчиненногоОбъекта();
	ОписаниеОбъекта.Ключ = ИмяПодчиненногоОбъекта;
	ОписаниеОбъекта.КлючевыеРеквизиты = КлючевыеРеквизиты;
	ОписаниеОбъекта.ИмяМодуляМетодаПоиска = СтрокаСвязи.ПриПоискеЗаменыСсылок;
	ОписаниеОбъекта.ВыполнятьАвтоматическийПоиск = СтрокаСвязи.ВыполнятьАвтоматическийПоискЗаменСсылок;
	
	ОписаниеПодчиненныхОбъектов.Вставить(ИмяПодчиненногоОбъекта, ОписаниеОбъекта);

КонецПроцедуры

Функция НовыйОписаниеПодчиненногоОбъекта()

	ОписаниеОбъекта = Новый Структура;
	ОписаниеОбъекта.Вставить("Ключ");
	ОписаниеОбъекта.Вставить("КлючевыеРеквизиты");
	ОписаниеОбъекта.Вставить("ИмяМодуляМетодаПоиска");
	ОписаниеОбъекта.Вставить("ВыполнятьАвтоматическийПоиск");
	Возврат ОписаниеОбъекта;

КонецФункции

Процедура ОтметитьИспользуемыеСвязи(Дубль, СвязиПодчиненныхОбъектов) 

	Если СвязиПодчиненныхОбъектов.Найти(ТипЗнч(Дубль), "ТипРеквизита") = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	МетаданныеСсылки = Дубль.Метаданные();
	Если СвязиПодчиненныхОбъектов.Найти(МетаданныеСсылки, "Метаданные") <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИспользуемыеСвязи = СвязиПодчиненныхОбъектов.НайтиСтроки(Новый Структура("ТипРеквизита",ТипЗнч(Дубль)));
	Для каждого Связь Из ИспользуемыеСвязи Цикл
		
		Связь.Метаданные = МетаданныеСсылки;
		Связь.Используется = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//   ТаблицаЗамен - ТаблицаЗначений:
//   * Ссылка - ЛюбаяСсылка
//   * Замена - ЛюбаяСсылка
//   ПарыЗамен - Соответствие
//   НеподобранныеЗамены - Массив из ЛюбаяСсылка
//
Процедура ДобавитьНайденныеКлючиВДубли(ТаблицаЗамен, ПарыЗамен, НеподобранныеЗамены)

	Для каждого НайденныйДубль Из ТаблицаЗамен Цикл
	
		Если НайденныйДубль.Замена = NULL Тогда
			НеподобранныеЗамены.Добавить(НайденныйДубль);	
		Иначе
			ПарыЗамен.Вставить(НайденныйДубль.Ссылка, НайденныйДубль.Замена);
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//   НайденныйДубль - СтрокаТаблицыЗначений:
//   * Ссылка - ЛюбаяСсылка
//   * Замена - ЛюбаяСсылка
//   ОписаниеПодчиненногоОбъекта - Произвольный
//   ИспользуемыеСвязи - ТаблицаЗначений:
//   * Ключ - Тип
//   * ТипРеквизита - Строка
//   * ИмяРеквизита - Строка
//   * Используется - Булево
//   * Метаданные - ОбъектМетаданных
// Возвращаемое значение:
//   Структура:
//   * ИспользуемыеСвязи - ТаблицаЗначений:
//     ** Ключ - Тип
//     ** ТипРеквизита - Строка
//     ** ИмяРеквизита - Строка
//     ** Используется - Булево
//     ** Метаданные - ОбъектМетаданных
//   * ЗаменяемоеЗначение - ЛюбаяСсылка 
//
Функция НовыйПараметрыЗамены(НайденныйДубль, ОписаниеПодчиненногоОбъекта, ИспользуемыеСвязи)

	ПараметрыЗамены = Новый Структура;
	ПараметрыЗамены.Вставить("ЗаменяемоеЗначение", НайденныйДубль.Ссылка);
	ПараметрыЗамены.Вставить("ИспользуемыеСвязи",
		ИспользуемыеСвязи.Скопировать(Новый Структура("Ключ",ОписаниеПодчиненногоОбъекта.Ключ)));
	ПараметрыЗамены.Вставить("ЗначениеКлючевыхРеквизитов", Новый Структура);
	
	КлючевыеРеквизиты = ОписаниеПодчиненногоОбъекта.КлючевыеРеквизиты;	
	Для каждого КлючевойРеквизит Из КлючевыеРеквизиты Цикл
		ПараметрыЗамены.ЗначениеКлючевыхРеквизитов.Вставить(КлючевойРеквизит, НайденныйДубль[КлючевойРеквизит]);
	КонецЦикла;

	Возврат ПараметрыЗамены;

КонецФункции

Функция ТекстЗапросаОбъектовДляЗамены(ОписаниеПодчиненногоОбъекта, Связи)

	ТекстЗапроса = ШаблонЗапроса();

	ИмяКлюча = СтрЗаменить(ОписаниеПодчиненногоОбъекта.Ключ, ".", "");
	ТаблицаКлюча = ОписаниеПодчиненногоОбъекта.Ключ;

	НеИзменяемыеРеквизиты = "";
	ИзменяемыеРеквизиты = "";
	ЗначениеКлючей = "";
	ЗначениеИзменяемыеРеквизиты = "";
	СоединениеЗначениеЗаменяемыхРеквизитов = "";
	СвязиПоКлючу = "";
	
	ИзменяемыеРеквизитыМассив = Новый Массив;
	Если ОписаниеПодчиненногоОбъекта.ВыполнятьАвтоматическийПоиск Тогда
	
		Для каждого Связь Из Связи Цикл
			ИзменяемыеРеквизитыМассив.Добавить(Связь.ИмяРеквизита);
		КонецЦикла;	
	
	КонецЕсли;
	
	Для каждого КлючевойРеквизит Из ОписаниеПодчиненногоОбъекта.КлючевыеРеквизиты Цикл
		
		Значение = "ОБЪЕДИНИТЬ" // @query-part
			+ СтрЗаменить(" ВЫБРАТЬ
							|	Таб.Ссылка КАК Ссылка,
							|	&НеИзменяемыеРеквизиты,
							|	&ИзменяемыеРеквизиты
							|ИЗ
							|	#ТаблицаКлюча КАК Таб
							|ГДЕ
							|	&КлючевойРеквизит В 
							|	(ВЫБРАТЬ
							|		Таб.Оригинал
							|	ИЗ
							|		ТаблицаЗамен КАК Таб)", "&КлючевойРеквизит","Таб." + КлючевойРеквизит);
		ЗначениеКлючей = ЗначениеКлючей + Значение;
		
		Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Таб.%1 = Замена.%1 ", КлючевойРеквизит);
		СвязиПоКлючу = СвязиПоКлючу + ?(ПустаяСтрока(СвязиПоКлючу), Значение, "И " + Значение);
							
		Если ИзменяемыеРеквизитыМассив.Найти(КлючевойРеквизит) <> Неопределено Тогда
			
			Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Таб.%1 КАК %1", КлючевойРеквизит);
			ИзменяемыеРеквизиты = ИзменяемыеРеквизиты + ?(ПустаяСтрока(ИзменяемыеРеквизиты),Значение, ","+Значение);
			
			Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ВЫБОР КОГДА Замена%1.Оригинал IS NULL ТОГДА Таб.%1 ИНАЧЕ Замена%1.Дубль КОНЕЦ КАК %1", КлючевойРеквизит);
			ЗначениеИзменяемыеРеквизиты = ЗначениеИзменяемыеРеквизиты + ?(ПустаяСтрока(ЗначениеИзменяемыеРеквизиты),Значение, ","+Значение);;
		
			Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(" ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаЗамен КАК Замена%1
								|ПО Таб.%1 = Замена%1.Оригинал", КлючевойРеквизит);
			СоединениеЗначениеЗаменяемыхРеквизитов = СоединениеЗначениеЗаменяемыхРеквизитов + Значение;
			
		Иначе
			
			Значение =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Таб.%1 КАК %1", КлючевойРеквизит);
			НеИзменяемыеРеквизиты = НеИзменяемыеРеквизиты + ?(ПустаяСтрока(НеИзменяемыеРеквизиты),Значение, ","+Значение);

		КонецЕсли;
		
	КонецЦикла;

	ВставитьВТекстЗапроса(ТекстЗапроса, "#ЗначениеКлючей", ЗначениеКлючей);
	ВставитьВТекстЗапроса(ТекстЗапроса, "ЛЕВОЕ СОЕДИНЕНИЕ #СоединениеЗначениеЗаменяемыхРеквизитов ПО ИСТИНА", СоединениеЗначениеЗаменяемыхРеквизитов);
	ВставитьВТекстЗапроса(ТекстЗапроса, "&СвязиПоКлючу", СвязиПоКлючу);
	ВставитьВТекстЗапроса(ТекстЗапроса, "&НеИзменяемыеРеквизиты", ?(ПустаяСтрока(НеИзменяемыеРеквизиты), "НЕОПРЕДЕЛЕНО", НеИзменяемыеРеквизиты));
	ВставитьВТекстЗапроса(ТекстЗапроса, "&ИзменяемыеРеквизиты",  ?(ПустаяСтрока(ИзменяемыеРеквизиты), "НЕОПРЕДЕЛЕНО", ИзменяемыеРеквизиты));
	
	ВставитьВТекстЗапроса(ТекстЗапроса, "#ТаблицаКлюча", ТаблицаКлюча);
	ВставитьВТекстЗапроса(ТекстЗапроса, "#ИмяКлюча", ИмяКлюча);
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ШаблонЗапроса()
	
	Возврат "
	|ВЫБРАТЬ
	|	Таб.Ссылка КАК Ссылка,
	|	&НеИзменяемыеРеквизиты,
	|	&ИзменяемыеРеквизиты
	|ПОМЕСТИТЬ #ИмяКлюча_ИсходныеДанные
	|ИЗ
	|	#ТаблицаКлюча КАК Таб
	|ГДЕ
	|	ЛОЖЬ" + "
	|
	|#ЗначениеКлючей
	|;
	|" + "
	|ВЫБРАТЬ
	|	Таб.Ссылка КАК Ссылка,
	|	&НеИзменяемыеРеквизиты,
	|	&ИзменяемыеРеквизиты
	|ПОМЕСТИТЬ #ИмяКлюча_ЗначениеРеквизитовПослеЗамены
	|ИЗ
	|	#ИмяКлюча_ИсходныеДанные КАК Таб
	|   ЛЕВОЕ СОЕДИНЕНИЕ #СоединениеЗначениеЗаменяемыхРеквизитов ПО ИСТИНА
	|;
	|ВЫБРАТЬ
	|	Таб.Ссылка КАК Ссылка,
	|	Замена.Ссылка КАК Замена,
	|	&НеИзменяемыеРеквизиты,
	|	&ИзменяемыеРеквизиты
	|ИЗ
	|	#ИмяКлюча_ЗначениеРеквизитовПослеЗамены КАК Таб
	|	ЛЕВОЕ СОЕДИНЕНИЕ #ТаблицаКлюча КАК Замена
	|	ПО Таб.Ссылка <> Замена.Ссылка
	|	И &СвязиПоКлючу 
	|
	|";

КонецФункции

Процедура ВставитьВТекстЗапроса(ТекстЗапроса, ИмяПараметра, Текст)

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ИмяПараметра, Текст);

КонецПроцедуры

Процедура ДобавитьВТаблицыЗамены(ОригиналДубль, ТаблицыЗамен, СвязиПодчиненныхОбъектов) 

	МетаданныеКлючевогоРеквизита = ОригиналДубль.Ключ.Метаданные();
	ИмяТаблицыКлючевогоРеквизита = МетаданныеКлючевогоРеквизита.ПолноеИмя();
	КлючПоиска = СтрЗаменить(ИмяТаблицыКлючевогоРеквизита,".",""); 
	Если СвязиПодчиненныхОбъектов.Найти(МетаданныеКлючевогоРеквизита, "Метаданные") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаЗамен = ТаблицыЗамен[КлючПоиска];
	Если ТаблицаЗамен = Неопределено Тогда
		ТекстЗапроса = "ВЫБРАТЬ
		|	Таб.Ссылка КАК Оригинал,
		|	Таб.Ссылка КАК Дубль 
		|ИЗ
		|	#ИмяТаблицыКлючевогоРеквизита КАК Таб
		|ГДЕ
		|	ЛОЖЬ";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИмяТаблицыКлючевогоРеквизита", ИмяТаблицыКлючевогоРеквизита);
		ЗапросТаблицы = Новый Запрос(ТекстЗапроса);
		ТаблицаЗамен = ЗапросТаблицы.Выполнить().Выгрузить();
	    ТаблицыЗамен.Вставить(КлючПоиска, ТаблицаЗамен);
	КонецЕсли;
	
	СтрокаЗамены = ТаблицаЗамен.Добавить();
	СтрокаЗамены.Оригинал = ОригиналДубль.Ключ;
	СтрокаЗамены.Дубль = ОригиналДубль.Значение;

КонецПроцедуры

Процедура ПоместитьТаблицыЗаменВЗапрос(МВТ, ТаблицыЗамен)

	ЧастиЗапроса = Новый Массив;
	Разделитель = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	НЕОПРЕДЕЛЕНО КАК Оригинал,
	|	НЕОПРЕДЕЛЕНО КАК Дубль
	|ПОМЕСТИТЬ ТаблицаЗамен 
	|ГДЕ 
	|	ЛОЖЬ";
	
	ШаблонЗапросаВставки = "
	|ВЫБРАТЬ
	|	Таб.Оригинал КАК Оригинал,
	|	Таб.Дубль КАК Дубль
	|ПОМЕСТИТЬ ВТ_ИмяТаблицы
	|ИЗ
	|	&ИмяТаблицы КАК Таб";
	
	ШаблонЗапросаОбъединения = "
	|ВЫБРАТЬ
	|	Таб.Оригинал КАК Оригинал,
	|	Таб.Дубль КАК Дубль
	|ИЗ
	|	ВТ_ИмяТаблицы КАК Таб";

	Для каждого ТаблицаЗначения Из ТаблицыЗамен Цикл
	
		ЧастиЗапроса.Добавить(СтрЗаменить(ШаблонЗапросаВставки, "ИмяТаблицы", ТаблицаЗначения.Ключ));			
		Запрос.УстановитьПараметр(ТаблицаЗначения.Ключ, ТаблицаЗначения.Значение); 
		ТекстЗапроса = ТекстЗапроса + Разделитель + СтрЗаменить(ШаблонЗапросаОбъединения, "ИмяТаблицы", ТаблицаЗначения.Ключ);
		
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ИНДЕКСИРОВАТЬ ПО Оригинал";
	
	ЧастиЗапроса.Добавить(ТекстЗапроса);
	Запрос.Текст = СтрСоединить(ЧастиЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	Запрос.Выполнить();

КонецПроцедуры

Процедура ВыполнитьПоискПоПрикладнымПравилам(Знач ИспользуемыеСвязи, Знач НеподобранныеЗамены, Знач ОписаниеПодчиненногоОбъекта, Знач ПарыЗамен)
	
	Перем ПараметрыМетодаПоиска, Сч;
	
	Для Сч = 0 По НеподобранныеЗамены.Количество() - 1 Цикл
		
		НеподобранныеЗамены[Сч] = НовыйПараметрыЗамены(
			НеподобранныеЗамены[Сч],
			ОписаниеПодчиненногоОбъекта,
			ИспользуемыеСвязи);	
		
	КонецЦикла;
	
	ПараметрыМетодаПоиска = Новый Массив;
	ПараметрыМетодаПоиска.Добавить(ПарыЗамен);
	ПараметрыМетодаПоиска.Добавить(НеподобранныеЗамены);
	ОбщегоНазначения.ВыполнитьМетодКонфигурации(
		ОписаниеПодчиненногоОбъекта.ИмяМодуляМетодаПоиска+".ПриПоискеЗаменыСсылок",
		ПараметрыМетодаПоиска);

КонецПроцедуры

Функция ОбъектыСКомандамиОбъединенияДублей()

	ОбъектыСКомандами = Новый Массив;
	ПоискИУдалениеДублейПереопределяемый.ПриОпределенииОбъектовСКомандамиОбъединенияДублейЗаменыСсылок(ОбъектыСКомандами);
	Возврат ОбъектыСКомандами;

КонецФункции

#КонецОбласти

#КонецОбласти
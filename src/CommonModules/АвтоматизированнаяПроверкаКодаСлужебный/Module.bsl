//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Предназначен для работы с системами автоматизации проверки кода. (АПК, SonarQube)
//////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура ВыполнитьОпросАвтотестовОбработчикЗадания() Экспорт
	//ИмяПроцедуры = "АвтоматизированнаяПроверкаКода.ВыполнитьОпросАвтотестов";
	//НаименованиеФоновогоЗадания = "Опрос автотестов (в потоках)";
	//КлючФоновогоЗадания = "ОпросАвтотестовМногопоточно";
	//ПараметрыОбработкиЗаданий = 
	//	РаботаСХранилищамиСлужебный.ПараметрыМногопоточнойОбработкиЗаданий(НаименованиеФоновогоЗадания, КлючФоновогоЗадания);
	//Результат = ДлительныеОперации.ВыполнитьПроцедуруВНесколькоПотоков(
	//	ИмяПроцедуры,
	//	ПараметрыОбработкиЗаданий.ПараметрыВыполнения,
	//	ПараметрыОбработкиЗаданий.НаборПараметровПотоков);
	
	// Линейный запуск
	Выборка = РаботаСХранилищамиСлужебный.ПараметрыЛинейнойОбработкиЗаданий();
	Пока Выборка.Следующий() Цикл
		АвтоматизированнаяПроверкаКода.ВыполнитьОпросАвтотестов(Выборка.Хранилище);
	КонецЦикла;
КонецПроцедуры

Процедура ОбновитьИсториюХранилищаВАПКОбработчикЗадания() Экспорт
	//ИмяПроцедуры = "АвтоматизированнаяПроверкаКода.ОбновитьИсториюХранилищаВАПК";
	//НаименованиеФоновогоЗадания = "Обновление истории хранилища в АПК (в потоках)";
	//КлючФоновогоЗадания = "ОбновитьИсториюХранилищаВАПКМногопоточно";
	//ПараметрыОбработкиЗаданий = 
	//	РаботаСХранилищамиСлужебный.ПараметрыМногопоточнойОбработкиЗаданий(НаименованиеФоновогоЗадания, КлючФоновогоЗадания);
	//Результат = ДлительныеОперации.ВыполнитьПроцедуруВНесколькоПотоков(
	//	ИмяПроцедуры,
	//	ПараметрыОбработкиЗаданий.ПараметрыВыполнения,
	//	ПараметрыОбработкиЗаданий.НаборПараметровПотоков);
	
	// Линейный запуск
	Выборка = РаботаСХранилищамиСлужебный.ПараметрыЛинейнойОбработкиЗаданий();
	Пока Выборка.Следующий() Цикл
		АвтоматизированнаяПроверкаКода.ОбновитьИсториюХранилищаВАПК(Выборка.Хранилище);
	КонецЦикла;
КонецПроцедуры

Процедура ЗагрузитьОшибкиАПКОбработчикЗадания() Экспорт
	//ИмяПроцедуры = "АвтоматизированнаяПроверкаКода.ЗагрузитьОшибкиАПК";
	//НаименованиеФоновогоЗадания = "Загрузка ошибок АПК (в потоках)";
	//КлючФоновогоЗадания = "ЗагрузитьОшибкиАПКМногопоточно";
	//ПараметрыОбработкиЗаданий = 
	//	РаботаСХранилищамиСлужебный.ПараметрыМногопоточнойОбработкиЗаданий(НаименованиеФоновогоЗадания, КлючФоновогоЗадания);
	//Результат = ДлительныеОперации.ВыполнитьПроцедуруВНесколькоПотоков(
	//	ИмяПроцедуры,
	//	ПараметрыОбработкиЗаданий.ПараметрыВыполнения,
	//	ПараметрыОбработкиЗаданий.НаборПараметровПотоков);
	
	// Линейный запуск
	Выборка = РаботаСХранилищамиСлужебный.ПараметрыЛинейнойОбработкиЗаданий();
	Пока Выборка.Следующий() Цикл
		АвтоматизированнаяПроверкаКода.ЗагрузитьОшибкиАПК(Выборка.Хранилище);
	КонецЦикла;
КонецПроцедуры

Процедура ОтправкаУведомленийСинтаксическойПроверкиОбработчикЗадания() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки КАК ОбъектПроверки,
		|	ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ЭтоПроверкаАПК КАК ЭтоПроверкаАПК,
		|	ВЫБОР
		|		КОГДА РезультатыСинтаксическойПроверки.ОбъектПроверки ЕСТЬ NULL
		|			ТОГДА 0
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ЭтоПроверкаАПК
		|					ТОГДА РезультатыСинтаксическойПроверки.КоличествоОшибокАПК
		|				ИНАЧЕ РезультатыСинтаксическойПроверки.КоличествоОшибокBSL_LS
		|			КОНЕЦ
		|	КОНЕЦ КАК КоличествоОшибок,
		|	ВЫБОР
		|		КОГДА ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки ССЫЛКА Справочник.ИсторияХранилища
		|			ТОГДА ЕСТЬNULL(Пользователи.Ссылка, ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
		|		ИНАЧЕ ВЫРАЗИТЬ(ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки КАК Справочник.ВерсииДополнений).Автор
		|	КОНЕЦ КАК Ответственный,
		|	ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки ССЫЛКА Справочник.ИсторияХранилища КАК ПроверкаВерсииИсторииХранилища,
		|	ВЫБОР
		|		КОГДА ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки ССЫЛКА Справочник.ИсторияХранилища
		|			ТОГДА ВЫРАЗИТЬ(ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки КАК Справочник.ИсторияХранилища).Код
		|		ИНАЧЕ ВЫРАЗИТЬ(ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки КАК Справочник.ВерсииДополнений).Наименование
		|	КОНЕЦ КАК ПредставлениеОбъекта,
		|	ВЫБОР
		|		КОГДА ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки ССЫЛКА Справочник.ИсторияХранилища
		|			ТОГДА ВЫРАЗИТЬ(ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки КАК Справочник.ИсторияХранилища).Владелец.Владелец.Наименование
		|		ИНАЧЕ ВЫРАЗИТЬ(ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки КАК Справочник.ВерсииДополнений).Владелец.Конфигурация.Наименование
		|	КОНЕЦ КАК ПредставлениеКонфигурации,
		|	ВЫБОР
		|		КОГДА ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки ССЫЛКА Справочник.ИсторияХранилища
		|			ТОГДА ВЫРАЗИТЬ(ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки КАК Справочник.ИсторияХранилища).Владелец.Наименование
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ХранилищеНаименование
		|ИЗ
		|	РегистрСведений.ОчередьУведомленийСинтаксическойПроверки.СрезПоследних КАК ОчередьУведомленийСинтаксическойПроверкиСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РезультатыСинтаксическойПроверки КАК РезультатыСинтаксическойПроверки
		|		ПО ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки = РезультатыСинтаксическойПроверки.ОбъектПроверки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО (ВЫРАЗИТЬ(ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки КАК Справочник.ИсторияХранилища).Автор = Пользователи.Код)
		|			И (ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.ОбъектПроверки ССЫЛКА Справочник.ИсторияХранилища)
		|ГДЕ
		|	ОчередьУведомленийСинтаксическойПроверкиСрезПоследних.Статус = &СтатусВОчереди";
	Запрос.УстановитьПараметр("СтатусВОчереди", Перечисления.СтатусыОперацийУведомлений.ВОчереди);
	Выборка = Запрос.Выполнить().Выбрать();
	УчетнаяЗапись = РаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
	ПараметрыПисьма = Новый Структура("Кому,Тема,Тело,ТипТекста");
	ПараметрыПисьма.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML;
	ШаблонТемы = "Результат синтаксической проверки (%1) ""%2"" %3 : %4.";
	
	Пока Выборка.Следующий() Цикл
		Попытка
			Если  Выборка.КоличествоОшибок = 0 Тогда
				КраткийРеузльтатВТеме = "Ошибок не обнаружено";
				ТелоПисьма = 
					"<html>
					|<head>
					|<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">
					|<title>Проверка коммита</title>
					|</head>
					|<body>
					|<h1>Коммит проверен, ошибок автоматической проверкой не обнаружено.</h2>
					|</body>
					|</html>";
			Иначе
				КраткийРеузльтатВТеме = СтрШаблон("Обнаружено %1 ошибок", Выборка.КоличествоОшибок);
				Если Выборка.ЭтоПроверкаАПК Тогда
					ОтчетПроверки = АвтоматизированнаяПроверкаКода.ПолучитьДанныеПроверкиАПК(Выборка.ПредставлениеОбъекта, Выборка.ХранилищеНаименование);
				Иначе
					ОтчетПроверки = СинтаксическаяПроверкаBSLLS.ОшибкиПоКоммиту(Выборка.ОбъектПроверки);
				КонецЕсли;
				ТелоПисьма = ОбщегоНазначенияКлиентСерверУК.ПолучитьHTMLИзТабличногоДокумента(ОтчетПроверки);
			КонецЕсли;
			
			СистемаПроверки = ?(Выборка.ЭтоПроверкаАПК, "АПК", "BSL-LS");
			Тема = СтрШаблон(ШаблонТемы, СистемаПроверки, Выборка.ПредставлениеОбъекта, Выборка.ПредставлениеКонфигурации, КраткийРеузльтатВТеме);
			АдресЭП = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
				Выборка.Ответственный,
				Справочники.ВидыКонтактнойИнформации.EmailПользователя,
				,
				,
				Новый Структура("ТолькоПервая", Истина));
			Если ЗначениеЗаполнено(АдресЭП) Тогда
				ПараметрыПисьма.Кому = АдресЭП;
				ПараметрыПисьма.Тема = Тема;
				ПараметрыПисьма.Тело = ТелоПисьма;
				Письмо = РаботаСПочтовымиСообщениями.ПодготовитьПисьмо(УчетнаяЗапись, ПараметрыПисьма);
				РаботаСПочтовымиСообщениями.ОтправитьПисьмо(УчетнаяЗапись, Письмо);
			КонецЕсли;
			
			Менеджер = РегистрыСведений.ОчередьУведомленийСинтаксическойПроверки.СоздатьМенеджерЗаписи();
			Менеджер.Период = ТекущаяДатаСеанса();
			Менеджер.ОбъектПроверки = Выборка.ОбъектПроверки;
			Менеджер.ЭтоПроверкаАПК = Выборка.ЭтоПроверкаАПК;
			Менеджер.Статус = Перечисления.СтатусыОперацийУведомлений.Выполнено;
			Менеджер.Записать(Ложь);
		Исключение
			ЗаписьЖурналаРегистрации(
				"Отправка уведомлений синтаксической проверки",
				УровеньЖурналаРегистрации.Ошибка,
				,
				Выборка.ОбъектПроверки,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти


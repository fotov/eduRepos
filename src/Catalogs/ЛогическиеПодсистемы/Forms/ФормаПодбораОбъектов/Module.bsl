
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЛогическаяПодсистема = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ЛогическаяПодсистема");
	Если Не ЗначениеЗаполнено(ЛогическаяПодсистема) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ИнициализироватьНастройкиОтбора();
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ИнициализироватьНастройкиОтбора()
	СхемаКомпоновкиДанных = Справочники.ЛогическиеПодсистемы.ПолучитьМакет("СкдПодбораОбъектов");
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	ИсточникДоступныхНастроекКомпоновкиДанных = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресВоВременномХранилище);
	КомпоновщикНастроекКД.Инициализировать(ИсточникДоступныхНастроекКомпоновкиДанных);
	КомпоновщикНастроекКД.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	ПараметрЛогическаяПодсистема = КомпоновщикНастроекКД.Настройки.ПараметрыДанных.Элементы.Найти("ЛогическаяПодсистема");
	ПараметрЛогическаяПодсистема.Значение = ЛогическаяПодсистема;

КонецПроцедуры


#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Асинх Процедура ЗаписатьИЗакрыть(Команда)
	Замещать = Ложь;
	ЕстьКонфликтыУстановкиПодсистемы = 
		Объекты
		.НайтиСтроки(Новый Структура("Пометка, ЕстьКонфликтНазначенияПодсистемы", Истина, Истина))
		.Количество();
	Если ЕстьКонфликтыУстановкиПодсистемы Тогда
		Режим = РежимДиалогаВопрос.ОКОтмена;
		Ответ = Ждать ВопросАсинх("Обнаружены объекты, которым назначена подсистема. Продолжить с замещением?", Режим);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		КонецЕсли;
		Замещать = Истина;
	КонецЕсли;
	ЗаписатьИЗакрытьНаСервере(Замещать);
	Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПодсистеме(Команда)
	ПодобратьПоПодсистеме();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВсеОбъекты(Команда)
	ОчиститьСообщения();
	ЗаполнитьОбъектыДляПодбораСФильтрами();
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	НастроитьПометки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	НастроитьПометки(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьПометкиВыделенных(Команда)
	Для Каждого ИдентификаторСтрокиОбъекта Из Элементы.Объекты.ВыделенныеСтроки Цикл
		СтрокаОбъекта = Объекты.НайтиПоИдентификатору(ИдентификаторСтрокиОбъекта);
		СтрокаОбъекта.Пометка = Не СтрокаОбъекта.Пометка;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
//Асинх Процедура ПодобратьПоПодсистеме()
//	Подсистема = Ждать ВвестиЗначениеАсинх(ПредопределенноеЗначение("Справочник.Подсистемы.ПустаяСсылка"), "Введите подсистему");
Процедура ПодобратьПоПодсистеме()
	ОчиститьСообщения();
	ВыбраннаяПодсистема = ПредопределенноеЗначение("Справочник.Подсистемы.ПустаяСсылка");
	ВыбралиЗначение = ВвестиЗначение(ВыбраннаяПодсистема, "Введите подсистему");
	Если ВыбралиЗначение И ЗначениеЗаполнено(ВыбраннаяПодсистема) Тогда
		ЗаполнитьОбъектыДляПодбора(ВыбраннаяПодсистема, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере(Замещать)
	
	ТекДата = ТекущаяДатаСеанса();
	ПомеченныеОбъекты = Объекты.НайтиСтроки(Новый Структура("Пометка", Истина));
	Для Каждого СтрокаНазначения Из ПомеченныеОбъекты Цикл
		Попытка
			МЗ = РегистрыСведений.СоставЛогическихПодсистем.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МЗ, СтрокаНазначения);
			МЗ.Период = ТекДата;
			МЗ.Записать();
		Исключение
			ОбщегоНазначения.СообщитьПользователю(
				"Не удалось установить логическую подсистему для объекта метаданных: "
				+ СтрокаНазначения.ОбъектМетаданных);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПометки(Значение)
	Для Каждого СтрокаОбъекта Из Объекты Цикл
		СтрокаОбъекта.Пометка = Значение;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбъектыДляПодбора(Подсистема = Неопределено, УстановитьПометкиДляОбъектовБезКонфликтов = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбъектыМетаданных.Ссылка КАК ОбъектМетаданных,
		|	&ЛогическаяПодсистема КАК ЛогическаяПодсистема,
		|	СоставЛогическихПодсистем.ЛогическаяПодсистема КАК ТекущаяЛогическаяПодсистема,
		|	СоставПодсистем.Подсистема КАК Подсистема,
		|	НЕ СоставЛогическихПодсистем.ЛогическаяПодсистема ЕСТЬ NULL
		|		И НЕ СоставЛогическихПодсистем.ЛогическаяПодсистема = &ЛогическаяПодсистема КАК ЕстьКонфликтНазначенияПодсистемы,
		|	ВЫБОР
		|		КОГДА &УстановитьПометкиДляОбъектовБезКонфликтов
		|			ТОГДА СоставЛогическихПодсистем.ЛогическаяПодсистема ЕСТЬ NULL
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Пометка,
		|	ОтветственныеЛогическихПодсистемСрезПоследних.Ответственный КАК ТекущийОтветственный,
		|	ОбъектыМетаданных.Владелец КАК Конфигурация
		|ИЗ
		|	Справочник.ОбъектыМетаданных КАК ОбъектыМетаданных
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставПодсистем КАК СоставПодсистем
		|		ПО ОбъектыМетаданных.Ссылка = СоставПодсистем.ОбъектМетаданных
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставЛогическихПодсистем КАК СоставЛогическихПодсистем
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтветственныеЛогическихПодсистем.СрезПоследних КАК ОтветственныеЛогическихПодсистемСрезПоследних
		|			ПО СоставЛогическихПодсистем.ЛогическаяПодсистема = ОтветственныеЛогическихПодсистемСрезПоследних.ЛогическаяПодсистема
		|		ПО ОбъектыМетаданных.Ссылка = СоставЛогическихПодсистем.ОбъектМетаданных
		|ГДЕ
		|	(&Подсистема = НЕОПРЕДЕЛЕНО
		|			ИЛИ СоставПодсистем.Подсистема = &Подсистема)
		|	И НЕ ОбъектыМетаданных.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Пометка УБЫВ,
		|	ОбъектыМетаданных.Владелец.Наименование,
		|	ОбъектыМетаданных.Наименование";
	
	Запрос.УстановитьПараметр("Подсистема", Подсистема);
	Запрос.УстановитьПараметр("ЛогическаяПодсистема", ЛогическаяПодсистема);
	Запрос.УстановитьПараметр("УстановитьПометкиДляОбъектовБезКонфликтов", УстановитьПометкиДляОбъектовБезКонфликтов);
	Объекты.Загрузить(Запрос.Выполнить().Выгрузить());
	Если УстановитьПометкиДляОбъектовБезКонфликтов Тогда
		ЕстьКонфликтНазначенияПодсистемы = 
			Объекты
			.НайтиСтроки(Новый Структура("ЕстьКонфликтНазначенияПодсистемы", Истина))
			.Количество();
		Если ЕстьКонфликтНазначенияПодсистемы Тогда
			ОбщегоНазначения.СообщитьПользователю(
				"Обнаружены объекты, которым уже назначена логическая подсистема.
				|С этих объектов сняты пометки.");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбъектыДляПодбораСФильтрами()
	СхемаКомпоновкиДанных = Справочники.ЛогическиеПодсистемы.ПолучитьМакет("СкдПодбораОбъектов");
	НастройкиКомпоновки = КомпоновщикНастроекКД.ПолучитьНастройки();
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("ЛогическаяПодсистема", ЛогическаяПодсистема);
	
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВыводаРезультата = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТЗ = Новый ТаблицаЗначений;
	ПроцессорВыводаРезультата.УстановитьОбъект(ТЗ);
	ПроцессорВыводаРезультата.Вывести(ПроцессорКомпоновки);
		
	Объекты.Загрузить(ТЗ);
КонецПроцедуры

#КонецОбласти
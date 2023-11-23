
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьОтборДинамическимСпискам();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьОтборДинамическимСпискам();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Замечение_ПроверкаКода.УстановитьHTML(ТекущийОбъект.ЗамечаниеHTML_ПроверкаКода, ПолучитьВложенияHTML(ТекущийОбъект.ЗамечаниехзВложения_ПроверкаКода));
	Элементы.Замечение_ПроверкаКода.Видимость = ЗначениеЗаполнено(Замечение_ПроверкаКода.ПолучитьТекст());
	
	СхемаБП = ТекущийОбъект.ПолучитьКартуМаршрута();
	
КонецПроцедуры

&НаКлиенте
Процедура СхемаБПВыбор(Элемент)
	Задача = ПолучитьСсылкуНаЗадачу(Элемент.ТекущийЭлемент.Значение);
	Если ЗначениеЗаполнено(Задача) Тогда
		ПоказатьЗначение(, Задача);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗадачаМетеорПриИзменении(Элемент)
	ЗадачаМетеорПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКоммиты

&НаКлиенте
Процедура КоммитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Поле = Элементы.КоммитыКоммитХО Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.КоммитХО);
	Иначе
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Коммит);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервереБезКонтекста
Функция ПолучитьВложенияHTML(хзВложения)
	
	Вложения = хзВложения.Получить();
	Если ТипЗнч(Вложения) = Тип("Структура") Тогда	
		Возврат Вложения;
	Иначе
		Возврат Новый Структура;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьОтборДинамическимСпискам()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЗадачиБП.Отбор, "БизнесПроцесс", Объект.Ссылка,,, Истина);
КонецПроцедуры

Функция ПолучитьСсылкуНаЗадачу(ТочкаМаршрута)
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗадачаИсполнителя.Ссылка КАК Ссылка
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
		|	И ЗадачаИсполнителя.ТочкаМаршрута = &ТочкаМаршрута";
	Запрос.УстановитьПараметр("БизнесПроцесс", Объект.Ссылка);
	Запрос.УстановитьПараметр("ТочкаМаршрута", ТочкаМаршрута);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Ссылка;
КонецФункции

&НаСервере
Процедура ЗадачаМетеорПриИзмененииНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Пользователи.Ссылка КАК Разработчик
		|ИЗ
		|	РегистрСведений.ЗадачиМетеорВерсийХранилища КАК ЗадачиМетеорВерсийХранилища
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО ЗадачиМетеорВерсийХранилища.ВерсияХранилища.Автор = Пользователи.Код
		|ГДЕ
		|	ЗадачиМетеорВерсийХранилища.ЗадачаМетеор = &ЗадачаМетеор";
	Запрос.УстановитьПараметр("ЗадачаМетеор", Объект.ЗадачаМетеор);
	ВыборкаРазработчик = Запрос.Выполнить().Выбрать();
	Если ВыборкаРазработчик.Количество() = 1 Тогда
		ВыборкаРазработчик.Следующий();
		Объект.Разработчик = ВыборкаРазработчик.Разработчик;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

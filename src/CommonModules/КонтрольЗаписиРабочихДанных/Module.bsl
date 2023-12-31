#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗагрузкаИсторииЗаписиРабочихДанныхОбработчикЗадания() Экспорт
	
	Параметры = ПараметрыКафка(Истина);
	КоличествоОтветовНольСообщений = 0;
	
	Пока Истина Цикл
		КоличествоСообщений = ЗагрузитьПорциюИсториюЗаписиРабочихДанных(Параметры);
		Сообщить(КоличествоСообщений);
		Если КоличествоСообщений = 0 Тогда
			КоличествоОтветовНольСообщений = КоличествоОтветовНольСообщений + 1;
			Если КоличествоОтветовНольСообщений <= 1 Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Если КоличествоСообщений < 100 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПараметрыКафка(Подписаться) Экспорт
	ПВХ = ПланыВидовХарактеристик.НастройкиПрограммы;
	Параметры = Новый Структура;
	Параметры.Вставить("Адрес", ОбщегоНазначенияПовтИспУК.ПолучитьЗначениеНастройкиПрограммы(ПВХ.ЛогированиеКафкаАдрес));
	Параметры.Вставить("Логин", ОбщегоНазначенияПовтИспУК.ПолучитьЗначениеНастройкиПрограммы(ПВХ.ЛогированиеКафкаЛогин));
	Параметры.Вставить("Пароль", ОбщегоНазначенияПовтИспУК.ПолучитьЗначениеНастройкиПрограммы(ПВХ.ЛогированиеКафкаПароль));
	Параметры.Вставить("Топик", ОбщегоНазначенияПовтИспУК.ПолучитьЗначениеНастройкиПрограммы(ПВХ.ЛогированиеКафкаТопик));
	Параметры.Вставить("Подписчик", Неопределено);
	Если Подписаться Тогда
		Подписаться(Параметры);
	КонецЕсли;
	Возврат Параметры;
КонецФункции

Функция Подписаться(Параметры = Неопределено) Экспорт
	
	Если Параметры = Неопределено Тогда
		Параметры = ПараметрыКафка(Ложь);
	КонецЕсли;
	
	ГруппаПодписчика = "repos";
	ИмяПодписчика = "repos" + ?(БлокировкаРаботыСВнешнимиРесурсами.РаботаСВнешнимиРесурсамиЗаблокирована(), "_dev", "");
	Автоподтверждение = Ложь;
	МаксимальныйРазмерОтветаБайт = 1000000;
	
	СоединениеКафка = Кафка.НовоеОписаниеСоединения(Параметры.Адрес, "json", Параметры.Логин, Параметры.Пароль);
	Параметры.Подписчик = Кафка.НовыйПодписчик(СоединениеКафка, ГруппаПодписчика, ИмяПодписчика, Автоподтверждение, МаксимальныйРазмерОтветаБайт);
	Кафка.ЗарегистрироватьПодписчика(Параметры.Подписчик);
	Кафка.Подписаться(Параметры.Подписчик, Параметры.Топик);
	
	ПВХ = ПланыВидовХарактеристик.НастройкиПрограммы;
	Партиция = РегистрыСведений.ЗначенияНастроекПрограммы.ПолучитьЗначениеНастройки(ПВХ.ЛогированиеКафкаПартиция);
	Сдвиг = РегистрыСведений.ЗначенияНастроекПрограммы.ПолучитьЗначениеНастройки(ПВХ.ЛогированиеКафкаСдвиг);
	Если ЗначениеЗаполнено(Сдвиг) Тогда
		ПодтвердитьПолучение(Параметры, Партиция, Сдвиг, Ложь);
	КонецЕсли;
	
	Возврат Параметры.Подписчик;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗагрузитьПорциюИсториюЗаписиРабочихДанных(Параметры)
	
	ПоследнееСообщение = Неопределено;
	Таблица = ПрочитатьПорциюДанных(Параметры, ПоследнееСообщение);
	ЗаполнитьОбъектыМетаданных(Таблица);
	
	Для Каждого Строка Из Таблица Цикл
		Запись = РегистрыСведений.ИсторияЗаписиРабочихДанных.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, Строка);
		Запись.Записать();
	КонецЦикла;
	
	Если ПоследнееСообщение <> Неопределено Тогда
		ПодтвердитьПолучение(Параметры, ПоследнееСообщение["partition"], ПоследнееСообщение["offset"], Истина);
	КонецЕсли;
	
	Возврат Таблица.Количество();
	
КонецФункции

Функция ПрочитатьПорциюДанных(Параметры, ПоследнееСообщение)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Рег.*
		|ИЗ
		|	РегистрСведений.ИсторияЗаписиРабочихДанных КАК Рег
		|ГДЕ
		|	ЛОЖЬ";
	Таблица = Запрос.Выполнить().Выгрузить();
	ТипСтрока = Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(150));
	Таблица.Колонки.Добавить("ИмяМетаданных", ТипСтрока);
	
	Сообщение = Неопределено;
	Сообщения = Кафка.ПолучитьСообщения(Параметры.Подписчик);
	Для Каждого Сообщение из Сообщения Цикл 
		Пакет = СтроковыеФункцииУККлиентСервер.ПрочитатьЗначениеJSON(Сообщение.Получить("value"));
		Если Не Пакет.Свойство("Ключ") Тогда
			Продолжить;
		КонецЕсли;
		Строка = Таблица.Добавить();
		Строка.ТекстПакета = Сообщение.Получить("value");
		Строка.ДатаВремя = Пакет.ДатаПакета;
		Строка.День = НачалоДня(Пакет.ДатаПакета);
		Строка.Дискриминант = Пакет.Ключ;
		Строка.База = Пакет.База;
		Строка.Пользователь = Пакет.Пользователь;
		Строка.ИмяМетаданных = СтрШаблон("%1.%2", Пакет.КлассМетаданных, Пакет.ИмяМетаданных);
		Части = Новый Массив;
		Для Каждого Эл Из Пакет.Реквизиты Цикл
			Части.Добавить(СтрШаблон("%1: %2", Эл.Ключ, Эл.Значение));
		КонецЦикла;
		Строка.ПредставлениеМетаданных = СтрСоединить(Части, ", ");
	КонецЦикла;
	
	Если Сообщения.Количество() Тогда
		ПоследнееСообщение = Сообщения[Сообщения.ВГраница()];
	КонецЕсли;
	
	Возврат Таблица;
	
КонецФункции

Процедура ЗаполнитьОбъектыМетаданных(Таблица)
	
	Таблица.Индексы.Добавить("Дискриминант, ИмяМетаданных");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.Дискриминант КАК Дискриминант,
		|	Таблица.ИмяМетаданных КАК ИмяМетаданных
		|ПОМЕСТИТЬ Таблица
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.Дискриминант КАК Дискриминант,
		|	Таблица.ИмяМетаданных КАК ИмяМетаданных,
		|	ОбъектыМетаданных.Ссылка КАК ОбъектМетаданных
		|ИЗ
		|	Таблица КАК Таблица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбъектыМетаданных КАК ОбъектыМетаданных
		|		ПО Таблица.ИмяМетаданных = ОбъектыМетаданных.Наименование
		|			И (ОбъектыМетаданных.Владелец = ЗНАЧЕНИЕ(Справочник.Конфигурации.Финансы1С))";
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Строки = Таблица.НайтиСтроки(Новый Структура("Дискриминант, ИмяМетаданных", Выборка.Дискриминант, Выборка.ИмяМетаданных));
		Для Каждого Строка Из Строки Цикл
			Строка.ОбъектМетаданных = Выборка.ОбъектМетаданных;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПодтвердитьПолучение(Параметры, Партиция, Сдвиг, ОбновитьБД)
	
	Квитанция = Новый Структура;
	Квитанция.Вставить("Топик", Параметры.Топик);
	Квитанция.Вставить("Партиция", Партиция);
	Квитанция.Вставить("Сдвиг", Сдвиг);
	Кафка.ПодтвердитьПолучение(Параметры.Подписчик, Квитанция);
	
	Если ОбновитьБД Тогда
		ПВХ = ПланыВидовХарактеристик.НастройкиПрограммы;
		РегистрыСведений.ЗначенияНастроекПрограммы.ЗаписатьЗначениеНастройки(ПВХ.ЛогированиеКафкаПартиция, Квитанция.Партиция);
		РегистрыСведений.ЗначенияНастроекПрограммы.ЗаписатьЗначениеНастройки(ПВХ.ЛогированиеКафкаСдвиг, Квитанция.Сдвиг);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

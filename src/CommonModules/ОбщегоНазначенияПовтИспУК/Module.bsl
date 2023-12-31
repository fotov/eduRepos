
#Область ПрограммныйИнтерфейс

// Возвращает структуру, содержащую значения реквизитов, прочитанные из информационной базы по ссылке на объект.
// Обёртка для кеширования значений. Детальное описание см. ОбщегоНазначения.ЗначенияРеквизитовОбъекта
//
// Параметры:
//  Ссылка    - ЛюбаяСсылка
//  Реквизиты - Строка
//            - Структура
//            - ФиксированнаяСтруктура
//            - Массив из Строка
//            - ФиксированныйМассив из Строка
//  ВыбратьРазрешенные - Булево
//  КодЯзыка - Строка
//
// Возвращаемое значение:
//  Структура
//
Функция ЗначенияРеквизитовОбъекта(Ссылка, Знач Реквизиты, ВыбратьРазрешенные = Ложь, Знач КодЯзыка = Неопределено) Экспорт
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты, ВыбратьРазрешенные, КодЯзыка);
КонецФункции

// Описание функции:
//  Функция возвращает значение настройки программы из регистра
//
// Параметры:
//  Настройка			 - ПланВидовХарактеристикСсылка.НастройкиПрограммы	 - Ссылка на настройку (или наименование)
//  ЗначениеПоУмолчанию	 - Произвольный	 - Возвращаемое значение, если настройка не установлена
//  ВернутьМассив		 - Булево - Вернуть результат как массив
// 
// Возвращаемое значение:
//   - Значение настройки
//
Функция ПолучитьЗначениеНастройкиПрограммы(Настройка, ЗначениеПоУмолчанию = Неопределено, ВернутьМассив = Ложь) Экспорт
	Возврат РегистрыСведений.ЗначенияНастроекПрограммы.ПолучитьЗначениеНастройки(Настройка, ЗначениеПоУмолчанию, ВернутьМассив);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти

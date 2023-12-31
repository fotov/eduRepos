//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Модуль предназначен для процедур и функций интеграции механизма дополнений.
// * Процедуры и функции должны быть независимы от конфигурации и библиотек.
//////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Сериализует переданные данные в строку JSON
//
// Параметры:
//  Данные	 - Произвольный	 - данные для преобразования. В общем случае - структура.
// 
// Возвращаемое значение:
//  Строка - строка в формате JSON
//
Функция ЗаписатьЗначениеJSON(Данные) Экспорт
	
	#Если Не ВебКлиент Тогда
	ЗаписьJSON = Новый ЗаписьJSON;
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(, Символы.Таб);
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	ЗаписатьJSON(ЗаписьJSON, Данные);
	СтрокаJSON = ЗаписьJSON.Закрыть();
	
	Возврат СтрокаJSON;
	#Иначе
	ВызватьИсключение "Запись JSON недоступна в веб клиенте.";
	#КонецЕсли
	
КонецФункции

// Получает данные из строки JSON
//
// Параметры:
//  СтрокаJSON	 - Строка
// 
// Возвращаемое значение:
//  Произвольный
//
Функция ПрочитатьЗначениеJSON(СтрокаJSON) Экспорт
	
	Результат = "";
	
	#Если Не ВебКлиент Тогда
	Попытка	
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
		Результат = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
	Исключение
	КонецПопытки;
	#КонецЕсли
	
	Возврат Результат;
	
КонецФункции

// Дополняет массив приемник из массива источника
//
// Параметры:
//  МассивПриемник	 - Массив - массив приемник
//  МассивИсточник	 - Массив - массив источник
//
Процедура ДополнитьМассив(МассивПриемник, МассивИсточник) Экспорт
	Для Каждого Значение Из МассивИсточник Цикл
		МассивПриемник.Добавить(Значение);
	КонецЦикла;
КонецПроцедуры

#Область Словари
// Методы для описания правил конвертации значений

// Константа ТипДополненияРасширение
// 
// Возвращаемое значение:
//  Строка - 
//
Функция ТипДополненияРасширение() Экспорт
	Возврат "Расширение";
КонецФункции

// Константа ТипДополненияДопОтчетОбработка
// 
// Возвращаемое значение:
//  Строка - 
//
Функция ТипДополненияДопОтчетОбработка() Экспорт
	Возврат "ДополнительныйОтчетИлиОбработка";
КонецФункции

// Константа РасширениеФайлаОбработки
// 
// Возвращаемое значение:
//  Строка - 
//
Функция РасширениеФайлаОбработки() Экспорт
	Возврат "epf";
КонецФункции

// Константа РасширениеФайлаОтчета
// 
// Возвращаемое значение:
//  Строка - 
//
Функция РасширениеФайлаОтчета() Экспорт
	Возврат "erf";
КонецФункции

// Константа РасширениеФайлаРасширения
// 
// Возвращаемое значение:
//  Строка - 
//
Функция РасширениеФайлаРасширения() Экспорт
	Возврат "cfe";
КонецФункции

// Константа СтатусПеренос
// 
// Возвращаемое значение:
//  Строка - 
//
Функция СтатусПеренос() Экспорт
	Возврат "Перенос";
КонецФункции

#КонецОбласти

// Заполняет коллекцию данными, прочитанными из массива структур
//
// Параметры:
//  Коллекция		 - ТаблицаЗначений, ДанныеФормыСтруктура - коллекция, в которую помещаются данные при чтении
//  МассивСтруктур	 - Массив - массив структур
//
Процедура ПрочитатьМассивСтруктурВКоллекцию(Коллекция, МассивСтруктур) Экспорт
	
	Для Каждого Структура Из МассивСтруктур Цикл
		ЗаполнитьЗначенияСвойств(Коллекция.Добавить(), Структура);
	КонецЦикла;
	
КонецПроцедуры

// Получает коллекцию, с добавленными "зеркально" ключ=значение:значение=ключ
//
// Параметры:
//  КоллекцияИсточник	 - Структура, Соответствие - коллекция источник
// 
// Возвращаемое значение:
//  Структура, Соответствие - результирующая коллекция
//
Функция ПолучитьЗеркальнуюКоллекцию(КоллекцияИсточник) Экспорт
	
	КоллекцияПриемник = Новый(ТипЗнч(КоллекцияИсточник));
	
	Для Каждого КлючИЗначение Из КоллекцияИсточник Цикл
		КоллекцияПриемник.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КоллекцияПриемник.Вставить(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	
	Возврат КоллекцияПриемник;
	
КонецФункции

#КонецОбласти

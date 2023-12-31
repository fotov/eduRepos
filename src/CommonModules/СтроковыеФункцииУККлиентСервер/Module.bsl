
#Область ПрограммныйИнтерфейс

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
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	Результат = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	#КонецЕсли
	
	Возврат Результат;
	
КонецФункции

// Сериализует переданные данные в строку JSON
//
// Параметры:
//  Данные	 - Произвольный	 - данные для преобразования. В общем случае - структура.
// 
// Возвращаемое значение:
//  Строка - строка в формате JSON
//
Функция ЗаписатьЗначениеJSON(Данные) Экспорт
	
	СтрокаJSON = "";
	
	#Если Не ВебКлиент Тогда
	ЗаписьJSON = Новый ЗаписьJSON;
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(, Символы.Таб);
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	ЗаписатьJSON(ЗаписьJSON, Данные);
	СтрокаJSON = ЗаписьJSON.Закрыть();
	#КонецЕсли
	
	Возврат СтрокаJSON;
	
КонецФункции

// Разбивает строку из нескольких объединенных слов в строку с отдельными словами.
// Признаком начала нового слова считается символ в верхнем регистре.
// * Заимстована из ОценкаПроизводительности.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//
// Возвращаемое значение:
//  Строка - строка, разделенная по словам.
//
// Примеры:
//  РазложитьСтрокуПоСловам("ОдинДваТри") - возвратит строку "Один два три".
//  РазложитьСтрокуПоСловам("одиндватри") - возвратит строку "одиндватри".
//
Функция РазложитьСтрокуПоСловам(Знач Строка) Экспорт
	
	МассивСлов = Новый Массив;
	
	ПозицииСлов = Новый Массив;
	Для ПозицияСимвола = 1 По СтрДлина(Строка) Цикл
		ТекСимвол = Сред(Строка, ПозицияСимвола, 1);
		Если ТекСимвол = ВРег(ТекСимвол) 
			И (ОценкаПроизводительностиКлиентСервер.ТолькоКириллицаВСтроке(ТекСимвол) 
				Или ОценкаПроизводительностиКлиентСервер.ТолькоЛатиницаВСтроке(ТекСимвол)) Тогда
			ПозицииСлов.Добавить(ПозицияСимвола);
		КонецЕсли;
	КонецЦикла;
	
	Если ПозицииСлов.Количество() > 0 Тогда
		ПредыдущаяПозиция = 0;
		Для Каждого Позиция Из ПозицииСлов Цикл
			Если ПредыдущаяПозиция > 0 Тогда
				Подстрока = Сред(Строка, ПредыдущаяПозиция, Позиция - ПредыдущаяПозиция);
				Если Не ПустаяСтрока(Подстрока) Тогда
					МассивСлов.Добавить(СокрЛП(Подстрока));
				КонецЕсли;
			КонецЕсли;
			ПредыдущаяПозиция = Позиция;
		КонецЦикла;
		
		Подстрока = Сред(Строка, Позиция);
		Если Не ПустаяСтрока(Подстрока) Тогда
			МассивСлов.Добавить(СокрЛП(Подстрока));
		КонецЕсли;
	КонецЕсли;
	
	Для Индекс = 1 По МассивСлов.ВГраница() Цикл
		МассивСлов[Индекс] = НРег(МассивСлов[Индекс]);
	КонецЦикла;
	
	Если МассивСлов.Количество() <> 0 Тогда
		Результат = СтрСоединить(МассивСлов, " ");
	Иначе
		Результат = Строка;
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Форматирует количество секунд в количество дней, часов, минут, секунд.
Функция ПредставлениеКоличестваВремени(КоличествоСекунд) Экспорт

	Секунды = КоличествоСекунд % 60;
	КоличествоМинут = (КоличествоСекунд - Секунды) / 60;
	Минуты = КоличествоМинут % 60;
	КоличествоЧасов = (КоличествоМинут - Минуты) / 60;
	Часы = КоличествоЧасов % 24;
	Дни = (КоличествоЧасов - Часы) / 24;

	ПредставлениеДней = ?(ЗначениеЗаполнено(Дни), Строка(Дни) + " дн.", "");
	ПредставлениеЧасов = ?(ЗначениеЗаполнено(Часы), Строка(Часы) + " ч.", "");
	ПредставлениеМинут = ?(ЗначениеЗаполнено(Минуты), Строка(Минуты) + " мин.", "");
	
	Результат = СтрШаблон("%1%2%3 %4 сек.", ПредставлениеДней, ПредставлениеЧасов, ПредставлениеМинут, Строка(Секунды));

	Возврат Результат;

КонецФункции

// Возвращает представление прошедшего времени
// Внимание, если у вас старая платформа и не поддерживает  метод "СтрокаСЧислом" закоментируйте строки и раскоментируйте строки над ними
//
// Параметры:
//  РазницаВремени  - Число - Высчитанная разница времени в секундах/милисекундах
//	ВремяВМилисекундах - Булево - Время передано в милисекундах
//
// Возвращаемое значение:
//   Строка   - Представление разницы времени
//
Функция ПредставлениеВремени(РазницаВремени, ВремяВМилисекундах = Ложь) Экспорт
	
	РазмерЧаса = 3600;
	РазмерМинуты = 60;
	РазмерСекунды = 1;
	
	Если ВремяВМилисекундах Тогда
		
		РазмерЧаса = РазмерЧаса * 1000;
		РазмерМинуты = РазмерМинуты * 1000;
		РазмерСекунды = РазмерСекунды * 1000;
		
	КонецЕсли;
	
	Часов = Цел(РазницаВремени / РазмерЧаса);
	Минут = Цел((РазницаВремени - (Часов * РазмерЧаса)) / РазмерМинуты);
	Секунд = Цел((РазницаВремени - ((Часов * РазмерЧаса) + (Минут * РазмерМинуты))) / РазмерСекунды);
	
	Если ВремяВМилисекундах Тогда
		
		Милисекунд = РазницаВремени - ((Часов * РазмерЧаса) + (Минут * РазмерМинуты) + (Секунд * РазмерСекунды));
		
	Иначе
		
		Милисекунд = Цел((РазницаВремени - ((Часов * РазмерЧаса) + (Минут * РазмерМинуты) + (Секунд * РазмерСекунды))) * 1000);
		
	КонецЕсли;
	
	ВремяТекст = "";
	
	Если РазницаВремени >= РазмерЧаса Тогда
		
		//ВремяТекст = ВремяТекст + Строка(Часов) + " час.";
		ВремяТекст = ВремяТекст + " " + СтрокаСЧислом(";%1 час;;%1 часа;%1 часов;%1 часа", Часов, ВидЧисловогоЗначения.Количественное);
		
	КонецЕсли;
	
	Если РазницаВремени >= РазмерМинуты Тогда
		
		//ВремяТекст = ВремяТекст + ?(Часов > 0, ?(Секунд > 0, " ", " и "), "") + Строка(Минут) + " мин.";
		ВремяТекст = ВремяТекст + ?(Часов > 0, ?(Секунд > 0, " ", " и "), "") + " " + СтрокаСЧислом(";%1 минута;;%1 минуты;%1 минут;%1 минут", Минут, ВидЧисловогоЗначения.Количественное);
		
	КонецЕсли;
	
	Если РазницаВремени >= РазмерСекунды и Секунд > 0 Тогда
		
		//ВремяТекст = ВремяТекст + ?(Минут > 0, ?(Милисекунд > 0, " ", " и "), "") + Строка(Секунд) + " сек.";
		ВремяТекст = ВремяТекст +  ?(Минут > 0, ?(Милисекунд > 0, " ", " и "), "") + " " + СтрокаСЧислом(";%1 секунда;;%1 секунды;%1 секунд;%1 секунд", Секунд, ВидЧисловогоЗначения.Количественное);
		
	КонецЕсли;
	
	Если Милисекунд > 0 и РазницаВремени <= РазмерСекунды Тогда
		
		//ВремяТекст = ВремяТекст + ?(Секунд > 0, " и ", "") + Строка(Милисекунд) + " мсек.";
		ВремяТекст = ВремяТекст + Строка(Милисекунд) + " мсек.";
		
	КонецЕсли;
	
	Возврат ВремяТекст;
	
КонецФункции // ПолучитьПредставлениеВремени()

#Область РаботаСHTML

Функция outerHTML(ЭлементHTML) Экспорт
   ЗаписьDOM = Новый ЗаписьDOM; 
   ЗаписьHTML = Новый ЗаписьHTML;
   ЗаписьHTML.УстановитьСтроку(); 
   ЗаписьDOM.Записать(ЭлементHTML, ЗаписьHTML);
   Возврат ЗаписьHTML.Закрыть();
КонецФункции
 
Функция innerHTML(ЭлементHTML) Экспорт
   ЗаписьDOM = Новый ЗаписьDOM; 
   ЗаписьHTML = Новый ЗаписьHTML;
   ЗаписьHTML.УстановитьСтроку();
   Для Каждого Стр из ЭлементHTML.ДочерниеУзлы Цикл 
      ЗаписьDOM.Записать(Стр, ЗаписьHTML);
   КонецЦикла;
   Возврат ЗаписьHTML.Закрыть();
КонецФункции

Функция ПреобразоватьТекстВДокументДом(Текст) Экспорт
   ЧтениеHTML = Новый ЧтениеHTML;
   ЧтениеHTML.УстановитьСтроку(Текст);
   ПостроительDOM = Новый ПостроительDOM;
   Возврат ПостроительDOM.Прочитать(ЧтениеHTML);
КонецФункции

Функция ПреобразоватьДокументДомВТекст(ЭлементДом) Экспорт
   ЗаписьDOM = Новый ЗаписьDOM; 
   ЗаписьHTML = Новый ЗаписьHTML;
   ЗаписьHTML.УстановитьСтроку(); 
   ЗаписьDOM.Записать(ЭлементДом, ЗаписьHTML);
   Возврат ЗаписьHTML.Закрыть();
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
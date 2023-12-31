#Область ПрограммныйИнтерфейс

Процедура ДобавитьСообщение(Текст, Шаг, Ошибка = Ложь) Экспорт
	БизнесПроцессы.КонвейерОбработки.ДобавитьСообщение(ЭтотОбъект, Текст, Шаг, Ошибка);
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	АвтотестыКоличествоСтрок = Автотесты.Количество() - Автотесты.НайтиСтроки(Новый Структура("Группа", "Итоги")).Количество();
	КоличествоОшибокАвтотестов = Автотесты.НайтиСтроки(Новый Структура("Ошибка", Истина)).Количество();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	ОшибкаОбновленияТестовыхБаз = Ложь;
	ТекстОшибкиОбновленияТестовыхБаз = "";
КонецПроцедуры

Процедура ПодготовкаТестовыхБазПередСозданиемВложенныхБизнесПроцессов(ТочкаМаршрутаБизнесПроцесса, ФормируемыеБизнесПроцессы, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодготовкаТестовойБазы.СтрокаСоединенияПриемник КАК СтрокаСоединенияПриемник
		|ИЗ
		|	БизнесПроцесс.ПодготовкаТестовойБазы КАК ПодготовкаТестовойБазы
		|ГДЕ
		|	ПодготовкаТестовойБазы.КонвейерОбработки = &Владелец
		|	И ПодготовкаТестовойБазы.ПометкаУдаления = ЛОЖЬ";
	Запрос.УстановитьПараметр("Владелец", Ссылка);
	СозданныеБизнесПроцессы = Запрос.Выполнить().Выгрузить();
	Для Каждого КонфигурацияТестовыеБазы Из ТестовыеБазы Цикл
		Если СозданныеБизнесПроцессы.Найти(КонфигурацияТестовыеБазы.СтрокаСоединения) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
	    НовыйПроцесс = БизнесПроцессы.ПодготовкаТестовойБазы.СоздатьБизнесПроцесс();
		НовыйПроцесс.Дата = ТекущаяДатаСеанса();
		НовыйПроцесс.Конфигурация = КонфигурацияТестовыеБазы.Конфигурация;
		НовыйПроцесс.КонвейерОбработки = Ссылка;
		НовыйПроцесс.Коммит = Неопределено;
		НовыйПроцесс.СтрокаСоединенияИсточник = КонфигурацияТестовыеБазы.СтрокаСоединенияИсточник;
		НовыйПроцесс.СтрокаСоединенияПриемник = КонфигурацияТестовыеБазы.СтрокаСоединения;
	    ФормируемыеБизнесПроцессы.Добавить(НовыйПроцесс);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОжиданиеЗавершенияПайплайнаПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	ДобавитьСообщение(СтрШаблон("Пайплайн завершен"), ТочкаМаршрутаБизнесПроцесса);
	Записать();
КонецПроцедуры

Процедура ОповеститьОРезультатеПайплайнаПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	Если ОшибкаОбновленияТестовыхБаз Тогда
		КороткийТекст = ТекстОшибкиОбновленияТестовыхБаз;
		Если СтрДлина(КороткийТекст) > 1000 Тогда
			Части = СтрРазделить(СтрЗаменить(КороткийТекст, "---", "^"), "^", Ложь);
			Для Сч = 0 По Части.Количество() - 1 Цикл
				Части[Сч] = СокрЛП(Части[Сч]);
				ЧислоСтрокЧасти = СтрЧислоСтрок(Части[Сч]);
				Если ЧислоСтрокЧасти > 2 Тогда
					Части[Сч] = СтрПолучитьСтроку(Части[Сч], 1) + Символы.ПС + СтрПолучитьСтроку(Части[Сч], ЧислоСтрокЧасти);
				КонецЕсли;
			КонецЦикла;
			КороткийТекст = СтрСоединить(Части, Символы.ПС + "---" + Символы.ПС);
		КонецЕсли;
		ТекстТелеграм = СтрШаблон("Не удалось развернуть тестовые базы для интеграционных тестов!
			|%1
			|%2", ЭтотОбъект, КороткийТекст);
	ИначеЕсли НеЗапускатьПайплайн = Ложь Тогда
		ТекстТелеграм = СтрШаблон("%1, пайплайн #%2 с ошибками %3", 
			ЭтотОбъект, ИдентификаторКонвейера, КонвейерОбработкиСервер.URLКонвейера(Хранилище, ИдентификаторКонвейера));
		Если ЭтотОбъект.АвтотестыКоличествоСтрок = 0 Тогда
			ТекстТелеграм = СтрЗаменить(ТекстТелеграм, "с ошибками", "не отработала, тесты по пайплайну не запустились!");
		ИначеЕсли КоличествоОшибокАвтотестов = 0 или ЭтотОбъект.АвтотестыКоличествоСтрок = 0 Тогда
			ТекстТелеграм = СтрЗаменить(ТекстТелеграм, "с ошибками", "без ошибок");
		КонецЕсли;
		ТекстТелеграм = СтрШаблон("%1 (%2/%3)", ТекстТелеграм, XMLСтрока(ЭтотОбъект.КоличествоОшибокАвтотестов), XMLСтрока(ЭтотОбъект.АвтотестыКоличествоСтрок));
	ИначеЕсли НеОбновлятьТествыеБазы = Ложь Тогда
		ТекстТелеграм = СтрШаблон("%1 завершена", ЭтотОбъект);
	Иначе
		Возврат;
	КонецЕсли;
	Ответственные = Константы.КонвейерОбработкиОповещениеТелеграммАвтотесты.Получить();
	Ответственные = Сред(Ответственные, СтрНайти(Ответственные, "@") - 1);
	ТекстТелеграм = ТекстТелеграм + " " + Ответственные;
	ВнешниеДанные.ОтправитьВТелеграм(ТекстТелеграм);
КонецПроцедуры

Процедура СоздаватьТестовыеБазыПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = НеОбновлятьТествыеБазы = Ложь;
КонецПроцедуры

Процедура ЗапускатьПайплайнПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = НеЗапускатьПайплайн = Ложь; // И ОшибкаОбновленияТестовыхБаз = Ложь;
КонецПроцедуры

Процедура ПроверкаУспехаПодготовкиТестовыхБазПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	ОшибкаОбновленияТестовыхБаз = ТестовыеБазы.НайтиСтроки(Новый Структура("ОшибкаПроготовки", Истина)).Количество() > 0;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПодготовкаТестовойБазы.СтрокаСоединенияПриемник КАК СтрокаСоединения,
		|	ПодготовкаТестовойБазы.ВсеСообщения КАК Сообщения
		|ИЗ
		|	БизнесПроцесс.ПодготовкаТестовойБазы КАК ПодготовкаТестовойБазы
		|ГДЕ
		|	ПодготовкаТестовойБазы.КонвейерОбработки = &БП
		|	И ПодготовкаТестовойБазы.ОшибкаСозданияКлона = ИСТИНА
		|	И ПодготовкаТестовойБазы.ВсеСообщения ПОДОБНО ""%_%""";
	Запрос.УстановитьПараметр("БП", Задача.БизнесПроцесс);
	Выборка = Запрос.Выполнить().Выбрать();
	Тексты = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Тексты.Добавить(СтрШаблон("%1: %2", Выборка.СтрокаСоединения, Выборка.Сообщения));
	КонецЦикла;
	ТекстОшибкиОбновленияТестовыхБаз = СтрСоединить(Тексты, Символы.ПС + "---" + Символы.ПС);
	Записать();
КонецПроцедуры

#КонецОбласти

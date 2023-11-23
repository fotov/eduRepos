
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Форма задачи исполнителя для бизнес процесса КонтрольТрудозатрат
//  
//////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ЗадачаМетеор = Задачи.ЗадачаИсполнителя.ЗадачаМетеор(Объект.Ссылка);
		Если Не ЗадачаМетеор.Пустая() Тогда
			ЗаполнитьИсполнителейДляОценки();
			///СтандартныеПодсистемыКлиент.РазвернутьУзлыДерева(ЭтаФорма, "ОценкаПоИсполнителям",, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.ВыполнитьЗадачу Тогда
		ЗаписатьОценкуТрудозатрат(ОценкаПоИсполнителям);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьЗаполнениеОценкиПоИсполнителям(ОценкаПоИсполнителям, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеОценкиПоИсполнителям(Дерево, Отказ)
	
	Для Каждого ОценкаПоИсполнителю Из Дерево.ПолучитьЭлементы() Цикл
		Если Не ОценкаПоИсполнителю.ПолучитьРодителя() = Неопределено Тогда
			Если ОценкаПоИсполнителю.Исполнитель.Пустая() Тогда
				ТекстСообщения = СтрШаблон(
					"Поле ""Исполнитель"" не заполнено. Исполнитель(стр): %1, роль: %2, затрачено: %3",
					ОценкаПоИсполнителю.ИсполнительСтрокой,
					ОценкаПоИсполнителю.РольИсполнителя,
					ОценкаПоИсполнителю.Затрачено);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			КонецЕсли;
		КонецЕсли;
		ПроверитьЗаполнениеОценкиПоИсполнителям(ОценкаПоИсполнителю, Отказ);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьОценкуТрудозатрат(ДеревоОценкаПоИсполнителям)
	
	Для Каждого ОценкаПоИсполнителю Из ДеревоОценкаПоИсполнителям.ПолучитьЭлементы() Цикл
		
		Если Истина
				И Не ОценкаПоИсполнителю.ПолучитьРодителя() = Неопределено
				И ОценкаПоИсполнителю.ЕстьПревышение Тогда
			Менеджер = РегистрыСведений.РезультатыКонтроляТрудозатрат.СоздатьМенеджерЗаписи();
			Менеджер.ЗадачаМетеор = ЗадачаМетеор;
			Менеджер.Исполнитель = ОценкаПоИсполнителю.Исполнитель;
			Менеджер.СогласованнаяОценка = ОценкаПоИсполнителю.СогласованнаяОценка;
			Менеджер.КоличествоСверхОценки = ОценкаПоИсполнителю.Затрачено - ОценкаПоИсполнителю.СогласованнаяОценка;
			Менеджер.Комментарий = ОценкаПоИсполнителю.Комментарий;
			Менеджер.Дата = ТекущаяДатаСеанса();
			Менеджер.Записать();
		КонецЕсли;
		ЗаписатьОценкуТрудозатрат(ОценкаПоИсполнителю);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ОценкаПоИсполнителям

&НаКлиенте
Процедура ОценкаПоИсполнителямСогласованнаяОценкаПриИзменении(Элемент)
	Согласовано = Элементы.ОценкаПоИсполнителям.ТекущиеДанные.СогласованнаяОценка;
	Затрачено = Элементы.ОценкаПоИсполнителям.ТекущиеДанные.Затрачено;
	Элементы.ОценкаПоИсполнителям.ТекущиеДанные.ЕстьПревышение = (Затрачено - Согласовано) > 0;
КонецПроцедуры

&НаКлиенте
Процедура ОценкаПоИсполнителямИсполнительЗадачиПриИзменении(Элемент)
	
	ДанныеОценки = ОценкаПоИсполнителям.НайтиПоИдентификатору(Элементы.ОценкаПоИсполнителям.ТекущаяСтрока);
	ДанныеОценки.Команда = Неопределено;
	Если Не ДанныеОценки.Исполнитель.Пустая() Тогда
		ДанныеОценки.Команда = КомандаИсполнителя(ДанныеОценки.Исполнитель);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОценкаПоИсполнителямПередНачаломИзменения(Элемент, Отказ)
	
	БлокируемыеЭлементы = ЭлементыРедактируемыеВДетальныхЗаписях();
	
	Если Истина
			И Не БлокируемыеЭлементы.Найти(Элементы.ОценкаПоИсполнителям.ТекущийЭлемент) = Неопределено
			И Элементы.ОценкаПоИсполнителям.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выполнена(Команда)

	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если Записать(Новый Структура("ВыполнитьЗадачу", Истина)) Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Выполнение:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		
		ОповеститьОбИзменении(Объект.Ссылка);
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетАнализТрудозатрат(Команда)
	
	ПараметрыФормы = Новый Структура(
		"Отбор, КлючНазначенияИспользования, СформироватьПриОткрытии", 
		Новый Структура("ЗадачаМетеор", ЗадачаМетеор),
		"АнализТрудозатратПриСогласовании",
		Истина);
	
	ОткрытьФорму(
		"Отчет.АнализТрудозатрат.Форма", 
		ПараметрыФормы, 
		ЭтаФорма, 
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОценкуПоИсполнителям(Команда)
	ТекстВопроса = "Таблица исполнителей будет очищена. Продолжить?";
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаполнитьОценкуПоИсполнителямПослеПодтверждения", ЭтотОбъект);
	ПоказатьВопрос(ОповещениеОЗавершении, ТекстВопроса,РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОценкуПоИсполнителям(Команда)
	ОчиститьОценкуПоИсполнителямНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьИсполнителейДляОценки()
	
	ЧасыПоЗадаче = Справочники.ЗадачиМетеор.ПолучитьЧасыПоЗадачеМетеор(ЗадачаМетеор);
	Если Не ЧасыПоЗадаче.Количество() Тогда
		Возврат;
	КонецЕсли;
		
	ЧасыПоЗадаче.Свернуть("Пользователь, Роль", "Затрачено");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЧасыПоЗадаче", ЧасыПоЗадаче);
	Запрос.УстановитьПараметр("ЗадачаМетеор", ЗадачаМетеор);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЧасыПоЗадаче.Пользователь КАК Пользователь,
		|	ЧасыПоЗадаче.Роль КАК Роль,
		|	ЧасыПоЗадаче.Затрачено КАК Затрачено
		|ПОМЕСТИТЬ ЧасыПоЗадаче
		|ИЗ
		|	&ЧасыПоЗадаче КАК ЧасыПоЗадаче
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Исполнитель,
		|	ЧасыПоЗадаче.Пользователь КАК ИсполнительСтрокой,
		|	ЧасыПоЗадаче.Роль КАК РольСтрокой,
		|	ЧасыПоЗадаче.Затрачено КАК Затрачено,
		|	РолиИсполнителей.Ссылка КАК РольИсполнителя,
		|	Пользователи.Команда КАК Команда
		|ПОМЕСТИТЬ ИсполнителиЗадачи
		|ИЗ
		|	ЧасыПоЗадаче КАК ЧасыПоЗадаче
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО ЧасыПоЗадаче.Пользователь = Пользователи.Наименование
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиИсполнителей КАК РолиИсполнителей
		|		ПО ЧасыПоЗадаче.Роль = РолиИсполнителей.Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсполнителиЗадачи.Исполнитель КАК Исполнитель,
		|	ИсполнителиЗадачи.ИсполнительСтрокой КАК ИсполнительСтрокой,
		|	ИсполнителиЗадачи.Затрачено КАК Затрачено,
		|	0 КАК Оценка,
		|	0 КАК КоличествоСверхОценки,
		|	0 КАК ПроцентСверхОценки,
		|	ЛОЖЬ КАК ЕстьПревышение,
		|	ИсполнителиЗадачи.Команда КАК Команда,
		|	ИсполнителиЗадачи.РольИсполнителя КАК РольИсполнителя,
		|	"""" КАК Комментарий,
		|	ОценкаТрудозатратПоЗадачам.Количество КАК ОценкаТрудозатрат,
		|	0 КАК СогласованнаяОценка
		|ИЗ
		|	ИсполнителиЗадачи КАК ИсполнителиЗадачи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОценкаТрудозатратПоЗадачам КАК ОценкаТрудозатратПоЗадачам
		|		ПО ИсполнителиЗадачи.РольИсполнителя = ОценкаТрудозатратПоЗадачам.РольИсполнителяЗадачи
		|			И (ОценкаТрудозатратПоЗадачам.ЗадачаМетеор = &ЗадачаМетеор)
		|ИТОГИ
		|	СУММА(Затрачено),
		|	МАКСИМУМ(ОценкаТрудозатрат) КАК Оценка,
		|	СУММА(Затрачено) - МАКСИМУМ(Оценка) КАК КоличествоСверхОценки,
		|	ВЫБОР
		|		КОГДА МАКСИМУМ(ОценкаТрудозатрат) > 0
		|			ТОГДА (СУММА(Затрачено) - МАКСИМУМ(ОценкаТрудозатрат)) / МАКСИМУМ(ОценкаТрудозатрат) * 100
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПроцентСверхОценки
		|ПО
		|	РольИсполнителя";
	
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам), "ОценкаПоИсполнителям");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОценкуПоИсполнителямПослеПодтверждения(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьИсполнителейДляОценки();
		СтандартныеПодсистемыКлиент.РазвернутьУзлыДерева(ЭтаФорма, "ОценкаПоИсполнителям",, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция КомандаИсполнителя(Исполнитель)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Исполнитель, "Команда");
КонецФункции

&НаКлиенте
Функция ЭлементыРедактируемыеВДетальныхЗаписях()
	
	Результат = Новый Массив;
	Результат.Добавить(Элементы.ОценкаПоИсполнителямИсполнительЗадачи);
	Результат.Добавить(Элементы.ОценкаПоИсполнителямСогласованнаяОценка);
	Результат.Добавить(Элементы.ОценкаПоИсполнителямКомментарий);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОчиститьОценкуПоИсполнителямНаСервере()
	Оценка = РеквизитФормыВЗначение("ОценкаПоИсполнителям");
	Оценка.Строки.Очистить();
	ЗначениеВРеквизитФормы(Оценка, "ОценкаПоИсполнителям");
КонецПроцедуры

&НаКлиенте
Процедура ОценкаПоИсполнителямПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Истина
			И Не Элементы.ОценкаПоИсполнителям.ТекущиеДанные = Неопределено
			И Не Элементы.ОценкаПоИсполнителям.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда

		Отказ = Истина;
		Элементы.ОценкаПоИсполнителям.ТекущаяСтрока = Элементы.ОценкаПоИсполнителям.ТекущиеДанные.ПолучитьРодителя().ПолучитьИдентификатор();
		Элементы.ОценкаПоИсполнителям.ДобавитьСтроку();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОценкаПоИсполнителямПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Истина
			И НоваяСтрока
			И Не Элементы.ОценкаПоИсполнителям.ТекущиеДанные = Неопределено
			И Не Элементы.ОценкаПоИсполнителям.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		Элементы.ОценкаПоИсполнителям.ТекущиеДанные.РольИсполнителя = Элементы.ОценкаПоИсполнителям.ТекущиеДанные.ПолучитьРодителя().РольИсполнителя;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

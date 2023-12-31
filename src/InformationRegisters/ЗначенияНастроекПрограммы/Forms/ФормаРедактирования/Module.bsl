
//+++ АК MOSD 2019.01.24 ИП-00019570.01 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьДеревоНастроек();
КонецПроцедуры

//+++ АК MOSD 2019.06.03 ЗА-00019760 
&НаСервере
Процедура ЗаполнитьДеревоНастроек()
	
	Дерево = РеквизитФормыВЗначение("ДеревоНастроек");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиПрограммы.Ссылка КАК Настройка,
		|	ЗначенияНастроекПрограммы.Значение,
		|	НастройкиПрограммы.Родитель,
		|	НастройкиПрограммы.ЭтоГруппа,
		|	НастройкиПрограммы.ИспользуетсяСписокЗначений,
		|	ВЫБОР
		|		КОГДА НастройкиПрограммы.ЭтоГруппа
		|			ТОГДА 0
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК ИндексКартинки
		|ИЗ
		|	ПланВидовХарактеристик.НастройкиПрограммы КАК НастройкиПрограммы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияНастроекПрограммы КАК ЗначенияНастроекПрограммы
		|		ПО (ЗначенияНастроекПрограммы.Настройка = НастройкиПрограммы.Ссылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НастройкиПрограммы.ЭтоГруппа УБЫВ,
		|	НастройкиПрограммы.Наименование
		|ИТОГИ ПО
		|	Настройка ИЕРАРХИЯ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаГруппы = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаГруппы.Следующий() Цикл
		
		Если ВыборкаГруппы.Родитель.Пустая() Тогда
			СтрокаГруппы = Дерево;			
		Иначе
			СтрокаГруппы = Дерево.Строки.Найти(ВыборкаГруппы.Родитель, "Настройка", Истина);
		КонецЕсли;
		
		НашлиЗначение = Дерево.Строки.Найти(ВыборкаГруппы.Настройка, "Настройка", Истина);
		Если НашлиЗначение <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаНастройки = СтрокаГруппы.Строки.Добавить();
		СтрокаНастройки.Настройка       = ВыборкаГруппы.Настройка;
		СтрокаНастройки.ЭтоГруппа       = ВыборкаГруппы.ЭтоГруппа;
		СтрокаНастройки.ИндексКартинки  = ВыборкаГруппы.ИндексКартинки;
		
		Если ВыборкаГруппы.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
		
		СписококЗначенийНастройки = Новый СписокЗначений;
		СписококЗначенийНастройки.ТипЗначения = ВыборкаГруппы.Настройка.ТипЗначения;
		
		СтрокаНастройки.ИспользуетсяСписокЗначений = ВыборкаГруппы.ИспользуетсяСписокЗначений;
		
		ВыборкаЗначенияНастройки = ВыборкаГруппы.Выбрать();
		Пока ВыборкаЗначенияНастройки.Следующий() Цикл
			
			СписококЗначенийНастройки.Добавить(ВыборкаЗначенияНастройки.Настройка.ТипЗначения.ПривестиЗначение(ВыборкаЗначенияНастройки.Значение));

		КонецЦикла;
		
		Если СтрокаНастройки.ИспользуетсяСписокЗначений Тогда
			СтрокаНастройки.Значение = СписококЗначенийНастройки;
		ИначеЕсли СписококЗначенийНастройки.Количество() > 0 Тогда
			СтрокаНастройки.Значение = СписококЗначенийНастройки[0].Значение;
		КонецЕсли;			
			
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоНастроек");
	
КонецПроцедуры

//+++ АК MOSD 2019.01.24 ИП-00019570.01
&НаСервере
Процедура СохранитьЗначенияНастроек()
	
	Дерево = РеквизитФормыВЗначение("ДеревоНастроек");
	
	Набор = РегистрыСведений.ЗначенияНастроекПрограммы.СоздатьНаборЗаписей();
	ЗаполнитьНаборЗаписей(Дерево.Строки, Набор);
	Набор.Записать();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

//+++ АК MOSD 2019.06.03 ЗА-00019760  
&НаСервере
Процедура ЗаполнитьНаборЗаписей(СтрокиДерева, НаборЗаписей)
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		Если НЕ СтрокаДерева.ЭтоГруппа Тогда
			Если СтрокаДерева.ИспользуетсяСписокЗначений Тогда
				Для Каждого ТекЗначение Из СтрокаДерева.Значение Цикл
					Запись = НаборЗаписей.Добавить();    
					Запись.НомерЗначения = СтрокаДерева.Значение.Индекс(ТекЗначение);
					Запись.Настройка = СтрокаДерева.Настройка;
					Запись.Значение  = СтрокаДерева.Настройка.ТипЗначения.ПривестиЗначение(ТекЗначение.Значение);
				КонецЦикла; 
			Иначе
				Запись = НаборЗаписей.Добавить();    
				Запись.НомерЗначения = 0;
				Запись.Настройка = СтрокаДерева.Настройка;
				Запись.Значение  = СтрокаДерева.Настройка.ТипЗначения.ПривестиЗначение(СтрокаДерева.Значение);
			КонецЕсли;
		Иначе
			ЗаполнитьНаборЗаписей(СтрокаДерева.Строки, НаборЗаписей);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
	
//+++ АК MOSD 2019.01.24 ИП-00019570.01
&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если Модифицированность Тогда
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияВопроса",ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения, "Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
КонецПроцедуры

//+++ АК MOSD 2019.01.24 ИП-00019570.01
&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		СохранитьЗначенияНастроек();
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

//+++ АК MOSD 2019.01.24 ИП-00019570.01
&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	СохранитьЗначенияНастроек();
	Закрыть();
КонецПроцедуры

//+++ АК MOSD 2019.01.24 ИП-00019570.01
&НаКлиенте
Процедура КомандаСохранить(Команда)
	СохранитьЗначенияНастроек();
КонецПроцедуры

//+++ АК MOSD 2019.06.03 ЗА-00019760 
&НаКлиенте
Процедура ДеревоНастроекПриАктивизацииЯчейки(Элемент)
	
	ТекДанные = Элемент.ТекущиеДанные;
	
	ЗначениеРеквизитовОбъекта = ЗначенияРеквизитовОбъекта(ТекДанные.Настройка, "ТипЗначения, ЭтоГруппа, ИспользуетсяСписокЗначений");
	
	Если ЗначениеРеквизитовОбъекта.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент.Имя = "ДеревоНастроекЗначениеНастройки" И ТекДанные <> Неопределено Тогда
		Если ТекДанные.ИспользуетсяСписокЗначений Тогда
			Элемент.ТекущийЭлемент.ОграничениеТипа = Новый ОписаниеТипов("СписокЗначений");
		Иначе
			Элемент.ТекущийЭлемент.ОграничениеТипа = ЗначениеРеквизитовОбъекта.ТипЗначения;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНастроекЗначениеНастройкиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ТекДанные = Элементы.ДеревоНастроек.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНастроекЗначениеНастройкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Элемент.Родитель.ТекущиеДанные.Значение = ВыбранноеЗначение;
	
КонецПроцедуры

&НаСервере
Функция ЗначенияРеквизитовОбъекта(Ссылка, Свойства)
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, Свойства);
КонецФункции
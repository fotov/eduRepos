
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьОценкуПроизводительности = Метаданные.ОбщиеМодули.Найти("ОценкаПроизводительности") <> Неопределено;

	Если ИспользоватьОценкуПроизводительности Тогда
		Замер = ОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	ДопустимыеТипыДополнений = Новый Массив;
	ДопустимыеТипыДополнений.Добавить(РаботаСДополнениямиИнтеграция.ТипДополненияДопОтчетОбработка());
	ДопустимыеТипыДополнений.Добавить(РаботаСДополнениямиИнтеграция.ТипДополненияРасширение());
	
	Если Параметры.ТипДополнения = "" Или ДопустимыеТипыДополнений.Найти(Параметры.ТипДополнения) = Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю("Не выбран тип дополнения.",,,, Отказ);
		Возврат;
	КонецЕсли;
	
	Элементы.СтраницаДополнения.Видимость = Истина;
	Элементы.СтраницаВерсияДополнения.Видимость = Ложь;
	
	ИдентификаторБазы = Константы.ИдентификаторКлиентаДополнений.Получить();
	
	СписокДополнений = РаботаСДополнениямиИнтеграция.ПолучитьДополнения(Параметры.ТипДополнения, ИдентификаторБазы);
	РаботаСДополнениямиИнтеграция.ПрочитатьМассивСтруктурВКоллекцию(Дополнения, СписокДополнений);
	
	Если ИспользоватьОценкуПроизводительности Тогда
		КлючеваяОперация = "ОбработкаРаботаСДополнениямиИнтеграцияФормаПолученияДополненияОткрытиеФормы";
		ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, Замер);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ДополненияВерсииДополнений

&НаКлиенте
Процедура ДополненияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Дополнения.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ВыбранныйГУИД = Элементы.Дополнения.ТекущиеДанные.УникальныйИдентификатор;
	ВыборДополненияНаСервере(ВыбранныйГУИД);
	
КонецПроцедуры

&НаКлиенте
Процедура ВерсииДополненийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ВерсииДополнений.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ВерсияГУИД = Элементы.ВерсииДополнений.ТекущиеДанные.УникальныйИдентификатор;
	
	АдресДанныхВерсииДополнения = ПолучитьДвоичныеДанныеВерсииДополнения(ВерсияГУИД);
	ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Элементы.ВерсииДополнений.ТекущиеДанные.ИмяФайла, АдресДанныхВерсииДополнения);
	ОповеститьОВыборе(ОписаниеФайла);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыборДополненияНаСервере(ВыбранноеДополнениеГУИД)
	
	СписокВерсий = РаботаСДополнениямиИнтеграция.ПолучитьВерсии(ВыбранноеДополнениеГУИД);
	РаботаСДополнениямиИнтеграция.ПрочитатьМассивСтруктурВКоллекцию(ВерсииДополнений, СписокВерсий);
	ВерсииДополнений.Сортировать("ДатаСоздания УБЫВ");
	
	Элементы.СтраницаДополнения.Видимость = Ложь;
	Элементы.СтраницаВерсияДополнения.Видимость = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДвоичныеДанныеВерсииДополнения(ВерсияГУИД)
	ДанныеДополнения = РаботаСДополнениямиИнтеграция.ПолучитьДвоичныеДанныеВерсииДополнения(ВерсияГУИД);
	АдресХранилища = ПоместитьВоВременноеХранилище(ДанныеДополнения, Новый УникальныйИдентификатор);
	Возврат АдресХранилища;
КонецФункции

#КонецОбласти













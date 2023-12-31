#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура НастроитьЭлементыФормыКонфликтыИзменений(ДинамическийСписок, Группа, ЗадачаМетеор, Коммит = Неопределено) Экспорт
	ДинамическийСписок.ТекстЗапроса = РаботаСХранилищами.ТекстЗапросаКонфликтыИзмененийОбъектов();
	ДинамическийСписок.Параметры.Элементы.Найти("ЗадачаМетеор").Использование = Истина;
	ДинамическийСписок.Параметры.Элементы.Найти("ЗадачаМетеор").Значение = ЗадачаМетеор;
	ДинамическийСписок.Параметры.Элементы.Найти("Коммит").Использование = Истина;
	ДинамическийСписок.Параметры.Элементы.Найти("Коммит").Значение = Коммит;
	КоличествоКонфликтовИзмененийОбъектов = РаботаСХранилищами.КоличествоКонфликтовИзмененийОбъектов(ЗадачаМетеор, Коммит);
	Группа.Видимость = КоличествоКонфликтовИзмененийОбъектов > 0;
	Группа.Заголовок = СтрШаблон("Конфликты изменений (%1)", КоличествоКонфликтовИзмененийОбъектов);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

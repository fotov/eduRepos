
&НаСервере
Процедура ЗагрузитьНаСервере()
	КонтрольЗаписиРабочихДанных.ЗагрузкаИсторииЗаписиРабочихДанныхОбработчикЗадания();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	ЗагрузитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодписатьсяНаСервере()
	КонтрольЗаписиРабочихДанных.Подписаться();
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	ПодписатьсяНаСервере();
КонецПроцедуры

#Область ОбработчикиСобытийФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОчиститьУстаревшиеДанные(Команда)
	ОчиститьУстаревшиеДанныеНаСервере();
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОчиститьУстаревшиеДанныеНаСервере()
	РегистрыСведений.СобытияМетеор.ОчиститьУстаревшиеДанные();
КонецПроцедуры

#КонецОбласти


&НаСервере
Процедура ОчисткаУстаревшихДанныхНаСервере()
	РегистрыСведений.СтатистикаМониторинга.ОчисткаУстаревшихДанных();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ОчисткаУстаревшихДанных(Команда)
	ОчисткаУстаревшихДанныхНаСервере();
КонецПроцедуры

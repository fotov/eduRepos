
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ЗагрузитьПроизводственныйКалендарь();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПроизводственныйКалендарь()

	РегистрыСведений.ПроизводственныйКалендарь.ЗагрузитьПроизводственныйКалендарь(Год(ТекущаяДата()));
	РегистрыСведений.ПроизводственныйКалендарь.ЗагрузитьПроизводственныйКалендарь(Год(ТекущаяДата()) + 1);

КонецПроцедуры

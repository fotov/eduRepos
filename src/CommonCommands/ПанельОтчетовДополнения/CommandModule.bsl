///////////////////////////////////////////////////////////////////////////////////////////////////////
// Подключение подсистемы ВариантыОтыетов к подсистеме
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполнения)
	ВариантыОтчетовКлиент.ПоказатьПанельОтчетов("Дополнения", ПараметрыВыполнения);
КонецПроцедуры

#КонецОбласти

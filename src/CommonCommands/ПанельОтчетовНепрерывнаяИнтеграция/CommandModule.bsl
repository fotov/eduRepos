///////////////////////////////////////////////////////////////////////////////////////////////////////
// Подключение подсистемы ВариантыОтыетов к подсистеме
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполнения)
	ВариантыОтчетовКлиент.ПоказатьПанельОтчетов("НепрерывнаяИнтеграция", ПараметрыВыполнения);
КонецПроцедуры

#КонецОбласти

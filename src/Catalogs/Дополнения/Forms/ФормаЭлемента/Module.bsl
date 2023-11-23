
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НастроитьФорму(ЭтаФорма)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипДополненияПриИзменении(Элемент)
	НастроитьФорму(ЭтаФорма)
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьФорму(Форма)
	Форма.Элементы.ТипРасширения.Видимость = Форма.Объект.ТипДополнения = ПредопределенноеЗначение("Перечисление.ТипыДополнений.Расширение");
КонецПроцедуры

#КонецОбласти
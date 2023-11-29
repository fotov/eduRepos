#Область СлужебныйПрограммныйИнтерфейс
Процедура ИсполняемыеСценарии() Экспорт

ЮТТесты.ВТранзакции().УдалениеТестовыхДанных()
	.ДобавитьТест("ИмяСоответствуетШаблону")
;


КонецПроцедуры
#КонецОбласти
#Область СлужебныеПроцедурыИФункции
Процедура ИмяСоответствуетШаблону() Экспорт

ПараметрыЗаписи = ЮТОбщий.ПараметрыЗаписи();
ПараметрыЗаписи.ОбменДаннымиЗагрузка = Истина;
ЮТест.Данные().СоздатьЭлемент(Справочники.Пользователи, "vlegus", Новый Структура("Код", "vlegus"), ПараметрыЗаписи);
Конфигурация = ЮТест.Данные().СоздатьЭлемент(Справочники.Конфигурации, "fin", Новый Структура("Идентификатор", "fin"), ПараметрыЗаписи);

ЮТест.ОжидаетЧто(Справочники.ВерсииДополнений.ИмяСоответствуетШаблону("Исправление_fin_vlegus_ГЕО_До20231130_ВВ2549925639_v1003_1.0.0.3"))
	.ИмеетТип("Структура")
	.Свойство("ИмяСоответствуетШаблону").Равно(Истина)
	.Свойство("Комментарий").Равно("")
;

ЮТест.ОжидаетЧто(Справочники.ВерсииДополнений.ИмяСоответствуетШаблону("Исправление_fin_vlegus_ГЕО_До20231130_ВВ2549925639_v1003_1Исправление_fin_vlegus_ГЕО_До20231130_ВВ2549925639_v1003_1.0.0.3"))
	.ИмеетТип("Структура")
	.Свойство("ИмяСоответствуетШаблону").Равно(Ложь)
	.Свойство("Комментарий").Содержит("80")
;


КонецПроцедуры
#КонецОбласти
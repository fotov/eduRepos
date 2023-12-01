#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
    
    ЮТТесты
        .ДобавитьТест("Сложение")
            .СПараметрами(2, 3,     5)
            .СПараметрами(2, -3,    -1)
        .ДобавитьТест("ПроверкаСправочникаТест")
            .СПараметрами("", "Класс")      
    ;

КонецПроцедуры

Процедура Сложение(ПервыйОперанд, ВторойОперанд, Результат) Экспорт

    ЮТест.ОжидаетЧто(ПервыйОперанд + ВторойОперанд)
            .ИмеетТип("Число")
        .Равно(Результат);

КонецПроцедуры

Процедура ПроверкаСправочникаТест(Наименование, Класс) Экспорт

    ЮТест.ОжидаетЧто(Справочники.Тесты.Тест(Наименование, Класс))
        .Равно(Справочники.Тесты.ПустаяСсылка());

КонецПроцедуры

#КонецОбласти
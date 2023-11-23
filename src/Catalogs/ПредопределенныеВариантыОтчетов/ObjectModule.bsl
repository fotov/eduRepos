///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ПроверитьЗаполнениеПредопределенного(Отказ);
	КонецЕсли;
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если Не ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ВызватьИсключение НСтр("ru = 'Запись в справочник ""Предопределенные варианты отчетов"" запрещена. Его данные заполняются автоматически.'");
	КонецЕсли;
КонецПроцедуры

// Базовые проверки корректности данных предопределенных вариантов отчетов.
Процедура ПроверитьЗаполнениеПредопределенного(Отказ)
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(Отчет) Тогда
		Возврат;
	КонецЕсли;
		
	ВызватьИсключение НСтр("ru = 'Не заполнено поле ""Отчет""'");
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
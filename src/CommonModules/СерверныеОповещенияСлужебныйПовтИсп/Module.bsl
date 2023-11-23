///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//  Булево
//
Функция ЭтоСеансОтправкиСерверныхОповещенийКлиентам() Экспорт
	
	Если ТекущийРежимЗапуска() <> Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекущееФоновоеЗадание = ПолучитьТекущийСеансИнформационнойБазы().ПолучитьФоновоеЗадание();
	Если ТекущееФоновоеЗадание = Неопределено
	 Или ТекущееФоновоеЗадание.ИмяМетода
	     <> Метаданные.РегламентныеЗадания.ОтправкаСерверныхОповещенийКлиентам.ИмяМетода Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Возвращает сведения последней проверке подключения системы взаимодействия.
//
// Возвращаемое значение:
//  Структура:
//   * Дата - Дата
//   * Подключена - Булево
//
Функция ПоследняяПроверкаПодключенияСистемыВзаимодействий() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Дата", '00010101');
	Результат.Вставить("Подключена", Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

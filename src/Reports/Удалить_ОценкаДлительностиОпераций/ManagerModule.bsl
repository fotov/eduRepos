
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область СтандартныеПодсистемы_ВариантыОтчетов

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для передачи в параметрах вспомогательных методов (см. ниже).
//       Соответствует 1 параметру процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки этого отчета,
//       уже сформированные при помощи функции ВариантыОтчетов.ОписаниеОтчета() и готовые к изменению.
//       См. "Свойства для изменения" процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//    НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//    ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь);
//
// Примеры:
//
//  1. Установка описания варианта.
//    НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//    НастройкиВарианта.Описание = НСтр("ru = '<Описание>'");
//
//  2. Отключение варианта отчета.
//    НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//    НастройкиВарианта.Включен = Ложь;
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.Размещение.Вставить(Метаданные.Подсистемы.Администрирование.Подсистемы.Мониторинг);
	НастройкиОтчета.Включен = Истина;
	НастройкиОтчета.ВидимостьПоУмолчанию = Истина;
	НастройкиОтчета.Описание = "Для оценки длительности операций, подключенных к мониторингу.";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
#КонецЕсли
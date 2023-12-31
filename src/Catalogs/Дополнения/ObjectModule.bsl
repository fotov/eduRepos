
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	Если Не ТипДополнения = Перечисления.ТипыДополнений.Расширение Тогда
		НепроверяемыеРеквизиты.Добавить("ТипРасширения");
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ПустаяСтрока(ИмяФайлаБезРасширенияДляВыгрузки) Тогда
		ИмяФайлаБезРасширенияДляВыгрузки = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(Наименование);
		// При выгрузке в файлы точка в конце имени вызывает ошибку.
		Если СтрЗаканчиваетсяНа(ИмяФайлаБезРасширенияДляВыгрузки, ".") Тогда
			ИмяФайлаБезРасширенияДляВыгрузки = Лев(ИмяФайлаБезРасширенияДляВыгрузки, СтрДлина(ИмяФайлаБезРасширенияДляВыгрузки) - 1);
		КонецЕсли;
		ИмяФайлаБезРасширенияДляВыгрузки = СокрЛП(ИмяФайлаБезРасширенияДляВыгрузки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти

#Иначе
  ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли

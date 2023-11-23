#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
// Возвращаемое значение:
//  НеРедактируемыеРеквизиты - Массив - массив имен реквизитов, не подлежащих редактированию.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	
	НеРедактируемыеРеквизиты.Добавить("ПолныйКод");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

Функция СформироватьПечатныеФормы(МассивОбъектов, СУчетомПриемника=Неопределено, ДанныеСоответствия=Неопределено) Экспорт
	
	ПечатныеФормы = Новый Соответствие;
		
	Возврат ПечатныеФормы;
	
КонецФункции

// Выполняет печать описаний и схем переданных функций
//
// Параметры:
//  МассивОбъектов - массив функций, подлежащих печати
//
Процедура Печать(МассивОбъектов, ПечатныеФормы) Экспорт
	
	ПечатныеФормы = СформироватьПечатныеФормы(МассивОбъектов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
#КонецОбласти

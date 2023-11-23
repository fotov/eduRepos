///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции
	
// Возвращаемое значение:
//  Структура:
//   * Действие - Строка
//   * ПереноситьВТом - Булево
//   * ТомХраненияПриемник - СправочникСсылка.ТомаХраненияФайлов
// 
Функция ПараметрыПереносаФайлов() Экспорт
	Результат = Новый Структура("Действие,ПереноситьВТом,ТомХраненияПриемник");
	Возврат Результат;
КонецФункции

// Параметры:
//  ФайлыДляПереноса - ТаблицаЗначений
//  Параметры - см. ПараметрыПереносаФайлов
// 
// Возвращаемое значение:
//  Структура:
//    * ПеренесеноФайлов - Число
//    * ОшибкиПереноса - Массив из см. ОшибкаПереноса
//
Функция ВыполнитьПереносФайлов(ФайлыДляПереноса, Параметры) Экспорт

	ОшибкиПереноса = Новый Массив;
	
	Если Параметры.Действие = "ПеренестиМеждуТомами" Тогда
		ДействиеДляЖурнала = НСтр("ru = 'между томами на диске.'");
	ИначеЕсли Параметры.Действие = "ПеренестиВТома" Тогда
		ДействиеДляЖурнала = НСтр("ru = 'в тома на диске.'")
	Иначе
		ДействиеДляЖурнала = НСтр("ru = 'в информационную базу.'")
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Файлы.Начало переноса файлов.'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,,,
		НСтр("ru = 'Начат перенос файлов'") + " " + ДействиеДляЖурнала);
	
	ФайловКПереносу = ФайлыДляПереноса.Количество();
	
	СвойстваТома = Новый Структура("ПутьКТому, МаксимальныйОбъемТома");
	СвойстваТома.Вставить("ТекущийОбъемТома", 0);
	Если Параметры.ПереноситьВТом Тогда
		СвойстваТома.ПутьКТому = РаботаСФайламиВТомахСлужебный.ПолныйПутьТома(Параметры.ТомХраненияПриемник);
		СвойстваТома.ТекущийОбъемТома = РаботаСФайламиВТомахСлужебный.ОбъемТома(Параметры.ТомХраненияПриемник);
		СвойстваТома.МаксимальныйОбъемТома = 1024*1024 * ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Параметры.ТомХраненияПриемник, "МаксимальныйРазмер");
	КонецЕсли;
	
	ПеренесеноФайлов = 0;
	Для Каждого Файл Из ФайлыДляПереноса Цикл
		ПеренестиФайл(Файл, СвойстваТома, Параметры, ОшибкиПереноса, ПеренесеноФайлов);
	КонецЦикла;
	
	ТекстЗаписиОЗавершении = НСтр("ru = 'Завершен перенос файлов %1
		|Перенесено файлов: %2'");
	
	ТекстЗаписиОЗавершении = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстЗаписиОЗавершении, ДействиеДляЖурнала, Формат(ПеренесеноФайлов, "ЧН=0; ЧГ="));
	
	Если ПеренесеноФайлов < ФайловКПереносу Тогда
		ТекстЗаписиОЗавершении = ТекстЗаписиОЗавершении + "
			|" + НСтр("ru = 'Количество ошибок при переносе: %1'");
		ТекстЗаписиОЗавершении = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстЗаписиОЗавершении, Формат(ФайловКПереносу - ПеренесеноФайлов, "ЧН=0; ЧГ="));
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Файлы.Завершение переноса файлов.'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,,, ТекстЗаписиОЗавершении);
	
	Возврат Новый Структура("ПеренесеноФайлов,ОшибкиПереноса", ПеренесеноФайлов, ОшибкиПереноса);
	
КонецФункции	

// Параметры:
//   Файл             - СправочникОбъект
//   СвойстваТома     - Структура
//   Параметры        - см. ПараметрыПереносаФайлов
//   ОшибкиПереноса   - Массив из см. ОшибкаПереноса
//   ПеренесеноФайлов - Число
//
Процедура ПеренестиФайл(Файл, СвойстваТома, Параметры, ОшибкиПереноса, ПеренесеноФайлов)
	
	ФайлСсылка = Файл.Ссылка;
	СвойстваФайла = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ФайлСсылка, "Наименование, Расширение, Размер");
	
	НачатьТранзакцию();
	Попытка

		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = Блокировка.Добавить(ФайлСсылка.Метаданные().ПолноеИмя());
		ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", ФайлСсылка);
		Блокировка.Заблокировать();
		
		ФайлОбъект = ФайлСсылка.ПолучитьОбъект();

		ВыброситьИсключениеПриПревышенииРазмераТома(СвойстваТома, ФайлОбъект, Параметры);
		
		Если Параметры.Действие = "ПеренестиМеждуТомами" Тогда
			ПеренестиМеждуТомами(ФайлОбъект, СвойстваТома, Параметры);
		ИначеЕсли Параметры.Действие = "ПеренестиВТома" Тогда
			ПеренестиВТома(ФайлОбъект, СвойстваТома, Параметры);
		ИначеЕсли Параметры.Действие = "ПеренестиВБазу" Тогда
			ПеренестиВБазу(ФайлОбъект, СвойстваТома, Параметры);
		Иначе
			ВызватьИсключение НСтр("ru='Неподдерживаемая операция.'");
		КонецЕсли;
		
		ПеренесеноФайлов = ПеренесеноФайлов + 1;
		СвойстваТома.ТекущийОбъемТома = СвойстваТома.ТекущийОбъемТома + СвойстваФайла.Размер;
		
		ЗафиксироватьТранзакцию();

	Исключение
	
		ОтменитьТранзакцию();
		Ошибка = ОшибкаПереноса(ФайлСсылка, ИнформацияОбОшибке());
		
		ИмяДляЖурнала = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
							СвойстваФайла.Наименование,
							СвойстваФайла.Расширение);

		Ошибка.ИмяФайла = ИмяДляЖурнала;
		ОшибкиПереноса.Добавить(Ошибка);
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Файлы.Ошибка переноса файла.'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,, ФайлСсылка,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При переносе в том файла
				|""%1""
				|возникла ошибка:
				|""%2"".'"),
				ИмяДляЖурнала,
				Ошибка.ПодробноеПредставлениеОшибки));

	КонецПопытки;
	
КонецПроцедуры

Процедура ПеренестиМеждуТомами(ФайлОбъект, СвойстваТома, Параметры)
	СвойстваФайла = РаботаСФайламиВТомахСлужебный.СвойстваФайлаВТоме();
	ЗаполнитьЗначенияСвойств(СвойстваФайла, ФайлОбъект);
	Если ТипЗнч(ФайлОбъект) = Тип("СправочникОбъект.ВерсииФайлов") Тогда
		СвойстваФайла.ВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		ФайлОбъект.Владелец, "ВладелецФайла");
	КонецЕсли;
	
	ТекущийПутьКФайлу = РаботаСФайламиВТомахСлужебный.ПолноеИмяФайлаВТоме(СвойстваФайла);
	
	ФайлНаДиске = Новый Файл(ТекущийПутьКФайлу);
	Если Не ФайлНаДиске.Существует() Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Файл ""%1"" не найден.'"), ТекущийПутьКФайлу);
	КонецЕсли;
	
	СвойстваФайла.Том = Параметры.ТомХраненияПриемник;
	СвойстваФайла.ПутьКФайлу = "";
	
	НовыйПутьКФайлу = РаботаСФайламиВТомахСлужебный.ПолноеИмяФайлаВТоме(СвойстваФайла, ФайлОбъект.ДатаМодификацииУниверсальная);
	КопироватьФайл(ТекущийПутьКФайлу, НовыйПутьКФайлу);
	
	ФайлОбъект.Том = Параметры.ТомХраненияПриемник;
	ФайлОбъект.ПутьКФайлу = Сред(НовыйПутьКФайлу, СтрДлина(СвойстваТома.ПутьКТому) + 1);
	ФайлОбъект.Записать();
	
	РаботаСФайламиВТомахСлужебный.УдалитьФайл(ТекущийПутьКФайлу);
КонецПроцедуры

Процедура ПеренестиВТома(ФайлОбъект, СвойстваТома, Параметры)
	ДанныеФайла = РаботаСФайлами.ДвоичныеДанныеФайла(ФайлОбъект.Ссылка);
	ФайлОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
	РаботаСФайламиВТомахСлужебный.ДобавитьФайл(ФайлОбъект, ДанныеФайла,
		ФайлОбъект.ДатаМодификацииУниверсальная, , ?(Параметры.ПереноситьВТом, Параметры.ТомХраненияПриемник, Неопределено));
		
	Если ФайлОбъект.ТипХраненияФайла <> Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
		РаботаСФайламиСлужебный.УдалитьЗаписьИзРегистраДвоичныеДанныеФайлов(ФайлОбъект.Ссылка);	
	КонецЕсли;
	
	ФайлОбъект.Записать();
КонецПроцедуры

Процедура ПеренестиВБазу(ФайлОбъект, СвойстваТома, Параметры)
	ДанныеФайла = РаботаСФайламиВТомахСлужебный.ДанныеФайла(ФайлОбъект.Ссылка);
	РаботаСФайламиСлужебный.ЗаписатьФайлВИнформационнуюБазу(ФайлОбъект.Ссылка, ДанныеФайла);
	
	ПутьКФайлу = РаботаСФайламиВТомахСлужебный.ПолноеИмяФайлаВТоме(
					Новый Структура("Том, ПутьКФайлу", ФайлОбъект.Том, ФайлОбъект.ПутьКФайлу));
	
	ФайлОбъект.Том = Неопределено;
	ФайлОбъект.ПутьКФайлу = "";
	ФайлОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе;
	ФайлОбъект.Записать();
	РаботаСФайламиВТомахСлужебный.УдалитьФайл(ПутьКФайлу);
КонецПроцедуры

// Параметры:
//  ФайлСсылка - ОпределяемыйТип.ПрисоединенныйФайл
//  ИнформацияОбОшибке - ИнформацияОбОшибке
// 
// Возвращаемое значение:
//  Структура:
//   * ИмяФайла - Строка
//   * Ошибка - Строка
//   * ПодробноеПредставлениеОшибки - Строка
//   * Версия - ОпределяемыйТип.ПрисоединенныйФайл
//
Функция ОшибкаПереноса(ФайлСсылка, ИнформацияОбОшибке)

	ОписаниеОшибки = Новый Структура;
	ОписаниеОшибки.Вставить("ИмяФайла","");
	ОписаниеОшибки.Вставить("Ошибка", "");
	ОписаниеОшибки.Вставить("ПодробноеПредставлениеОшибки", "");
	ОписаниеОшибки.Вставить("Версия", ФайлСсылка);
	ОписаниеОшибки.Ошибка = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	ОписаниеОшибки.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	Возврат ОписаниеОшибки;

КонецФункции

Процедура ВыброситьИсключениеПриПревышенииРазмераТома(Знач СвойстваТома, Знач ФайлОбъект, Знач Параметры)
	
	Если Параметры.ПереноситьВТом
		И СвойстваТома.МаксимальныйОбъемТома > 0
		И СвойстваТома.ТекущийОбъемТома + ФайлОбъект.Размер > СвойстваТома.МаксимальныйОбъемТома Тогда
		
		ВызватьИсключение НСтр("ru = 'Превышен максимальный размер тома.'");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
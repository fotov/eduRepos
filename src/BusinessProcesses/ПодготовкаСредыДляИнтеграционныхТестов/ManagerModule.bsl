#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ЗадачаВыполнима(Задача, ТочкаМаршрута) Экспорт
	
	Если ТочкаМаршрута = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ТочкиМаршрута.Инициализация Тогда
		ЗадачаВыполнима = Инициализация(Задача.БизнесПроцесс);
		
	ИначеЕсли ТочкаМаршрута = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ТочкиМаршрута.ПолучениеФайловКонфигураций Тогда
		ЗадачаВыполнима = ПолучениеФайловКонфигураций(Задача.БизнесПроцесс);
		
	ИначеЕсли ТочкаМаршрута = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ТочкиМаршрута.ЗапускПайплайна Тогда
		ЗадачаВыполнима = ЗапускПайплайна(Задача.БизнесПроцесс);
		
	ИначеЕсли ТочкаМаршрута = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ТочкиМаршрута.ОжиданиеЗавершенияПайплайна Тогда
		ЗадачаВыполнима = КонвейерЗавершен(Задача.БизнесПроцесс);
		
	ИначеЕсли ТочкаМаршрута = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ТочкиМаршрута.СборРезультатаПайплайна Тогда
		ЗадачаВыполнима = СборРезультатаПайплайна(Задача.БизнесПроцесс);
		
	ИначеЕсли ТочкаМаршрута = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ТочкиМаршрута.ОповеститьОРезультатеПайплайна Тогда
		ЗадачаВыполнима = Истина;
		
	Иначе
		ЗадачаВыполнима = Истина;
		
	КонецЕсли;
	
	Возврат ЗадачаВыполнима;
	
КонецФункции

Функция МожноАвтозавершитьЗадачу(Задача, ТочкаМаршрута) Экспорт
	
	Можно = Ложь;
	
	Если ТочкаМаршрута = БизнесПроцессы.КонвейерОбработки.ТочкиМаршрута.ПодготовкаТестовыхБаз Тогда
	КонецЕсли;
	
	Возврат Можно;
	
КонецФункции

Процедура ПриАвтозавершении(Задача, ТочкаМаршрута) Экспорт
КонецПроцедуры

// Процедура - Перезапуск подготовки тестовых баз
// Выполняется утром после восстановления ночных баз. После этой операции лучше обновить наши клоны предпрод
Процедура ПерезапускПодготовкиТестовыхБаз() Экспорт
КонецПроцедуры

// Процедура - Запуск интеграционных тестов
// Проверяет надо ли запустить БП подгтоовки тестовых сред, если надо, то запускает
Процедура РегламентЗапускИнтеграционныхТестов() Экспорт
	
	// 0. Если уже 19:00, но за сегодня не было еще БП (c 17:00)
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодготовкаСредыДляИнтеграционныхТестов.Ссылка КАК Ссылка
		|ИЗ
		|	БизнесПроцесс.ПодготовкаСредыДляИнтеграционныхТестов КАК ПодготовкаСредыДляИнтеграционныхТестов
		|ГДЕ
		|	ПодготовкаСредыДляИнтеграционныхТестов.ПометкаУдаления = ЛОЖЬ
		|	И ПодготовкаСредыДляИнтеграционныхТестов.Дата >= &НачалоДня
		|	И ЧАС(ПодготовкаСредыДляИнтеграционныхТестов.Дата) > 17";
	Запрос.УстановитьПараметр("НачалоДня", НачалоДня(ТекущаяДатаСеанса()));
	Если Час(ТекущаяДатаСеанса()) >= 19 И Запрос.Выполнить().Пустой() Тогда
		ЗапуститьНовыйБП("Ежедневный запуск");
		Возврат;
	КонецЕсли;
	
	// 1. Проверить завершены ли все текущие процессы
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодготовкаСредыДляИнтеграционныхТестов.Ссылка КАК Ссылка,
		|	ПодготовкаСредыДляИнтеграционныхТестов.Дата КАК Дата
		|ИЗ
		|	БизнесПроцесс.ПодготовкаСредыДляИнтеграционныхТестов КАК ПодготовкаСредыДляИнтеграционныхТестов
		|ГДЕ
		|	ПодготовкаСредыДляИнтеграционныхТестов.Завершен = ЛОЖЬ
		|	И ПодготовкаСредыДляИнтеграционныхТестов.ПометкаУдаления = ЛОЖЬ
		|	И ПодготовкаСредыДляИнтеграционныхТестов.Дата >= &ДваДняНазад";
	Запрос.УстановитьПараметр("ДваДняНазад", ТекущаяДатаСеанса() - 2 * 24 * 3600);
	Если Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// 2. С завершения предыдущего процесса прошло менее 2х часов
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(ПодготовкаСредыДляИнтеграционныхТестов.Дата) КАК Дата
		|ПОМЕСТИТЬ ПоследняяДата
		|ИЗ
		|	БизнесПроцесс.ПодготовкаСредыДляИнтеграционныхТестов КАК ПодготовкаСредыДляИнтеграционныхТестов
		|ГДЕ
		|	ПодготовкаСредыДляИнтеграционныхТестов.Завершен = ИСТИНА
		|	И ПодготовкаСредыДляИнтеграционныхТестов.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ЕСТЬNULL(ВЫБОР
		|				КОГДА ЗадачаИсполнителя.ДатаЗавершения = ДАТАВРЕМЯ(1, 1, 1)
		|					ТОГДА ЗадачаИсполнителя.Дата
		|				ИНАЧЕ ЗадачаИсполнителя.ДатаЗавершения
		|			КОНЕЦ, ПодготовкаСредыДляИнтеграционныхТестов.Дата)) КАК ДатаЗавершения
		|ИЗ
		|	ПоследняяДата КАК ПоследняяДата
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ БизнесПроцесс.ПодготовкаСредыДляИнтеграционныхТестов КАК ПодготовкаСредыДляИнтеграционныхТестов
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|			ПО ПодготовкаСредыДляИнтеграционныхТестов.Ссылка = ЗадачаИсполнителя.БизнесПроцесс
		|		ПО ПоследняяДата.Дата = ПодготовкаСредыДляИнтеграционныхТестов.Дата";
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Если Результат[0].ДатаЗавершения + 2 * 3600 > ТекущаяДатаСеанса() Тогда
		Возврат;
	КонецЕсли;
	
	// 3. Проверить появились ли новые коммиты со списком измененных объектов
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(ПодготовкаСредыДляИнтеграционныхТестов.Дата) КАК Дата
		|ПОМЕСТИТЬ ОтметкаВремени
		|ИЗ
		|	БизнесПроцесс.ПодготовкаСредыДляИнтеграционныхТестов КАК ПодготовкаСредыДляИнтеграционныхТестов
		|ГДЕ
		|	ПодготовкаСредыДляИнтеграционныхТестов.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Конфигурации1СОбъектыЗапускаИнтеграционныхТестов.Ссылка.ХранилищеОбновления КАК Хранилище,
		|	Конфигурации1СОбъектыЗапускаИнтеграционныхТестов.ИмяОбъекта + ""%"" КАК ШаблонФайла
		|ПОМЕСТИТЬ ИменаФайлов
		|ИЗ
		|	Справочник.Конфигурации.ОбъектыЗапускаИнтеграционныхТестов КАК Конфигурации1СОбъектыЗапускаИнтеграционныхТестов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 10
		|	ВЫРАЗИТЬ(ИсторияХранилищаФайлыGit.Файл КАК СТРОКА(1023)) КАК Файл
		|ИЗ
		|	Справочник.ИсторияХранилища.ФайлыGit КАК ИсторияХранилищаФайлыGit
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИменаФайлов КАК ИменаФайлов
		|		ПО ИсторияХранилищаФайлыGit.Ссылка.Владелец = ИменаФайлов.Хранилище
		|			И (ИсторияХранилищаФайлыGit.Файл ПОДОБНО ИменаФайлов.ШаблонФайла)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтметкаВремени КАК ОтметкаВремени
		|		ПО ИсторияХранилищаФайлыGit.Ссылка.Дата >= ОтметкаВремени.Дата";
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// 4. Запустить новый БП при необходимости
	ЗапуститьНовыйБП(СтрСоединить(Результат.ВыгрузитьКолонку("Файл"), ", "));
	
КонецПроцедуры

Функция ТестоваяБазаЕщеНужна(БизнесПроцесс) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодготовкаСредыДляИнтеграционныхТестов.Ссылка КАК Ссылка,
		|	ПодготовкаСредыДляИнтеграционныхТестов.Дата КАК Дата
		|ПОМЕСТИТЬ АктивныеПроцессы
		|ИЗ
		|	БизнесПроцесс.ПодготовкаСредыДляИнтеграционныхТестов КАК ПодготовкаСредыДляИнтеграционныхТестов
		|ГДЕ
		|	ПодготовкаСредыДляИнтеграционныхТестов.Завершен = ЛОЖЬ
		|	И ПодготовкаСредыДляИнтеграционныхТестов.ПометкаУдаления = ЛОЖЬ
		|	И ПодготовкаСредыДляИнтеграционныхТестов.НеОбновлятьТествыеБазы = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Влож.Дата КАК Дата,
		|	АктивныеПроцессы.Ссылка КАК Ссылка
		|ИЗ
		|	АктивныеПроцессы КАК АктивныеПроцессы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			МАКСИМУМ(АктивныеПроцессы.Дата) КАК Дата
		|		ИЗ
		|			АктивныеПроцессы КАК АктивныеПроцессы) КАК Влож
		|		ПО АктивныеПроцессы.Дата = Влож.Дата";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Ссылка <> БизнесПроцесс Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Ограничение в 2.5 часа
	Если ТекущаяДатаСеанса() - БизнесПроцесс.Дата > 2.5 * 3600 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Процедура ДобавитьСообщение(БП, Текст, Шаг, Ошибка = Ложь, ИсключитьДубли = Истина) Экспорт
	КонвейерОбработкиСервер.ДобавитьСообщениеБизнесПроцесс(БП, Текст, Шаг, 0, Ошибка, ИсключитьДубли);
КонецПроцедуры

Функция ПолучитьПредставлениеЗадачиВHTML(ЗадачаБП) Экспорт
	Если Ложь Тогда
		Задача = Задачи.ЗадачаИсполнителя.ПустаяСсылка();
	КонецЕсли;
	БП = ?(ТипЗнч(ЗадачаБП) = Тип("ЗадачаСсылка.ЗадачаИсполнителя"), ЗадачаБП.БизнесПроцесс, ЗадачаБП);
	Если Ложь Тогда
		БП = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ПустаяСсылка();
	КонецЕсли;
	
	ОписаниеЗадачи = Новый ТекстовыйДокумент;
	ОписаниеЗадачи.ДобавитьСтроку("<html><body>");
	ОписаниеЗадачи.ДобавитьСтроку(СтрШаблон("<h3><a href=""%1"">%2</a></h3><br/>",
		ПолучитьНавигационнуюСсылку(БП), БП));
		
	ОписаниеЗадачи.ДобавитьСтроку("<hr/><br/>");
	ОписаниеЗадачи.ДобавитьСтроку(СтрШаблон("Количество ошибок Конвейера: %1<br/>",
		Формат(БП.Автотесты.НайтиСтроки(Новый Структура("Ошибка", Истина)).Количество(), "ЧН=0")));
	Если ЗначениеЗаполнено(БП.ИдентификаторКонвейера) Тогда
		URL = КонвейерОбработкиСервер.URLКонвейера(БП.Хранилище, БП.ИдентификаторКонвейера);
		ОписаниеЗадачи.ДобавитьСтроку(СтрШаблон("Пайплайн: <a href=""%1"" target=""_blank"">%2</a><br/>",
			URL, БП.ИдентификаторКонвейера));
	КонецЕсли;
	
	ОписаниеЗадачи.ДобавитьСтроку("<hr/><br/>");
	ОписаниеЗадачи.ДобавитьСтроку("<ul>");
	Для Каждого Стр Из БП.ТестовыеБазы Цикл
		СтрокаСоединенияОдинарныеКавычки = СтрЗаменить(Стр.СтрокаСоединения, """", "'");
		
		ОписаниеЗадачи.ДобавитьСтроку("<li>");
		Если Стр.Подготовлена Тогда
			ОписаниеЗадачи.ДобавитьСтроку(СтрШаблон("Актуальная копия %1 (%2):", Стр.Наименование, Стр.СтрокаСоединения));
			ОписаниеЗадачи.ДобавитьСтроку(СтрШаблон("<br>&nbsp;&nbsp;<a href=""%2;%3"">%1</a>", 
				"Конфигуратор", СтрокаСоединенияОдинарныеКавычки, "DESIGNER"));
			ОписаниеЗадачи.ДобавитьСтроку(СтрШаблон("<br>&nbsp;&nbsp;<a href=""%2;%3"">%1</a>", 
				"Обычное приложение", СтрокаСоединенияОдинарныеКавычки, "RunModeOrdinaryApplication"));
			ОписаниеЗадачи.ДобавитьСтроку(СтрШаблон("<br>&nbsp;&nbsp;<a href=""%2;%3"">%1</a>", 
				"Управляемое приложение", СтрокаСоединенияОдинарныеКавычки, "RunModeManagedApplication"));
			
		ИначеЕсли Стр.ОшибкаПроготовки Тогда
			ОписаниеЗадачи.ДобавитьСтроку(СтрШаблон("При подготовке %1 <a href=""%3;%4"">%2</a> произошла ошибка. %5", 
				Стр.Наименование, Стр.СтрокаСоединения, СтрокаСоединенияОдинарныеКавычки, "DESIGNER", Стр.Причина));
			
		Иначе
			ОписаниеЗадачи.ДобавитьСтроку(СтрШаблон("Тестовая копия %1 <a href=""%3"">%2</a> еще не подготовлена!", 
				Стр.Наименование, Стр.СтрокаСоединения, СтрокаСоединенияОдинарныеКавычки));
		КонецЕсли;
		ОписаниеЗадачи.ДобавитьСтроку("</li>");
		
	КонецЦикла;
	ОписаниеЗадачи.ДобавитьСтроку("</ul>");
	
	ОписаниеЗадачи.ДобавитьСтроку("</body></html>");
	
	Возврат ОписаниеЗадачи.ПолучитьТекст();
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция Инициализация(БизнесПроцесс)
	Если Не ТестоваяБазаЕщеНужна(БизнесПроцесс) Тогда
		Возврат Истина;
		БизнесПроцесс = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ПустаяСсылка();
	КонецЕсли;
	
	ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ТочкиМаршрута.Инициализация;
	
	Об = БизнесПроцесс.ПолучитьОбъект();
	Об.Заблокировать();
	Об.Проекты.Очистить();
	Об.ТестовыеБазы.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиБазИнтеграционныхТестов.Конфигурация КАК Конфигурация,
		|	МАКСИМУМ(НастройкиБазИнтеграционныхТестов.Конфигурация.ХранилищеОбновления) КАК Хранилище,
		|	МИНИМУМ(НастройкиБазИнтеграционныхТестов.Порядок) КАК Порядок
		|ПОМЕСТИТЬ ВтБазовоеХранилище
		|ИЗ
		|	РегистрСведений.НастройкиБазИнтеграционныхТестов КАК НастройкиБазИнтеграционныхТестов
		|ГДЕ
		|	НЕ НастройкиБазИнтеграционныхТестов.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкиБазИнтеграционныхТестов.Конфигурация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсторияХранилища.Владелец КАК Владелец,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ИсторияХранилища.Владелец.БазовоеХранилище = ЗНАЧЕНИЕ(Справочник.Хранилища.ПустаяСсылка)
		|				ТОГДА ИсторияХранилища.Владелец
		|			ИНАЧЕ ИсторияХранилища.Владелец.БазовоеХранилище
		|		КОНЕЦ) КАК БазовоеХранилище,
		|	МАКСИМУМ(ИсторияХранилища.Код) КАК Код,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ИсторияХранилища.Владелец.БазовоеХранилище = ЗНАЧЕНИЕ(Справочник.Хранилища.ПустаяСсылка)
		|				ТОГДА """"
		|			ИНАЧЕ ИсторияХранилища.Владелец.ИмяПапкиGit
		|		КОНЕЦ) КАК ИмяРасширения
		|ПОМЕСТИТЬ ПоследниеКоммиты
		|ИЗ
		|	Справочник.ИсторияХранилища КАК ИсторияХранилища
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтБазовоеХранилище КАК ВтБазовоеХранилище
		|		ПО (ВтБазовоеХранилище.Хранилище В (ИсторияХранилища.Владелец, ИсторияХранилища.Владелец.БазовоеХранилище))
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсторияХранилища.Владелец,
		|	ВЫБОР
		|		КОГДА ИсторияХранилища.Владелец.БазовоеХранилище = ЗНАЧЕНИЕ(Справочник.ИсторияХранилища.ПустаяСсылка)
		|			ТОГДА ИсторияХранилища.Владелец
		|		ИНАЧЕ ИсторияХранилища.Владелец.БазовоеХранилище
		|	КОНЕЦ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВтБазовоеХранилище.Конфигурация КАК Конфигурация,
		|	ВтБазовоеХранилище.Хранилище КАК Хранилище,
		|	ИсторияХранилища.Ссылка КАК Коммит,
		|	NULL КАК ПутьКФайлуКонфигурации,
		|	ПоследниеКоммиты.ИмяРасширения КАК ИмяРасширения,
		|	ВтБазовоеХранилище.Порядок КАК Порядок
		|ИЗ
		|	ВтБазовоеХранилище КАК ВтБазовоеХранилище
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПоследниеКоммиты КАК ПоследниеКоммиты
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИсторияХранилища КАК ИсторияХранилища
		|			ПО ПоследниеКоммиты.Владелец = ИсторияХранилища.Владелец
		|				И ПоследниеКоммиты.Код = ИсторияХранилища.Код
		|		ПО ВтБазовоеХранилище.Хранилище = ПоследниеКоммиты.БазовоеХранилище
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
	Об.Проекты.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиБазИнтеграционныхТестов.Наименование КАК Наименование,
		|	НастройкиБазИнтеграционныхТестов.Конфигурация КАК Конфигурация,
		|	НастройкиБазИнтеграционныхТестов.СтрокаСоединенияИсточник КАК СтрокаСоединенияИсточник,
		|	НастройкиБазИнтеграционныхТестов.СтрокаСоединенияПриемник КАК СтрокаСоединения
		|ИЗ
		|	РегистрСведений.НастройкиБазИнтеграционныхТестов КАК НастройкиБазИнтеграционныхТестов
		|ГДЕ
		|	НЕ НастройкиБазИнтеграционныхТестов.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	НастройкиБазИнтеграционныхТестов.Порядок";
	Об.ТестовыеБазы.Загрузить(Запрос.Выполнить().Выгрузить());
	Об.Записать();
	Об.Разблокировать();
	
	Возврат Истина;
КонецФункции

Функция ПолучениеФайловКонфигураций(БизнесПроцесс)
	Если Не ТестоваяБазаЕщеНужна(БизнесПроцесс) Тогда
		Возврат Истина;
		БизнесПроцесс = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ПустаяСсылка();
	КонецЕсли;
	
	ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ТочкиМаршрута.ПолучениеФайловКонфигураций;
	
	Для Каждого СтрПроект Из БизнесПроцесс.Проекты Цикл
		Если ЗначениеЗаполнено(СтрПроект.ПутьКФайлуКонфигурации) Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			ИмяФайла = КешВерсийХранилищ.ПолучитьПутьФайлаВерсии(СтрПроект.Коммит);
			Об = БизнесПроцесс.ПолучитьОбъект();
			Об.Заблокировать();
			ДобавитьСообщение(Об, ИмяФайла, ТочкаМаршрутаБизнесПроцесса);
			СтрОб = Об.Проекты[СтрПроект.НомерСтроки-1];
			СтрОб.ПутьКФайлуКонфигурации = ИмяФайла;
			Об.Записать();
			Об.Разблокировать();
		Исключение
			ДобавитьСообщение(БизнесПроцесс, ОписаниеОшибки(), ТочкаМаршрутаБизнесПроцесса, Истина);
			Если Об<>Неопределено Тогда
				Об.Разблокировать();
			КонецЕсли;
		КонецПопытки;
		
	КонецЦикла;
	
	Для Каждого СтрПроект Из БизнесПроцесс.Проекты Цикл
		Если Не ЗначениеЗаполнено(СтрПроект.ПутьКФайлуКонфигурации) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции	

Функция ЗапускПайплайна(БП)
	
	ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.ТочкиМаршрута.ЗапускПайплайна;
	
	Если ЗначениеЗаполнено(БП.ИдентификаторКонвейера) Тогда
		ДобавитьСообщение(БП, "Пайплайна был запущен ранее "+БП.ИдентификаторКонвейера, ТочкаМаршрутаБизнесПроцесса);
		Возврат Истина;
	КонецЕсли;
	
	Попытка
		Объект = БП.ПолучитьОбъект();
		Объект.Заблокировать();
		Ответ = КонвейерОбработкиСервер.ЗапускПайплайна(БП.Хранилище, Справочники.ИсторияХранилища.ПустаяСсылка(), "main");
		Если Ответ.Успех = Ложь Тогда
			ВызватьИсключение Ответ.ТекстОшибки;
		КонецЕсли;
		
		Объект.ИдентификаторКонвейера = Ответ.ИдентификаторКонвейера;
		Объект.ВнутреннийИдентификаторКонвейера = Ответ.ВнутреннийИдентификаторКонвейера;
		ДобавитьСообщение(Объект, СтрШаблон("Запущен пайплайн № %1", Объект.ИдентификаторКонвейера), ТочкаМаршрутаБизнесПроцесса);
		Объект.Записать();
		Объект.Разблокировать();
		Возврат Истина;
	Исключение
		Объект.Разблокировать();
		ОписаниеОшибки = ОписаниеОшибки();
		ДобавитьСообщение(БП, ОписаниеОшибки, ТочкаМаршрутаБизнесПроцесса, Истина, Истина);
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

Функция КонвейерЗавершен(БП)
	Возврат КонвейерОбработкиСервер.КонвейерЗавершен(БП.Хранилище, БП.ИдентификаторКонвейера, БП.ВнутреннийИдентификаторКонвейера);
КонецФункции

Функция СборРезультатаПайплайна(БП)
	
	ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.КонвейерОбработки.ТочкиМаршрута.СборРезультатаПайплайна;
	
	РезультатаПайплайна = КонвейерОбработкиСервер.ПолучитьРезультатаПайплайна(БП.Хранилище, БП.ИдентификаторКонвейера, БП.ВнутреннийИдентификаторКонвейера);
	
	Об = БП.ПолучитьОбъект();
	Об.Заблокировать();
	Об.Автотесты.Загрузить(РезультатаПайплайна);
	Об.КоличествоОшибокАвтотестов = Об.Автотесты.НайтиСтроки(Новый Структура("Ошибка", Истина)).Количество();
	ОбщееКолчиествоТестов = Об.Автотесты.Количество() - Об.Автотесты.НайтиСтроки(Новый Структура("Группа", "Итоги")).Количество();
	Подробности = СтрШаблон("Пайплайн завершен (%1/%2)", XMLСтрока(Об.КоличествоОшибокАвтотестов), XMLСтрока(ОбщееКолчиествоТестов));
	Если ОбщееКолчиествоТестов = 0 Тогда 
		Подробности = СтрЗаменить(Подробности, "без ошибок", "не отработала, тесты по пайплайну не запустились!");
	КонецЕсли;
	ДобавитьСообщение(Об, Подробности, ТочкаМаршрутаБизнесПроцесса);
	Об.Записать();
	Об.Разблокировать();
	
	Возврат Истина;
	
КонецФункции

Процедура ЗапуститьНовыйБП(ПричинаЗапуска = "")
	
	НовыйБП = БизнесПроцессы.ПодготовкаСредыДляИнтеграционныхТестов.СоздатьБизнесПроцесс();
	НовыйБП.Дата = ТекущаяДатаСеанса();
	НовыйБП.Записать();
	НовыйБП.Ответственный = Справочники.Пользователи.НайтиПоКоду("maza");
	НовыйБП.Хранилище = Константы.ПроектПодготовкаСредыДляИнтеграционныхТестов.Получить();
	НовыйБП.ПричинаЗапуска = ПричинаЗапуска;
	НовыйБП.Старт();
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли


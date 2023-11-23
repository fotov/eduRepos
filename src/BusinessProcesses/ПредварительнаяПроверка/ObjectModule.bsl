#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПеревестиНаСледующийЭтапПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	Если Не ИнтеграцияСМетеор.ПроверитьТекущийЭтапЗадачиВМетеоре(ЗадачаМетеор, Справочники.ЭтапыЗадачиМетеор.ПроверкаКода)
			И Не ИнтеграцияСМетеор.ПроверитьТекущийЭтапЗадачиВМетеоре(ЗадачаМетеор, Справочники.ЭтапыЗадачиМетеор.ПроверкаКодаПодключениеРасширения) Тогда
		Возврат;
	КонецЕсли;
	
	Этапы = РегистрыСведений.СледующиеЭтапыЗадачиПоТочкеМаршрута.ПолучитьЭтапыПоТочкеМаршрута(
		Бизнеспроцессы.ПредварительнаяПроверка.ТочкиМаршрута.ПеревестиНаСледующийЭтап,
		ПредварительнаяПроверкаПройдена);
	ИнтеграцияСМетеор.ПеревестиЗадачуНаЭтапВМетеоре(ЗадачаМетеор, Этапы);
	
КонецПроцедуры

Процедура ОповеститьОРезультатеПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	АдресПолучателя = БизнесПроцессы.ПредварительнаяПроверка.АдресПолучателя(ЭтотОбъект);
	Если ЗначениеЗаполнено(АдресПолучателя) Тогда
		ОтправитьОповещение(АдресПолучателя);
	КонецЕсли;
	
	// Рассылка оповещения ответственным за логические подсистемы.
	ОтправитьОповещениеСвязаннымОтветственнымПоОбъектам();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	РегистрыСведений.ОтветственныеПоИсточникам.ОбновитьОтвественных(Ссылка);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтрольТекущихПроверокПоЗадаче(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("старПредварительнаяПроверкаПройдена", Ссылка.ПредварительнаяПроверкаПройдена);
	
	Если ПредварительнаяПроверкаПройдена И Не ДополнительныеСвойства.старПредварительнаяПроверкаПройдена Тогда
		Версии = РаботаСХранилищами.ДанныеПоЗадаче(ЗадачаМетеор).Версии;
		Для Каждого Строка Из Версии.НайтиСтроки(Новый Структура("Статус", БизнесПроцессы.ПредварительнаяПроверка.ОсновнойСтатус())) Цикл
			НоваяСтрока = Коммиты.Добавить();
			НоваяСтрока.Коммит = Строка.Коммит;
		КонецЦикла;
		ЗафиксироватьСогласованныеДополнения();
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
КонецПроцедуры

Процедура КонтрольТекущихПроверокПоЗадаче(Отказ)
	
	Если Стартован
		И Не Завершен
		И Не ПометкаУдаления
		И БизнесПроцессы.ПредварительнаяПроверка.ЕстьАктивныйПроцесс(ЗадачаМетеор, Ссылка) Тогда
		
		ТекстСообщения = СтрШаблон("Для задачи %1 уже есть активный перенос!", ЗадачаМетеор);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПредварительнаяПроверкаПройдена И Не ДополнительныеСвойства.старПредварительнаяПроверкаПройдена Тогда
		
		Версии = РаботаСХранилищами.ДанныеПоЗадаче(ЗадачаМетеор).Версии;
		Для Каждого Строка Из Версии.НайтиСтроки(Новый Структура("Статус", БизнесПроцессы.ПредварительнаяПроверка.ОсновнойСтатус())) Цикл
			РаботаСХранилищами.ЗаписатьСтатусВерсииХранилища(Строка.Коммит,
				БизнесПроцессы.СогласованиеПереноса.ОсновнойСтатус(), , Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтправитьОповещение(АдресПолучателя)
	
	Ответственный = Проверил_ПроверкаКода;
	Если ПредварительнаяПроверкаПройдена Тогда
		ТемаШаблон = "Изменения по задаче %1 проверены";
	Иначе
		ТемаШаблон = "Отказ. Изменения по задаче %1 были отклонены ведущим";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ответственный) Тогда
		ТемаШаблон = СтрШаблон("%1 (%2)", ТемаШаблон, Ответственный);
	КонецЕсли;
	
	ТемаПисьма = СтрШаблон(ТемаШаблон, ЗадачаМетеор);
	
	ТекущийТекстHTML = "<body>";
	
	ПочтовыеВложения = Новый ТаблицаЗначений;
	ПочтовыеВложения.Колонки.Добавить("Ключ");
	ПочтовыеВложения.Колонки.Добавить("Значение");
	ПочтовыеВложения.Колонки.Добавить("Расширение");
	
	ТекстЗадачаМетеор = СтрШаблон("<FONT color=""#006600""><a href=""%1"" target=""_blank"">%2</a></FONT>", Справочники.ЗадачиМетеор.URLЗадачиМетеор(ЗадачаМетеор), ЗадачаМетеор);
	ТекстИзменений = СтрШаблон("<h2>" + ТемаШаблон + "</h2>", ТекстЗадачаМетеор);
	Если ЗначениеЗаполнено(ЗадачаМетеор.НаименованиеЗадачи) Тогда
		ТекстИзменений = ТекстИзменений + СтрШаблон("<p>(%1)</p>", ЗадачаМетеор.НаименованиеЗадачи);
	КонецЕсли;
	Для Каждого Строка Из Коммиты Цикл
		
		ТекстИзменений = ТекстИзменений + СтрШаблон("<p><b>Коммит %1 от %2</b></p>", Строка.Коммит.Код, Строка.Коммит.Дата);
		
		ТекстДобавлено = "";
		Для Каждого Добавлен Из Строка.Коммит.Добавлены Цикл 
			ТекстДобавлено = ТекстДобавлено + СтрШаблон("<li>%1</li>", Добавлен.ИмяОбъекта);
		КонецЦикла;
		ТекстИзменено = "";
		Для Каждого Добавлен Из Строка.Коммит.Изменены Цикл 
			ТекстИзменено = ТекстИзменено + СтрШаблон("<li>%1</li>", Добавлен.ИмяОбъекта);
		КонецЦикла;
		ТекстУдалено = "";
		Для Каждого Добавлен Из Строка.Коммит.Удалены Цикл 
			ТекстУдалено = ТекстУдалено + СтрШаблон("<li>%1</li>", Добавлен.ИмяОбъекта);
		КонецЦикла;
		ТекстИзменений = ТекстИзменений +
			?(НЕ ПустаяСтрока(ТекстДобавлено), СтрШаблон("Добавлено:<ul>%1</ul>", ТекстДобавлено), "") + 
			?(НЕ ПустаяСтрока(ТекстИзменено), СтрШаблон("Изменено:<ul>%1</ul>", ТекстИзменено), "") +
			?(НЕ ПустаяСтрока(ТекстУдалено), СтрШаблон("Удалено:<ul>%1</ul>", ТекстУдалено), "");
		
	КонецЦикла;
	ТекущийТекстHTML = ТекущийТекстHTML + ТекстИзменений;
	
	Для Каждого ИмяПроверки Из СтрРазделить("ПроверкаКода", ",") Цикл
		
		Текст = СтрЗаменить(ЭтотОбъект["ЗамечаниеHTML_" + ИмяПроверки], "<body>", "");
		Текст = СтрЗаменить(Текст, "</body>", "");
		ТекущийТекстHTML = ТекущийТекстHTML + Текст;
		
		ДопВложения = ЭтотОбъект["ЗамечаниехзВложения_" + ИмяПроверки].Получить();
		Если Не ДопВложения = Неопределено Тогда
			Для Каждого Элемент Из ДопВложения Цикл
				НовСтр = ПочтовыеВложения.Добавить();
				НовСтр.Ключ = Элемент.Ключ;
				НовСтр.Значение = Элемент.Значение;
				НовСтр.Расширение = "html";
			КонецЦикла;
		КонецЕсли;
			
	КонецЦикла;
	
	ТекущийТекстHTML = ТекущийТекстHTML + "</body>";
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Получатели", АдресПолучателя);
	ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
	ПараметрыПисьма.Вставить("Тело", ТекущийТекстHTML);
	ПараметрыПисьма.Вставить("Вложения", ПочтовыеВложения);
	Документы.ЭлектронноеПисьмо.СоздатьПисьмо(ПараметрыПисьма);
	
КонецПроцедуры

Процедура ЗафиксироватьСогласованныеДополнения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗадачаМетеор", ЗадачаМетеор);
	Запрос.УстановитьПараметр("СтатусДляСогласования", БизнесПроцессы.ПредварительнаяПроверка.ОсновнойСтатус());
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачиМетеорДополнений.ВерсияДополнения КАК ВерсияДополнения
		|ПОМЕСТИТЬ ДополненияПоЗадаче
		|ИЗ
		|	РегистрСведений.ЗадачиМетеорДополнений КАК ЗадачиМетеорДополнений
		|ГДЕ
		|	ЗадачиМетеорДополнений.ЗадачаМетеор = &ЗадачаМетеор
		|	И НЕ ЗадачиМетеорДополнений.ВерсияДополнения.ПометкаУдаления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДополненияПоЗадаче.ВерсияДополнения КАК ВерсияДополнения,
		|	СтатусыДополненийСрезПоследних.Статус КАК Статус
		|ИЗ
		|	ДополненияПоЗадаче КАК ДополненияПоЗадаче
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДополнений.СрезПоследних(
		|				,
		|				ВерсияДополнения В
		|					(ВЫБРАТЬ
		|						ДополненияПоЗадаче.ВерсияДополнения
		|					ИЗ
		|						ДополненияПоЗадаче КАК ДополненияПоЗадаче)) КАК СтатусыДополненийСрезПоследних
		|		ПО ДополненияПоЗадаче.ВерсияДополнения = СтатусыДополненийСрезПоследних.ВерсияДополнения
		|ГДЕ
		|	СтатусыДополненийСрезПоследних.Статус = &СтатусДляСогласования";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СогласованныеДополнения.Добавить(), Выборка);
		РаботаСДополнениями.ЗаписатьСтатусВерсии(Выборка.ВерсияДополнения, Перечисления.СтатусыИсторииХранилищ.Перенос);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтправитьОповещениеСвязаннымОтветственнымПоОбъектам()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачиМетеорВерсийХранилища.ВерсияХранилища КАК Коммит
		|ПОМЕСТИТЬ ВерсииХранилищаПроверил
		|ИЗ
		|	РегистрСведений.ЗадачиМетеорВерсийХранилища КАК ЗадачиМетеорВерсийХранилища
		|ГДЕ
		|	ЗадачиМетеорВерсийХранилища.ЗадачаМетеор = &ЗадачаМетеор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Изменения.ИмяОбъекта КАК ИмяОбъекта,
		|	Изменения.ВерсияХранилища КАК ВерсияХранилища,
		|	Изменения.Конфигурация КАК Конфигурация,
		|	ОбъектыМетаданных.Ссылка КАК ОбъектМетаданных,
		|	СоставЛогическихПодсистем.ЛогическаяПодсистема КАК ЛогическаяПодсистема
		|ПОМЕСТИТЬ ОбъектыСИзменениями
		|ИЗ
		|	ВерсииХранилищаПроверил КАК ВерсииХранилищаПроверил
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ИсторияХранилищаИзменены.ИмяОбъекта КАК ИмяОбъекта,
		|			ИсторияХранилищаИзменены.Ссылка КАК ВерсияХранилища,
		|			ИсторияХранилищаИзменены.Ссылка.Владелец.Владелец КАК Конфигурация
		|		ИЗ
		|			Справочник.ИсторияХранилища.Изменены КАК ИсторияХранилищаИзменены
		|		ГДЕ
		|			ИсторияХранилищаИзменены.Ссылка В
		|					(ВЫБРАТЬ
		|						ВерсииХранилищаПроверил.Коммит КАК Коммит
		|					ИЗ
		|						ВерсииХранилищаПроверил КАК ВерсииХранилищаПроверил)
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			ИсторияХранилищаДобавлены.ИмяОбъекта,
		|			ИсторияХранилищаДобавлены.Ссылка,
		|			ИсторияХранилищаДобавлены.Ссылка.Владелец.Владелец
		|		ИЗ
		|			Справочник.ИсторияХранилища.Добавлены КАК ИсторияХранилищаДобавлены
		|		ГДЕ
		|			ИсторияХранилищаДобавлены.Ссылка В
		|					(ВЫБРАТЬ
		|						ВерсииХранилищаПроверил.Коммит КАК Коммит
		|					ИЗ
		|						ВерсииХранилищаПроверил КАК ВерсииХранилищаПроверил)
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			ИсторияХранилищаУдалены.ИмяОбъекта,
		|			ИсторияХранилищаУдалены.Ссылка,
		|			ИсторияХранилищаУдалены.Ссылка.Владелец.Владелец
		|		ИЗ
		|			Справочник.ИсторияХранилища.Удалены КАК ИсторияХранилищаУдалены
		|		ГДЕ
		|			ИсторияХранилищаУдалены.Ссылка В
		|					(ВЫБРАТЬ
		|						ВерсииХранилищаПроверил.Коммит КАК Коммит
		|					ИЗ
		|						ВерсииХранилищаПроверил КАК ВерсииХранилищаПроверил)) КАК Изменения
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыМетаданных КАК ОбъектыМетаданных
		|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставЛогическихПодсистем КАК СоставЛогическихПодсистем
		|				ПО (СоставЛогическихПодсистем.ОбъектМетаданных = ОбъектыМетаданных.Ссылка)
		|			ПО (Изменения.ИмяОбъекта = ОбъектыМетаданных.Наименование
		|					ИЛИ Изменения.ИмяОбъекта ПОДОБНО ОбъектыМетаданных.Наименование + "".%"")
		|				И Изменения.Конфигурация = ОбъектыМетаданных.Владелец
		|		ПО ВерсииХранилищаПроверил.Коммит = Изменения.ВерсияХранилища
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтветственныеЛогическихПодсистемСрезПоследних.ЛогическаяПодсистема КАК ЛогическаяПодсистема,
		|	ОтветственныеЛогическихПодсистемСрезПоследних.Ответственный КАК Ответственный
		|ПОМЕСТИТЬ ТекущиеОтветственныеЛогическихПодсистем
		|ИЗ
		|	РегистрСведений.ОтветственныеЛогическихПодсистем.СрезПоследних(
		|			,
		|			ЛогическаяПодсистема В
		|				(ВЫБРАТЬ
		|					ОбъектыСИзменениями.ЛогическаяПодсистема КАК ЛогическаяПодсистема
		|				ИЗ
		|					ОбъектыСИзменениями КАК ОбъектыСИзменениями)) КАК ОтветственныеЛогическихПодсистемСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОбъектыСИзменениями.ВерсияХранилища КАК ВерсияХранилища,
		|	ПРЕДСТАВЛЕНИЕ(ОбъектыСИзменениями.Конфигурация) КАК КонфигурацияПредставление,
		|	ТекущиеОтветственныеЛогическихПодсистем.Ответственный КАК ОтветственныйПоПодсистеме,
		|	ПРЕДСТАВЛЕНИЕ(ОбъектыСИзменениями.ВерсияХранилища) КАК ВерсияХранилищаПредставление,
		|	ОбъектыСИзменениями.ИмяОбъекта КАК ИмяОбъекта
		|ИЗ
		|	ОбъектыСИзменениями КАК ОбъектыСИзменениями
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТекущиеОтветственныеЛогическихПодсистем КАК ТекущиеОтветственныеЛогическихПодсистем
		|		ПО ОбъектыСИзменениями.ЛогическаяПодсистема = ТекущиеОтветственныеЛогическихПодсистем.ЛогическаяПодсистема
		|ГДЕ
		|	НЕ ТекущиеОтветственныеЛогическихПодсистем.Ответственный = &Проверил
		|	И НЕ ТекущиеОтветственныеЛогическихПодсистем.Ответственный = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";
	
	Запрос.УстановитьПараметр("ЗадачаМетеор", ЗадачаМетеор);
	Запрос.УстановитьПараметр("Проверил", Проверил_ПроверкаКода);
	Выборка = Запрос.Выполнить().Выбрать();
	ШаблонСообщения = "По объектам в которых вы являетесь ответственным выполнено согласование кода по коммитам:" + Символы.ПС + "%1";
	ТемаПисьма = "По объектам в которых вы являетесь ответственным выполнено согласование кода.";
	Пока Выборка.СледующийПоЗначениюПоля("ОтветственныйПоПодсистеме") Цикл
		ВерсииХранилищаПредставления = Новый Массив;
		ВерсииХранилищаПредставленияПисьмо = Новый Массив;
		Пока Выборка.СледующийПоЗначениюПоля("ВерсияХранилища") Цикл
			ОбъектыВерсии = Новый Массив();	
			Пока Выборка.СледующийПоЗначениюПоля("ИмяОбъекта") Цикл
				ОбъектыВерсии.Добавить(Выборка.ИмяОбъекта);
			КонецЦикла;
			ВерсииХранилищаПредставления.Добавить(
				СтрШаблон("%1 (%2): %3",
				Выборка.ВерсияХранилищаПредставление,
				Выборка.КонфигурацияПредставление,
				РаботаСGIT.URLGit(Выборка.ВерсияХранилища)));
			ВерсииХранилищаПредставленияПисьмо.Добавить(
				СтрШаблон("%1 (%2): %3" + Символы.ПС + "Изменены: %4",
				Выборка.ВерсияХранилищаПредставление,
				Выборка.КонфигурацияПредставление,
				РаботаСGIT.URLGit(Выборка.ВерсияХранилища),
				СтрСоединить(ОбъектыВерсии, ", ")));
		КонецЦикла;
		
		ТекстСообщения = СтрШаблон(ШаблонСообщения, СтрСоединить(ВерсииХранилищаПредставления, Символы.ПС));
		ТекстСообщенияПисьмо = СтрШаблон(ШаблонСообщения, СтрСоединить(ВерсииХранилищаПредставленияПисьмо, Символы.ПС));
		// Отправка по и-мейл
		АдресЭП = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
			Выборка.ОтветственныйПоПодсистеме,
			Справочники.ВидыКонтактнойИнформации.EmailПользователя,
			,
			,
			Новый Структура("ТолькоПервая", Истина));
		Если ЗначениеЗаполнено(АдресЭП) Тогда
			ПараметрыПисьма = Новый Структура;
			ПараметрыПисьма.Вставить("Получатели", АдресЭП);
			ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
			ПараметрыПисьма.Вставить("Тело", ТекстСообщенияПисьмо);
			Документы.ЭлектронноеПисьмо.СоздатьПисьмо(ПараметрыПисьма);
		КонецЕсли;
		// Отправка в ТГ
		ВнешниеДанные.ОтправитьСообщеие(ТекстСообщения, 0, Истина, Выборка.ОтветственныйПоПодсистеме);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

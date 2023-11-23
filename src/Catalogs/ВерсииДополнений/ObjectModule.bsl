
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоНовый() И Не ЗначениеЗаполнено(Автор) Тогда
		Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если ЭтоНовый() Тогда
		ДатаСоздания = ТекущаяДатаСеанса();
	КонецЕсли;
	Если Не ДополнительныеСвойства.Свойство("ЭтоНовый") Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Владелец) И Не ДополнительныеСвойства.Свойство("ИнтерактивнаяЗапись") Тогда
		ОбщегоНазначения.СообщитьПользователю("Не заполнено поле ""Владелец""",,,, Отказ);
	КонецЕсли;
	// При записи из формы записываем связанные объекты
	Если ДополнительныеСвойства.Свойство("ИнтерактивнаяЗапись") Тогда
		ЗаписатьСвязанныеДанныеПередЗаписью(ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтерактивнаяЗапись = ДополнительныеСвойства.Свойство("ИнтерактивнаяЗапись");
	
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		УстановитьПривилегированныйРежим(Истина);
		РаботаСДополнениями.ЗаписатьСтатусВерсии(Ссылка, Перечисления.СтатусыИсторииХранилищ.ЗагрузкаДанных);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Если ИнтерактивнаяЗапись Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЗаписатьСвязанныеДанныеПриЗаписи(ДополнительныеСвойства, Отказ);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	Если ЭтоНовый() Тогда
		НепроверяемыеРеквизиты.Добавить("Владелец");
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьСвязанныеДанныеПередЗаписью(ДопСвойства, Отказ)
	
	Если Не ЗначениеЗаполнено(Владелец) Тогда
		ДополнениеВладелец = Справочники.Дополнения.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(ДополнениеВладелец, ДопСвойства, "ТипДополнения, Конфигурация, ТипРасширения");
		ИмяФайлаБезРасширения = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайла).ИмяБезРасширения;
		ДополнениеВладелец.Наименование = ?(ЗначениеЗаполнено(ИмяОбъекта), ИмяОбъекта, ИмяФайлаБезРасширения);
		ДополнениеВладелец.Записать();
		Владелец = ДополнениеВладелец.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьСвязанныеДанныеПриЗаписи(ДопСвойства, Отказ)
	
	ЗадачаМетеор = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДопСвойства, "ЗадачаМетеор");
	Если ЗначениеЗаполнено(ЗадачаМетеор) Тогда
		ЗаписьЗадачиДополнений = РегистрыСведений.ЗадачиМетеорДополнений.СоздатьМенеджерЗаписи();
		ЗаписьЗадачиДополнений.ВерсияДополнения = Ссылка;
		ЗаписьЗадачиДополнений.ЗадачаМетеор = ЗадачаМетеор;
		ЗаписьЗадачиДополнений.Записать(Истина);
	КонецЕсли;
	
	ДатыАктуальностиРасширения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДопСвойства, "ДатыАктуальностиРасширения", Новый Массив);
	НаборДатыАктуальности = РегистрыСведений.ДатыАктуальностиРасширений.СоздатьНаборЗаписей();
	НаборДатыАктуальности.Отбор.ВерсияДополнения.Установить(Ссылка);
	Для Каждого СтруктураДатыАктуальности Из ДатыАктуальностиРасширения Цикл
		// ДатыАктуальностиРасширений
		ЗаписьДатыАктуальности = НаборДатыАктуальности.Добавить();
		ЗаписьДатыАктуальности.ВерсияДополнения = Ссылка;
		ЗаписьДатыАктуальности.База = СтруктураДатыАктуальности.База;
		ЗаписьДатыАктуальности.ДатаАктуальности = СтруктураДатыАктуальности.ДатаАктуальности;
		// ВерсииДополненийПоЗадачеИБазае
		ВерсииПоЗадачеИбазе = РегистрыСведений.ВерсииДополненийПоЗадачеИБазе.СоздатьМенеджерЗаписи();
		ВерсииПоЗадачеИбазе.Период = ТекущаяДатаСеанса();
		ВерсииПоЗадачеИбазе.ЗадачаМетеор = ЗадачаМетеор;
		ВерсииПоЗадачеИбазе.База = СтруктураДатыАктуальности.База;
		ВерсииПоЗадачеИбазе.ВерсияДополнения = Ссылка;
		ВерсииПоЗадачеИбазе.АвторИзменений = Пользователи.ТекущийПользователь();
		ВерсииПоЗадачеИбазе.Записать();
	КонецЦикла;
	НаборДатыАктуальности.Записать();
	
	АдресДанныхДополнения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДопСвойства, "АдресДанныхДополнения", "");
	Если ДопСвойства.ЭтоНовый И Не ЭтоАдресВременногоХранилища(АдресДанныхДополнения) Тогда
		ВызватьИсключение "Для новых дополнений обязательно прикрепление файла."
	ИначеЕсли ДопСвойства.ЭтоНовый Тогда
		// Новое дополнение и добавлен файл
		РеквизитыФайла = Новый Структура;
		ПараметрыФайла = РаботаСФайлами.ПараметрыДобавленияФайла(РеквизитыФайла);
		ПараметрыФайла.ВладелецФайлов = Ссылка;
		ПараметрыФайла.Автор = Автор;
		ПараметрыФайла.ИмяБезРасширения = Наименование;
		ПараметрыФайла.РасширениеБезТочки = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла);
		РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресДанныхДополнения);
	ИначеЕсли ЭтоАдресВременногоХранилища(АдресДанныхДополнения) Тогда
		// Существующее дополнение. Обновляем файл.
		ПрисоединенныеФайлы = Новый Массив;
		РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(Ссылка, ПрисоединенныеФайлы);
		ИнформацияОФайле = Новый Структура;
		ИнформацияОФайле.Вставить("АдресФайлаВоВременномХранилище", АдресДанныхДополнения);
		ИнформацияОФайле.Вставить("АдресВременногоХранилищаТекста", "");
		ИнформацияОФайле.Вставить("ИмяБезРасширения", Наименование);
		ИнформацияОФайле.Вставить("Расширение", ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла));
		Для Каждого ПрисоединенныйФайл Из ПрисоединенныеФайлы Цикл
			РаботаСФайлами.ОбновитьФайл(ПрисоединенныйФайл, ИнформацияОФайле);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
  ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли

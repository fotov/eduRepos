Процедура Перезаполнить() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатусыВерсийХранилища.ВерсияХранилища КАК ВерсияХранилища,
		|	МАКСИМУМ(СтатусыВерсийХранилища.Период) КАК Период,
		|	МАКСИМУМ(СтатусыВерсийХранилища.ДатаЗаписиУниверсальная) КАК ДатаЗаписиУниверсальная
		|ПОМЕСТИТЬ МаксимальныйПериод
		|ИЗ
		|	РегистрСведений.СтатусыВерсийХранилища КАК СтатусыВерсийХранилища
		|
		|СГРУППИРОВАТЬ ПО
		|	СтатусыВерсийХранилища.ВерсияХранилища
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтатусыВерсийХранилища.Период КАК Период,
		|	СтатусыВерсийХранилища.ДатаЗаписиУниверсальная КАК ДатаЗаписиУниверсальная,
		|	СтатусыВерсийХранилища.ВерсияХранилища КАК ВерсияХранилища,
		|	СтатусыВерсийХранилища.Статус КАК Статус,
		|	СтатусыВерсийХранилища.Ответственный КАК Ответственный,
		|	СтатусыВерсийХранилища.Процесс КАК Процесс,
		|	СтатусыВерсийХранилища.Комментарий КАК Комментарий
		|ИЗ
		|	РегистрСведений.СтатусыВерсийХранилища КАК СтатусыВерсийХранилища
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксимальныйПериод КАК МаксимальныйПериод
		|		ПО СтатусыВерсийХранилища.ВерсияХранилища = МаксимальныйПериод.ВерсияХранилища
		|			И СтатусыВерсийХранилища.Период = МаксимальныйПериод.Период
		|			И СтатусыВерсийХранилища.ДатаЗаписиУниверсальная = МаксимальныйПериод.ДатаЗаписиУниверсальная
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВерсияХранилища,
		|	ДатаЗаписиУниверсальная";
	ТЗ = Запрос.Выполнить().Выгрузить();
	Для Каждого Стр Из ТЗ Цикл
		Стр.Период = '00010101' + Стр.ДатаЗаписиУниверсальная / 1000;
	КонецЦикла;
	Набор = РегистрыСведений.СтатусыВерсийХранилищаСлужебный.СоздатьНаборЗаписей();
	Набор.Загрузить(ТЗ);
	Набор.Записать();
КонецПроцедуры

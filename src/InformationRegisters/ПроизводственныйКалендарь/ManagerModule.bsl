Процедура ЗагрузитьПроизводственныйКалендарь(Год) Экспорт

	Соединение = Новый HTTPСоединение("isdayoff.ru", , , , , , Новый ЗащищенноеСоединениеOpenSSL);
	Запрос = Новый HTTPЗапрос(СтрШаблон("api/getdata?year=%1&delimeter=%2", Формат(Год, "ЧГ="), "%0A"));
	
	Ответ = Соединение.Получить(Запрос);
	
	Если Ответ.КодСостояния < 300 Тогда
		
		День = Дата(Год, 1, 1);
		ТипыДня = СтрРазделить(Ответ.ПолучитьТелоКакСтроку(), Символы.ПС);
		Для каждого ТипДня Из ТипыДня Цикл
		
			Запись = РегистрыСведений.ПроизводственныйКалендарь.СоздатьМенеджерЗаписи();
			Запись.День = День;
			Запись.Выходной = ТипДня = "1";
			
			Запись.Записать();
			
			День = День + 86400;
		
		КонецЦикла; 
		
	Иначе
		
		ТекстОшибки = СтрШаблон(
		"При загрузке производственного календаря возникли ошибки:
		|%1",
		Ответ.ПолучитьТелоКакСтроку());
		
		ВызватьИсключение ТекстОшибки
	
	КонецЕсли; 

КонецПроцедуры

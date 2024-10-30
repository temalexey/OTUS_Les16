﻿#Область ОбработчикиСобытий

// обработка события получения данных выбора
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.СтрокаПоиска = Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		
		//Сфорируем список с предупреждениями
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Склады.Ссылка,
			|	Склады.Наименование,
			|	Склады.НеИспользовать
			|ИЗ
			|	Справочник.Склады КАК Склады";

		Результат = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Структура = Новый Структура("Значение",  ВыборкаДетальныеЗаписи.Ссылка);
			
			//Заполним предупреждение
			Если ВыборкаДетальныеЗаписи.НеИспользовать Тогда
				ТекстПредупреждения = НСтр("ru='Этот склад не должен использоваться!", "ru");
				Структура.Вставить("Предупреждение", ТекстПредупреждения);
			КонецЕсли;
			
			Элемент = ДанныеВыбора.Добавить();
			Элемент.Значение = Структура;
			Элемент.Представление = ВыборкаДетальныеЗаписи.Наименование;
			
		КонецЦикла;
		
	Иначе
		
		//Исключим неиспользуемые из ввода по строке
		Параметры.Отбор.Вставить("НеИспользовать", Ложь);
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПервоначальноеЗаполнение() Экспорт
	
	// Заполнение основного склада
	СкладОбъект = Основной.ПолучитьОбъект();
	СкладОбъект.Собственный = Истина;
	СкладОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти
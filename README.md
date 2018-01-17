# Problem

## ru
Существует список банкоматов.

Географические координаты - свойство банкомта.

Банкоматы можно добавлять и удалять.

Можно отправить запрос с географическими координатами и получить 5 ближайших банкоматов.

Для упрощения можно хранить данные в оперативной памяти.

**Дополнительно:** кешировать результат поиска.

## en
There is a bundle of ATMs.

Geographical coordinates are a property of an ATM.

ATMs can be added and deleted.

You can send a request with geographic coordinates and get the 5 nearest ATMs.

For simplicity, you can store data in RAM.

**Extra task:** use cache for search.

# How to run

$ ruby ./main.rb

# REPL

## ru
Структура команды:
```
имя_команыды [параметры]
```
Параметры отделяются пробелом от команды и `;` друг от друга.

 
`help` подсказка

`exit` завершение работы

`nearest <lat>; <long>` поиск ближайших `<lat>`  и `<long>` - географические координаты

`add <identity>; <lat>; <long>` добавление нового `<identity>` - уникальный идентификатор, `<lat>`  и `<long>` - географические координаты  

`remove <identity>` удаление из списка `<identity>` - уникальный идентификатор  

## en

Command structure:

```
command_name [paramteres]
```
Parameters are separated by a space from the command and `;` from each other.

`help` print help

`exit` exit program

`nearest <lat>; <long>` find nearest ATMs `<lat>`  and `<long>` - geo-coordinates

`add <identity>; <lat>; <long>` add new ATM `<identity>` - unique identifier, `<lat>`  and `<long>` - geo-coordinates  

`remove <identity>` remove ATM from storage `<identity>` - ATM's unique identifier

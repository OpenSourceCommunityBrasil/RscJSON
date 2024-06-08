![Banner_GitHub](https://github.com/OpenSourceCommunityBrasil/RscJSON/assets/53917704/093a23f0-4e81-46de-b3dd-f9ae0997f7b6)

# RscJSON

## What is JSON ?

- JSON (JavaScript Object Notation) is a lightweight data-interchange format.
- It is easy for humans to read and write.
- It is easy for machines to parse and generate.
- It is based on a subset of the JavaScript Programming Language, Standard ECMA-262 3rd Edition - December 1999.
- JSON is a text format that is completely language independent but uses conventions that are familiar to programmers.
- These properties make JSON an ideal data-interchange language.
- You can get more informations on [json.org](http://www.json.org).

```js
{
  "name": "Jon Snow", /* this is a comment */
  "dead": true,
  "telephones": ["000000000", "111111111111"],
  "age": 33,
  "size": 1.83,
  "adresses": [
    {
      "adress": "foo",
      "city": "The wall",
      "pc": 57000
    },
    {
      "adress": "foo",
      "city": "Winterfell",
      "pc": 44000
    }
  ]
}

```
## Parsing a JSON data structure

```pas
var
  js:TRscJSONobject;
begin
  js := TRscJSONobject.Create;
  js.AddPair('valuestring','RSC SISTEMAS');
  js.AddPair('valueInteger',20);
  js.AddPair('valueDouble',5.64);
  js.AddPair('valueInt64',654894874745674);
  js.AddPair('valueDate','2024-05-20');
  js.AddPair('ValueBoolean',true);
  js.AddPair('ValueWideString', 'سیستم های RSC | Συστήματα RSC');
  //objects
  js.AddPair('objString', TRscJSONstring.Generate('OpenSource'));
  js.AddPair('objJSONobject', js);
  //array
  js.AddPair('objArray', TRscJSONArray.Create);
end;

var
  jsary:TRscJSONArray;
begin
  jsary :=  TRscJSONArray.Create;
  //array of objects
  jsary.Add(js);
  //array of string
  jsary.Add('RSC SISTEMAS');
  //array of integer
  jsary.Add(20);
  //array of double
  jsary.Add(5.64);
  //array of int64
  jsary.Add(654894874745674);
  //array of date
  jsary.Add('2024-05-20');
  //array of boolean
  jsary.Add(true);
end;
```

## How to read a property value of an object ?

```pas
var
  js:TRscJSONobject;
  val: Variant;
begin
  val :=  js.GetValue('ValueWideString').AsInteger;
  val :=  js.GetValue('ValueWideString').AsInt64;
  val :=  js.GetValue('ValueWideString').AsString;
  val :=  js.GetValue('ValueWideString').AsWideString;
  val :=  js.GetValue('ValueWideString').AsDouble;
  val :=  js.GetValue('ValueWideString').AsBoolean;
  
  val :=  js.GetValue(0).AsInteger;
  val :=  js.GetValue(0).AsInt64;
  val :=  js.GetValue(0).AsString;
  val :=  js.GetValue(0).AsWideString;
  val :=  js.GetValue(0).AsDouble;
  val :=  js.GetValue(0).AsBoolean;  
  
  //objects
  js  :=  js.GetValue('objJSONobject') as  TRscJSONobject;
  //array
  jsary :=  js.GetValue('objArray') as  TRscJSONArray;
  
end;
```

## How to read a value from an array ?

```pas
var
  jsary:TRscJSONArray;
  val: Variant;
begin
  val :=  jsary.Items[0].AsInteger;
  val :=  jsary.Items[0].AsInt64;
  val :=  jsary.Items[0].AsString;
  val :=  jsary.Items[0].AsWideString;
  val :=  jsary.Items[0].AsDouble;
  val :=  jsary.Items[0].AsBoolean;
```

## Browsing data structure
### Delphi.

Using FOR you can browse item's array or property's object value in the same maner.

```pas
var
  js:TRscJSONobject;
  I: Integer;
begin
  for I := 0 to js.Count - 1 do
	begin
		js.GetValue(I) ...
```

you can also browse the keys and values of an object like this:

```pas
var
  js:TRscJSONobject;
  E: Integer;
begin
  for E := 0 to js.Count - 1 do
    begin
      TRscJSONobjectmethod(js.Items[E]).Name;
      TRscJSONobjectmethod(js.Items[E]).ObjValue.AsString;
    end;
	...
```

### Browsing array items without enumerator

```pas
var
  E: Integer;
  jsary:TRscJSONArray;
begin
  for E := 0 to jsary.Count - 1 do
    begin
      jsary.Items[E] ...
```

## Saving data

```pas
var
  js:TRscJSONobject;
begin
  js.SaveToStream(Stream);
  js.SaveToFile(filename);
  
  // usando class TRscJSON
  TRscJSON.SaveToStream(js, stream);
  TRscJSON.SaveToFile(js, filename);  
  
  ...
```

## Load data

```pas
var
  js:TRscJSONobject;
begin
  js  :=  TRscJSON.LoadFromString(string);
  js  :=  TRscJSON.LoadFromStream(stream);
  js  :=  TRscJSON.LoadFromFile(filename);
  ...
```


## Autor
Roniery Santos Cardoso  
Contatos:  092 41412737 - roniery@rscsistemas.com.br
	
#### Se o Componente lhe ajudar fique a vontade para fazer uma doação para nós, assim continuamos nosso trabalho e sempre estaremos buscando novas formas de contribuir com nossa comunidade.
* Chave Pix: roniery@rscsistemas.com.br

## Grupos para discusão e compartilhamneto de informações sobre Delphi, Pascal e afins.

##### Grupo Delphi Begnner
![Logo_DelphiBeginner_50X50px](https://github.com/OpenSourceCommunityBrasil/RscJSON/assets/53917704/23ed5712-271c-4032-9d81-a9674d1ffcfc)
* [WhatsApp](https://chat.whatsapp.com/KmOB9HQM0JNHtgeU0u1H41)
* [Telegram](https://t.me/DelphiBeginner)
	
## Curta, compartilhe e se increva nas nossas redes sociais.

* [YouTube](https://www.youtube.com/channel/UCh47zPxjlxzsIgRRvZTqmMA)

* [Facebook](https://www.facebook.com/rscsistemas)
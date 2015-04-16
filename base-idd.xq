declare option exist:serialize "method=html media-type=text/html";

declare function local:concatDoc($language, $docum){
    let $nombre := concat("/db/topicos/ubl-idd/UBL-IDD-2.1-",$language,".xml")
return doc( $nombre )/idd/section[@xml:id = concat("UBL-",$docum,"-2.1")]/entry
};

declare function local:rows($document){
    let $filas := for $d in $document
    return 
        <tr>
            <td>{$d/ubl-name/text()}</td>
            <td>{$d/business-terms/text()}</td>
            <td>{$d/definition/text()}</td>
        </tr>
return $filas
};

declare function local:listLang($language){
    let $document := concat ("/db/topicos/ubl-idd/UBL-IDD-2.1-", $language,".xml")
    let $elementos := doc($document)/idd
    let $lista := $elementos/section/@xml:id
    let $list := for $d in $lista
    return
        <option> { string($d)} </option>
return $list
};

declare function local:table($rows){
    let $tabla := <table border ="10">
    <tr>
        <td><b>UBL Name</b></td>
        <td><b>Terms</b></td>
        <td><b>Definition</b></td>
    </tr>
    { $rows }</table>
return $tabla
};

declare function local:htmlInd($table, $list, $doc){
    <html>
    <head>
        <title>UBL - IDD</title>
    </head>
    <body>
    <form action="base-idd.xq" method = "GET">
    <div>
        Ingrese el nombre del documento: <input name='doc'/>
    </div>
    <div>
        <select>
            { $list }
        </select>
        Ingrese el idioma del documento: <input name='lang'/>
    </div>
        <input type = "submit" name ="Enviar"/>
    </form>
    <h2> {$doc} </h2>
    { $table }
    </body>
</html>
};

let $doc := request:get-parameter('doc','Order')
let $lang := request:get-parameter('lang','ES')

let $document := local:concatDoc($lang, $doc)

let $filas := local:rows($document)
    
let $tabla := local:table($filas)

let $lista := local:listLang($lang)

let $htmlIndex := local:htmlInd($tabla, $lista, $doc)

return $htmlIndex

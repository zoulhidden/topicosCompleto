declare option exist:serialize "method=html media-type=text/html";
(: Funcion que recibe como parametros el idioma del documento y la lista de UBL'S :)
declare function local:concatDoc($language, $docum){
    let $nombre := concat("/db/Topicos/UBL-idd/UBL-IDD-2.1-",$language,".xml")
return doc($nombre)/idd/section[@xml:id = concat("UBL-",$docum,"-2.1")]/entry
};
(: Funcion que se encarga de traer el name, definition y business terms en una tabla :)
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
(: Funciones encargadas de hacer y aplicar el dropdown list de los idiomas :)
declare function local:listLang($language){
    let $document := concat ("/db/Topicos/UBL-idd/UBL-IDD-2.1-", $language,".xml")
    let $elementos := doc($document)/idd
    let $lista := $elementos/section/@xml:id
    let $list := for $d in $lista
    return
        <option> {local:fix((string($d)))} </option>
return $list
};

declare function local:fix($s){
    let $sFix := substring-after($s, "UBL-")
    return substring-before($sFix, "-2.1")
};
declare function local:table($rows){
    let $tabla := <table border = "5">
    <tr>
        <td><b>UBL Name </b></td>
        <td><b>Terms</b></td>
        <td><b>Definition</b></td>
    </tr>
    { $rows }</table>
return $tabla
};
(: Funcion encargada de que al momento de cambiar de entidad no sea necesario volver a poner el idioma de preferencia :)
declare function local:htmlInd($table, $list, $doc, $lang){
    <html>
    <head >
        <title>UBL - IDD </title>
    </head>
    <body>
     <form action="base-idd.xq" method = "GET">
     <div>
         Seleccione el nombre del documento:
    </div>
    <div>
    <input type = "hidden" name ="lang" value ="{$lang}"/>  
    <select name="doc">
    {$list}
    </select>
   </div>
        <input type = "submit" name ="Enviar"/>
        
    </form>
    <br>
        <br>
         <a href = "busqueda.xq">Buscar</a>
        </br>
    </br>    
    <h2> {$doc} </h2>
    { $table }
    </body>
</html>
};

let $doc := request:get-parameter('doc','Order')
let $lang := request:get-parameter('lang','EN')

let $document := local:concatDoc($lang, $doc)

let $filas := local:rows($document)
    
let $tabla := local:table($filas)

let $lista := local:listLang($lang)

let $htmlIndex := local:htmlInd($tabla, $lista, $doc, $lang)

return $htmlIndex

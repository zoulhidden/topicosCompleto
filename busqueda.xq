declare option exist:serialize "method=html media-type=text/html";
(: Funcion encargada de capturar en la variable $sFix el nombre del documento  :)
declare function local:fix($s){
    let $sFix := substring-after($s,"UBL-")
    return substring-before($sFix,"-2.1")
};

(: Funcion que recibe como parametros el lenguaje deseado y el termino a bsucar y devuelve los catalogo en los que se encuentra el termino :)
declare function local:body($language2, $list2){
let $body := for $p in $list2
return <div><a href="base-idd.xq?doc={replace($p/text()," ", "")}&amp;lang={$language2}"> { $p/text() }</a></div>
      return $body
};
let $language:= request:get-parameter('lang','EN') 
let $bus := request:get-parameter('busque', 'ID')
(: Variable que se encarga de traer el documento en el idioma seleccionado :)
let $nombre := concat("/db/Topicos/UBL-idd/UBL-IDD-2.1-",$language,".xml")
let $term := doc($nombre)/idd/section/entry/business-terms/text()[. = $bus]/../../../@xml:id
let $list := for $d in $term
                return
                    <term>{local:fix((string($d)))}</term>
                    
let $body := local:body($language, $list)
    return
    <html>
        <title>Resultado de la busqueda:</title>
        <body>
            <form action ="busqueda.xq?lang={$language}" method = "GET">
                <input type ="text" name='busque'/>
                <input type = "submit" name="Enviar"/>
            </form>    
                {$body}
        </body>        
    </html>    
xquery version "3.0";

module namespace ubl="urn:ubl:utils";

declare function ubl:document-list() {
    let $doc := doc( '/db/Topicos/UBL-2.1.xml' )

(: Obtiene la lista de documentos UBL Schema (las secciones) :)
let $sections := $doc/article/section[3]/section[1]/section

(: Obtiene los nombres de los documentos :)
for $id in $sections
    return <document>
        <process>
            { $id/informaltable/tgroup/tbody/row[1]/entry[2]/para/* } 
        </process>
        <doc-name>
            { $id/title/text() }    
        </doc-name>
    </document>
};
(: Funcion encargada de listar los procesos de UBL :)
declare function ubl:process-list(){
    let $list := ubl:document-list()

let $ordenado := distinct-values($list//process/link)

return
    for $p in $ordenado
        return <process> <name>{ $p }</name> {ubl:docs-for-process($list, $p)} </process>
};

declare function ubl:docs-for-process($doc-list, $process-name){
    $doc-list[process//* = $process-name]/doc-name
};

declare function ubl:capitalize($string as xs:string)as xs:string{
    let $tokens:= for $codepoint in string-to-codepoints($string) return codepoints-to-string($codepoint)
    return concat(upper-case($tokens[1]),string-join(subsequence($tokens, 2), ''))
};

declare function ubl:fix-name($name){
    concat("UBL-", replace($name, " ", "-"),"-2.1")
};
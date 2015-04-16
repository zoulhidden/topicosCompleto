xquery version "3.0";
declare option exist:serialize "method=html media-type=text/html";

declare function local:body($lang2, $list2){
    let $body := for $p in $list2
return <div>
        <h2>{$p/name/text()}</h2>{
        for $d in $p/doc-name
            return <div><a href="base-idd.xq?doc={replace($d/text()," ", "")}&amp;lang={$lang2}"> { $d/text() }</a></div>
        }
        </div>
        return $body
};

import module namespace ubl="urn:ubl:utils" at "ubl-utils.xqm";
let $list1 := ubl:process-list()
let $lang1 := request:get-parameter('lang','EN')

return
<html>
    <title> Practica Topicos </title>
    <body>
    <form action="base-doclist.xq? " method = "GET"> 
        <select name="lang">
            <option>DE</option>
            <option>EN</option>
            <option>ES</option>
            <option>IT</option>
            <option>NL</option>
            <option>ZH-CN</option>
            <option>ZH-TW</option>
        </select>
        <input type = "submit" name = "Enviar" value="Seleccionar"/>
    </form>
    {local:body($lang1,$list1)}
    </body>
</html>
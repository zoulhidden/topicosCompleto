xquery version "3.0";

import module namespace ubl="urn:ubl:utils" at "ubl-utils.xqm";

declare option exist:serialize "method=html media-type=text/html";

let $list := ubl:process-list()

let $body := for $p in $list
    return  <div>
                <h2>{$p/name/text()}</h2>{
                    for $d in $p/doc-name
                        return <a href="base-idd.xq?doc={ubl:fix-name($d/text())} "> { $d/text() } </a>
                }
            </div>

return
<html>
    <title> Practica Topicos </title>
    <body>{
        $body
    }</body>
</html>
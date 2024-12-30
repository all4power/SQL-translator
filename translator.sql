CREATE OR REPLACE FUNCTION sqltools.translate (
        lanin char(2), lanout char(2), textin varchar(10000)
    )
    RETURNS varchar(10000)
    LANGUAGE SQL
    BEGIN
        DECLARE txtout varchar(10000);
        SELECT dataout
        into txtout
        FROM JSON_TABLE(QSYS2.HTTP_post('https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&from='||lanin||'&to='||lanout,
        '[{"text":"'||textin||'"}]',
        '{"headers":{"Content-Type":"application/json","Ocp-Apim-Subscription-Key":"SUBSCRIPTIO-KEY","Ocp-Apim-Subscription-Region":"northeurope"}}'),
         'lax $' COLUMNS(dataout varchar(10000) PATH 'lax $[0].translations[0].text')
      );
        RETURN txtout;
    END;
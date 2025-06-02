@echo off
echo Iniciando ejecución del script completo...

sqlcmd -S FLAMING\SQLEXPRESS ^
       -i gd_esquema.Schema.sql,gd_esquema.Maestra.sql,gd_esquema.Maestra.Table.sql,script_creacion_inicial.sql ^
       -a 32767 ^
       -o resultado_output.txt

echo Ejecución finalizada.
pause
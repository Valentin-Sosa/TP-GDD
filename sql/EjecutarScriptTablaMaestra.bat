@echo off
echo Iniciando ejecución del script completo...

sqlcmd -S localhost\SQLSERVER2019 ^
       -i gd_esquema.Maestra.Table.sql,gd_esquema.Maestra.sql,script_creacion_inicial.sql ^
       -a 32767 ^
       -o resultado_output.txt

echo Ejecución finalizada.
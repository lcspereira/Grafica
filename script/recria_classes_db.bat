del /S /Q ..\lib\Grafica\DB
perl script\grafica_create.pl model DB DBIC::Schema Grafica::DB create=static dbi:Pg:dbname=grafica_demo postgres "" 

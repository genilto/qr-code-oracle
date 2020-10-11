-- Pesquisar por Objeto JAVA
SELECT DBMS_JAVA.LONGNAME(OBJECT_NAME) as OBJECT_NAME
     , a.*
  FROM USER_OBJECTS a
 WHERE OBJECT_TYPE like 'JAVA%'
   AND upper(DBMS_JAVA.LONGNAME(OBJECT_NAME)) LIKE '%GENILTO%';

-- Consultar todos os objetos Java
SELECT object_name, object_type, status, timestamp, DBMS_JAVA.LONGNAME(OBJECT_NAME)
  FROM user_objects
 WHERE (object_name NOT LIKE 'SYS_%'
         AND object_name NOT LIKE 'CREATE$%'
         AND object_name NOT LIKE 'JAVA$%'
         AND object_name NOT LIKE 'LOADLOB%')
   AND object_type LIKE 'JAVA %'
 ORDER BY object_type, object_name;

-- Verificar se existe algum erro
SELECT *
  FROM USER_ERRORS;

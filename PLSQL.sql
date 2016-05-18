-- REPASO PL/SQL
--PRACTICA 1
--4 Declarar dos variables. Asignarles valor de host e imprimir. Guardar como .sql.
declare
  v_char varchar2(30);
  v_num number;
begin
  v_char := '42 is the answer';
  v_num := to_number(substr(v_char,1,2));
  dbms_output.put_line(v_char);
  dbms_output.put_line(v_num);
end;
-- PRACTICA 2
--SCOPE
DECLARE
    v_customer    VARCHAR2(50) := 'Womansport';
    v_credit_rating VARCHAR2(50) := 'EXCELLENT';
  BEGIN
    DECLARE
      v_customer  NUMBER(7) := 201;
      v_name  VARCHAR2(25) := 'Unisports';
    BEGIN
    END
 END;  
 
-- 3. Solicitar 2 números, dividir primero por segundo y sumar el segundo. Mostrar resultado
declare
   v_num1 number := &p_num1;
   v_num2 number := &p_num2;
   v_num3 number;
begin
  v_num3 := (v_num1 / v_num2) + v_num2;
  dbms_output.put_line('Resultado: '||v_num3);
end;

--4 Bloque PL/SQL que calcula la compensación total por un año. Solicitar salario y porcentaje de bonus.
-- Si el salario es null convertirlo en cero con nvl.
declare
   v_salary number := &p_salary;
   v_bonus number := &p_bonus;
 
begin
  v_salary := nvl(v_salary,0)*(v_bonus/100)+v_salary;
  dbms_output.put_line(v_salary);
end;   

-- PRACTICA 3
--1. Número máximo de departamento y almacenarlo en una variable. Mostrar resultado.
declare 
     v_dept departments.department_id%type;
begin 
  select max(department_id) 
  into v_dept
  from departments;
  dbms_output.put_line(v_dept);
end;

--2. Modificar el bloque anterior para insertar un nuevo departamento.
declare
     v_dept_number departments.department_id%type;
    
begin
  select max(department_id) +10
  into v_dept_number
  from departments;
  insert into departments values (v_dept_number,'&v_dept_name',null,null);
  commit;
end;

--3. Actualizar location_id para el nuevo departamento añadido antes (Educacion)
--declare

begin
  update departments 
  set location_id = &p_location_id
  where department_name = 'Educacion';
end;

--4. Crear bloque PL/SQL que elimina el departamento creado en antes
begin
  delete from departments
  where department_name = '&p_department_name';
  dbms_output.put_line(sql%rowcount||' rows deleted');
  commit;
end;

--5. Crear la tabla messages con un campo results varchar. Insertar números de 1 a 100 excepto 6 y 8. Commit.
create table messages (results varchar2(60));
begin 
  for i in 1..100 loop
    if i = 6 or i = 8 then
      null;
    else 
      insert into messages values (to_char(i));  
    end if;
    
  end loop;    
  commit; 
  --dbms_output.put_line(sql%rowcount);
end;
select * from messages
delete from messages;

--PRACTICA 4
-- 2. Calcular la comisión de un empleado basado en su salario
declare
   v_bonus number(9,2);
   v_salary employees.salary%type;
begin
  select salary
  into v_salary
  from employees
  where employees.employee_id = &p_employees_id;
  if v_salary < 5000 then v_bonus := .1;
     elsif v_salary between 5000 and 10000 then v_bonus := .15;
           elsif v_salary > 10000 then v_bonus := .2;
                 else v_bonus := null;
  end if;
  v_bonus := v_bonus*v_salary;
  dbms_output.put_line('El empleado '||&p_employees_id||' tiene bonus '||v_bonus);
end;

--3. Crear tabla emp réplica de empleados
create table emp as
select * from employees;
-- Añadir campo stars
alter table emp
add stars varchar2(50);
--4.
-- Crear un bloque pl/sql que recompensa un empleado añadiendo asteriscos en el campo stars por cada
-- 1000$ de salario. Pasar como parámetro el id de empleado.
-- Actualizar la columna stars por el empleado.
declare
   v_asterisk varchar2(600) default null;
   v_num_ast number;  
begin
  -- Calculamos número de asteriscos
  select round(salary/1000) into v_num_ast 
  from emp 
  where employee_id = &p_employee_id;
  -- Añadimos los asteriscos a v_asterisk
  for i in 1..v_num_ast loop
      v_asterisk := v_asterisk||'*';
  end loop;
  -- Actualizamos el campo stars con los asteriscos
  update emp 
  set stars = v_asterisk
  where emp.employee_id = &p_employee_id;
  commit;
end;

-- PRACTICA 5
--1. Decarar un registro basado en la estructura de la tabla countries
-- Pasar el country id con variable de sustitución
-- Mostrar la información del país
declare 
   country_record countries%rowtype;
begin
  select * into country_record
  from countries
  where country_id = upper('&p_country_id');
  
  dbms_output.put_line('CountryID: '||country_record.country_id||' Country Name: '||country_record.country_name);
end;

--2. Bloque PL/SQL para obtener el nombre de cada departamento de la tabla departamentos.
-- Mostrar el nombre de cada departamento incorporando index by table
declare 
   type dept_table_type 
   is table of departments.department_name%type
   index by binary_integer; 
   v_count integer;
   my_dept_table dept_table_type;
   v_deptno departments.department_id%type := &p_dept_id;
begin
  select count(*) into v_count from departments;
  for i in 1..v_count loop
      select departments.department_name
      into my_dept_table(i)
      from departments
      where departments.department_id = v_deptno;
      dbms_output.put_line('Nombre Depto: '||my_dept_table(i)); 
  end loop;

end;

-- solución Oracle
DECLARE
  TYPE dept_table_type is table of departments.department_name%TYPE INDEX BY BINARY_INTEGER;
  my_dept_table dept_table_type;
  v_count       NUMBER(2);
  v_deptno      departments.department_id%TYPE;
BEGIN
  SELECT COUNT(*) INTO v_count FROM departments;

  FOR i IN 1 .. v_count LOOP
    IF i = 1 THEN
      v_deptno := 10;
    ELSIF i = 2 THEN
      v_deptno := 20;
    ELSIF i = 3 THEN
      v_deptno := 50;
    ELSIF i = 4 THEN
      v_deptno := 60;
    ELSIF i = 5 THEN
      v_deptno := 80;
    ELSIF i = 6 THEN
      v_deptno := 90;
    ELSIF i = 7 THEN
      v_deptno := 110;
    END IF;
  
    SELECT department_name
      INTO my_dept_table(i)
      FROM departments
     WHERE department_id = v_deptno;
  
  END LOOP;
  FOR i IN 1 .. v_count LOOP
    DBMS_OUTPUT.PUT_LINE(my_dept_table(i));
  END LOOP;
END;
-- EJEMPLO DE TABLA CON REGISTROS
DECLARE
	
  TYPE PAIS IS RECORD 
  (
    CO_PAIS     NUMBER NOT NULL ,
    DESCRIPCION VARCHAR2(50),
    CONTINENTE  VARCHAR2(20)
  );  
  TYPE PAISES IS TABLE OF PAIS INDEX BY BINARY_INTEGER ;
  tPAISES PAISES;
BEGIN

  tPAISES(1).CO_PAIS := 27;
  tPAISES(1).DESCRIPCION := 'ITALIA';
  tPAISES(1).CONTINENTE  := 'EUROPA';

END;

-- FIN EJEMPLO
--3. Igual que antes pero con tabla de registros
DECLARE
 
  TYPE dept_table_type is table of departments%rowtype INDEX BY BINARY_INTEGER;
  my_dept_table dept_table_type;
  v_count       NUMBER(2) := 7;
  v_deptno      departments.department_id%TYPE;
BEGIN
  
  SELECT COUNT(*) INTO v_count FROM departments;

  FOR i IN 1 .. v_count LOOP
    IF i = 1 THEN
      v_deptno := 10;
    ELSIF i = 2 THEN
      v_deptno := 20;
    ELSIF i = 3 THEN
      v_deptno := 50;
    ELSIF i = 4 THEN
      v_deptno := 60;
    ELSIF i = 5 THEN
      v_deptno := 80;
    ELSIF i = 6 THEN
      v_deptno := 90;
    ELSIF i = 7 THEN
      v_deptno := 110;
    END IF;
  
    SELECT department_id,department_name,location_id
      INTO my_dept_table(i).department_id,my_dept_table(i).department_name, my_dept_table(i).location_id
      FROM departments
     WHERE department_id = v_deptno;
  END LOOP;
  -- Muestra resultados my_depttable
  FOR i IN 1 .. 7 LOOP
    DBMS_OUTPUT.PUT_LINE('ID: '||my_dept_table(i).department_id
    ||' Name: '||my_dept_table(i).department_name
    ||' Location_id: '||my_dept_table(i).location_id);
  END LOOP;
END;

-- PRACTICA 6.

--1y2. Crear tabla top_dogs ocn campo salary number(8,2)
-- Crear bloque pl/sql que determina el máximo de empleados respecto a su salario. n: num de empleados
-- Sin duplicados en los salarios. Almacenar en top_dogs
-- Comprobar para valores n=0 y n>max(empleados)
--create table top_dogs(salary number(8,2));

declare
  v_num_emp     binary_integer := &n;
  v_employee_id employees.employee_id%type;
  v_count       binary_integer;
  v_salary top_dogs.salary%type;
  salary_record top_dogs%rowtype;
begin
  select count(*) into v_count from employees;
  if v_num_emp > 0 and v_num_emp <= v_count then
    
    insert into top_dogs
      select salary
        from employees
       where rownum <= v_num_emp
       order by salary desc;
  
    for c in  
      (select * into salary_record from top_dogs)
    loop  
      dbms_output.put_line('Salario: ' ||c.salary);
    end loop;
  
    delete from top_dogs;
    commit;
  else dbms_output.put_line('El número de empleados no es correcto');
  end if;
end;

--3. Pasar dept_id por variable. Definir bloque pl/sql que obtenga last_name,salary,manager_id de empleados
-- que trabajan en ese departamento.
-- si el salario es < 5000 y manager_id in(101,124) mostrar last_name due for a raise, en otro caso, no due for...
declare
   dept_id employees.department_id%type := &p_dept_id;
   v_text varchar2(50);
begin
  for cur in
      (select last_name,salary,manager_id
          from employees
          where employees.department_id = dept_id) loop

  if cur.salary < 5000 and cur.manager_id in (101,124) then
    v_text := ' Due for a raise';
    else
      v_text := ' Not due for a raise';
  end if;
  dbms_output.put_line(cur.last_name||v_text);    
end loop;
end;


-- PRACTICA 7
-- Hacerlo definiendo el cursor y con open/fetch
--1. Utilizar un cursor para obtener número de departamento,nombre para departamentos con id < 100. Pasar el id 
-- a otro cursor para obtener de la tabla empleados detalles de empleado last_name,job,hiredate, salary
-- cuyo empleado id es menor que 120 y trabaja en dicho departamento
declare 
-- cursores
  cursor dept_cursor is
         select d.department_id, d.department_name
         from departments d
         where d.department_id < 100
         order by d.department_id;
         
         cursor emp_cursor(v_deptno number) is
                select e.last_name, e.job_id, e.hire_date, e.salary
                from employees e
                where e.employee_id < 120 and e.department_id = v_deptno;
                            
begin
  
  for c1 in dept_cursor loop
    dbms_output.put_line('Department_id: '||c1.department_id||' Name: '||c1.department_name);
    for c2 in emp_cursor(c1.department_id) loop
        dbms_output.put_line('Lastname: '||c2.last_name||' JobID: '||c2.job_id||' HireDate: '||c2.hire_date
        ||' Salary: '||c2.salary);
    end loop;  
    dbms_output.put_line(chr(10));
  end loop;
end;

--2. Modificar el ejercicio 4.4. Incorporar cursor utilizando FOR UPDATE y WHERE CURRENT OF en el cursor.
-- FOR UPDATE. Bloquea los registros del cursor para que solo nosotros podamos modificarlos. Se liberan con COMMIT.
-- Parámetros:
-- FOR UPDATE OF tabla/columnaPermite bloquear una columna o una tabla .
-- NOWAIT. Indica a oracle que no espere si otro usuario bloquea la tabla. El control vuelve al programa para 
-- realizar otra tarea.

-- WHERE CURRENT OF cursor. Permite utilizar en un UPDATE o DELETE el where del cursor.
DECLARE
  v_asterisk    varchar2(600) default null;
  v_num_ast     number;
  v_employee_id number := &p_employee_id;
  cursor emp_cursor is
    select round(salary / 1000) sal
      from emp
     where employee_id = v_employee_id
       FOR UPDATE;
BEGIN

  -- Añadimos los asteriscos a v_asterisk
  for emp_record in emp_cursor loop
    for i in 1 .. emp_record.sal loop
      v_asterisk := v_asterisk || '*';
    end loop;
    -- Actualizamos el campo stars con los asteriscos
    update emp set stars = v_asterisk WHERE CURRENT OF emp_cursor;
  v_asterisk := null;
  end loop;
  commit;

END;
select * from emp where emp.employee_id = 100

--PRACTICA 8
-- Bloque pl/sql para seleccionar el nombre de empleado dado un salario
-- Pasar el valor mediante variable de sustitución. 
-- Si el salario devuelve más de una fila -> excepción. Insertar en la tabla messages: "More than one employee 
-- with a salary of <salary>"
-- Si el salario introducido no devuelve ninguna fila -> excepción. Insertar en la tabla messages:
-- No employee with a salary of <salary>
-- Si el salario introducido tiene solo una fila introducir en messages nombre y salario de empleado.
-- Cualquier otra excepción como Other error ocurred.

DECLARE
   v_salary employees.salary%type := &p_salary;
   v_lastname employees.last_name%type;
   v_count binary_integer;
   more_employee exception;
   none_employee exception;
   one_employee exception;
   other exception;

BEGIN
  
  select e.last_name
  into v_lastname
  from employees e
  where e.salary = v_salary;
  insert into messages values (v_lastname||' '||v_salary);
  dbms_output.put_line('One employee '||v_lastname||' with a salary of '' '||v_salary);   
  commit;
-- En EXCEPTION realmente es donde se realiza el ROLLBACK. Esto es un ejemplo.   
EXCEPTION 
   
    when too_many_rows then      -- when too_many_rows then
         insert into messages values ('More than employee with a salary of '||v_salary);
         dbms_output.put_line('More than employee with a salary of '||v_salary);
         --commit;
    when no_data_found then    -- when no_data_found then  
         insert into messages values ('None employee with a salary of '||v_salary);
         dbms_output.put_line('None employee with a salary of '||v_salary);
         --commit;
    when others then
         insert into messages values ('Some other error occurred');
         dbms_output.put_line('Some other error occurred');
         --commit
 
END; 

--2. Modificar 3.3 y añadir excepción

begin
  
  UPDATE departments
  SET location_id = &p_loc
  WHERE department_id = &p_deptno;
  
  commit; 

exception
  when no_data_found then
    dbms_output.put_line('No existe departamento');
   
end;

-- Otra forma. Excepción definida por usuario.
DECLARE
  e_invalid_dept	EXCEPTION;
  v_deptno		departments.department_id%TYPE := &p_deptno;
BEGIN
  UPDATE departments
  SET location_id = &p_loc
  WHERE department_id = &p_deptno;
  COMMIT;
IF SQL%NOTFOUND THEN
    raise e_invalid_dept;
  END IF;
EXCEPTION
  WHEN e_invalid_dept THEN
    dbms_output.put_line('Department '|| TO_CHAR(v_deptno) ||' is an invalid department');
END;

--3. Mostrar el número de empleados que ganan más o menos 100$ del salario. Usar vars sustitución para salario.
-- Si no hay empleado dentro del rango, usar excepción y mensaje indicándolo.
-- Si hay uno o más lanzar excepción e indicar cuántos empleados tienen dicho rango.
-- En otro caso, excepción otro error ha ocurrido.
-- !OJO! Diferenciar que la select devuelve un resultado con 0 y que no devuelva ninguna fila.
declare
   v_salary employees.salary%type := &p_salary;
   v_low_sal employees.salary%type := v_salary - 100;
   v_high_sal employees.salary%type := v_salary + 100;
   v_count number;
   e_more_employees exception;
   e_zero_employees exception;
begin 
  select count(*)
  into v_count
  from employees e
  where e.salary between v_low_sal and v_high_sal;
  
  if v_count = 0 then
    raise e_zero_employees;
  end if;
  if v_count >= 1 then
    raise e_more_employees;
  end if;
  
exception
  when e_zero_employees then
    dbms_output.put_line('No hay empleados con ese salario');  
  when e_more_employees then
    dbms_output.put_line('El salario '||v_salary||' lo tienen '||v_count||' empleados.');
  when others then
    dbms_output.put_line('some error occurred.');   
end;

--PRACTICA 9. PROCEDIMIENTOS.
--1. Crear el procedimiento ADD_JOB para insertar un nuevo trabajo en la tabla JOBS. Proveer title e id.
create or replace procedure add_job(p_jobid in jobs.job_id%type, p_jobtitle in jobs.job_title%type) as
begin
  insert into jobs(job_id,job_title) values (p_jobid,p_jobtitle);
  commit;
end add_job;

--2. Procedimiento para actualizar job_title. Pasar job_id y un nuevo tittulo. Usar excepciones.
create or replace procedure upd_job(p_job_id in jobs.job_id%type, p_job_title in jobs.job_title%type) as
begin
  update jobs
  set jobs.job_title = p_job_title
  where jobs.job_id = p_job_id;
  
  if sql%rowcount = 0 then --sql%notfound
    raise_application_error(-20202,'No job updated');
    rollback;  
  end if;
  
  commit;
end upd_job;

--3. Crear procedimiento DEL_JOB para eliminar un trabajo de la tabla JOBS.
-- Incluir las excepciones necesarias si no se borra trabajo.
create or replace procedure del_job(p_jobid in jobs.job_id%type) as
begin
  delete from jobs
  where job_id = p_jobid;
  
  if sql%notfound then
    raise_application_error(-20203,'No jobs deleted');
    rollback;
  end if;
  commit;
end del_job;

--4. Crear procedimiento query_emp para consultar employees, obteniendo salary y jobid de un empleado segun su id
create or replace procedure query_emp(p_empid  in employees.employee_id%type,
                                      p_salary out employees.salary%type,
                                      p_jobid  out employees.job_id%type) is
begin
  select e.job_id, e.salary
    into p_jobid, p_salary
    from employees e
   where e.employee_id = p_empid;

exception
  when no_data_found then
    raise_application_error(-20203, 'No data found');
  when too_many_rows then
    raise_application_error(-20203, 'Too many rows');
end query_emp;


-- PRACTICA 10. FUNCIONES.
--1. Crear una función Q_JOB que devuelva job_title a una variable host
create or replace function q_job(p_job_id in jobs.job_id%type) return jobs.job_title%type is
v_job_title jobs.job_title%type;
begin
  select job_title
  into v_job_title
  from jobs
  where job_id = p_job_id;
  
  return (v_job_title);

end q_job;
--2. Crear función annual_comp que devuelva el salario anual aceptando dos parametros: salario y comisión. 
-- Debe aceptar valores nulos. salario anual = (salary*12) + (commission_pct*salary*12)
create or replace function annual_comp(v_salary in employees.salary%type, v_commission in employees.commission_pct%type) 
return number
is
v_annual_salary employees.salary%type;
begin
  if (v_salary is not null) and (v_commission is not null) then
     v_annual_salary := (v_salary*12) + (v_commission*v_salary*12);
  else
     v_annual_salary := 0.0;
  end if;
  return v_annual_salary;
end annual_comp;


--3. Crear procedimiento new_emp que inserta un nuevo empleado en employees. 
-- Crear otra función valid_deptid que chequea si el departamento id introducido para el nuevo empleado existe.
-- Función valid_deptid
create or replace function valid_deptid(p_deptid in departments.department_id%type) return boolean
is
v_dummy number;
begin
  select departments.department_id
  into v_dummy
  from departments
  where departments.department_id = p_deptid;
  
  return (sql%rowcount = 1);
  /*return (true);
exception
  when no_data_found then
    return (false);*/
end valid_deptid;

create or replace procedure new_emp(
  --v_employee_id employees.employee_id%type,
  v_first_name in employees.first_name%type,
  v_last_name in employees.last_name%type,
  v_email in employees.email%type,
  v_phone_number in employees.phone_number%type,
  --v_hire_date in employees.hire_date%type,
  v_job_id in employees.job_id%type default 'SA_REP',
  v_salary in employees.salary%type default 1000,
  v_commission_pct in employees.commission_pct%type default 0,
  v_manager_id in employees.manager_id%type default 145,
  p_deptid in employees.department_id%type default 30
)is

begin
  if valid_deptid(p_deptid) then
    insert into employees
      (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
    values
      (employees_seq.nextval, v_first_name, v_last_name, v_email, v_phone_number,sysdate, v_job_id, v_salary, v_commission_pct, v_manager_id, p_deptid);
    commit;  
  else 
    raise_application_error(-20203,'El departamento no es válido');
  end if;

end new_emp;

--PRACTICAS 11
--1. Buscar una función o procedimiento en el diccionario. 
-- La vista user_source contiene el código de los objetos almacenados por el usuario. 
-- El campo text contiene el texto.

SELECT 'CREATE OR REPLACE ', 0 line
FROM   DUAL
UNION
SELECT text, line
FROM   USER_SOURCE
WHERE  name IN ('NEW_EMP', 'VALID_DEPTNO')
ORDER BY line;

--PRACTICAS 12. PAQUETES.
--1. Crear un paquete JOB_PACK. Contiene add_job,upd_job,del_job y la función q_job.
create or replace package job_pack is
  procedure add_job(P_JOBID    in jobs.job_id%type,
                    P_JOBTITLE in jobs.job_title%type);
  procedure upd_job(p_job_id    in jobs.job_id%type,
                    p_job_title in jobs.job_title%type);
  procedure del_job(p_jobid jobs.job_id%type);
  function q_job(p_job_id jobs.job_id%type) return varchar2;
end job_pack;

-- BODY JOB_PACK

create or replace package body job_pack is
  -- Procedimiento add_job para añadir un trabajo a la tabla jobs
  procedure add_job(p_jobid    in jobs.job_id%type,
                    p_jobtitle in jobs.job_title%type) as
  begin
    insert into jobs (job_id, job_title) values (p_jobid, p_jobtitle);
    commit;
  end add_job;

  --Procedimiento para actualizar job_title. Pasar job_id y un nuevo tittulo. Usar excepciones.
  procedure upd_job(p_job_id    in jobs.job_id%type,
                    p_job_title in jobs.job_title%type) as
  begin
    update jobs
       set jobs.job_title = p_job_title
     where jobs.job_id = p_job_id;
  
    if sql%rowcount = 0 then
      --sql%notfound
      raise_application_error(-20202, 'No job updated');
      rollback;
    end if;
  
    commit;
  end upd_job;

  --Crear procedimiento DEL_JOB para eliminar un trabajo de la tabla JOBS.
  -- Incluir las excepciones necesarias si no se borra trabajo.
  procedure del_job(p_jobid in jobs.job_id%type) as
  begin
    delete from jobs where job_id = p_jobid;
  
    if sql%notfound then
      raise_application_error(-20203, 'No jobs deleted');
      rollback;
    end if;
    commit;
  end del_job;

  -- Función q_job
 function q_job(p_job_id in jobs.job_id%type) return jobs.job_title%type is
    v_job_title jobs.job_title%type;
  begin
    select job_title into v_job_title from jobs where job_id = p_job_id;
  
    return(v_job_title);
  
  end q_job;

end job_pack;

--2. Crear un paquete con construcciones privadas y publicas
-- Especificación del paquete
create or replace package emp_pack is
procedure new_emp(
  --v_employee_id employees.employee_id%type,
  v_first_name in employees.first_name%type,
  v_last_name in employees.last_name%type,
  v_email in employees.email%type,
  v_phone_number in employees.phone_number%type,
  --v_hire_date in employees.hire_date%type,
  v_job_id in employees.job_id%type default 'SA_REP',
  v_salary in employees.salary%type default 1000,
  v_commission_pct in employees.commission_pct%type default 0,
  v_manager_id in employees.manager_id%type default 145,
  p_deptid in employees.department_id%type default 30
);
end emp_pack;

-- Cuerpo del paquete
create or replace package body emp_pack is
function valid_deptid(p_deptid in departments.department_id%type) return boolean
is
v_dummy number;
begin
  select departments.department_id
  into v_dummy
  from departments
  where departments.department_id = p_deptid;
  
  return (sql%rowcount = 1);
  /*return (true);
exception
  when no_data_found then
    return (false);*/
end valid_deptid;

procedure new_emp(
  --v_employee_id employees.employee_id%type,
  v_first_name in employees.first_name%type,
  v_last_name in employees.last_name%type,
  v_email in employees.email%type,
  v_phone_number in employees.phone_number%type,
  --v_hire_date in employees.hire_date%type,
  v_job_id in employees.job_id%type default 'SA_REP',
  v_salary in employees.salary%type default 1000,
  v_commission_pct in employees.commission_pct%type default 0,
  v_manager_id in employees.manager_id%type default 145,
  p_deptid in employees.department_id%type default 30
)is

begin
  if valid_deptid(p_deptid) then
    insert into employees
      (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
    values
      (employees_seq.nextval, v_first_name, v_last_name, v_email, v_phone_number,sysdate, v_job_id, v_salary, v_commission_pct, v_manager_id, p_deptid);
    commit;  
  else 
    raise_application_error(-20203,'El departamento no es válido');
  end if;

end new_emp;


end emp_pack;

-- 3. Crear un paquete chk_pack que contiene los procedimientos:
-- chk_hiredate. Chequea si la fecha de contratación de un de un empleado esta en [SYSDATE - 50 years, SYSDATE + 3 months]
-- Si la fecha no es válida lanzar excepción. No tener en cuenta la hora en la fecha. 
-- No admite valores nulos como fechas.
-- chk_dept_mgr. Chequea la combinación de departamento y manager para un empleado. Excepción si no válida.
-- Toma como parámetros empleado id y manager id. Chequear que ambos trabajan en el mismo depto y que
-- el jobtitle del manager es manager (MAN).
-- ESPECIFICACION
create or replace package chk_pack is
procedure chk_hiredate(p_hiredate in employees.hire_date%type);
procedure chk_dept_mgr(p_empid in employees.employee_id%type,
                       p_mgr in employees.manager_id%type);
end chk_pack;
   
-- CUERPO
create or replace package body chk_pack is
procedure chk_hiredate(p_hiredate in employees.hire_date%type) is
  v_low date := add_months(sysdate,-(50*12));
  v_high date := add_months(sysdate,3); 

begin 
  if (trunc(p_hiredate) not between v_low and v_high) or (p_hiredate is null) then
     raise_application_error(-20203,'La fecha no está en el rango');
  end if;
end chk_hiredate;

procedure chk_dept_mgr(p_empid in employees.employee_id%type,
                       p_mgr in employees.manager_id%type) is
--variables
v_managerid employees.manager_id%type;
v_edeptid employees.department_id%type;
v_mdeptid employees.department_id%type;

begin
 begin
   -- Obtenemos deptid y managerid del empleado pasado por parámetro 
   select e.department_id, e.manager_id
   into v_edeptid,v_managerid
   from employees e
   where e.employee_id = p_empid;
     
 exception
   when no_data_found then
     raise_application_error(-20203,'No existe el empleado');
 end;
 
 begin
   -- Obtenermos deptid del manager pasado por parametro y que su jobid sea manager
   select e.department_id
   into v_mdeptid
   from employees e
   where e.department_id = v_deptid
   and e.employee_id = p_mgr 
   and job_id like '%MAN';  
     
 exception
   when no_data_found then
     raise_application_error(-20204,'No existe el manager');  
 end;
  
end chk_dept_mgr;

end chk_pack;
  
-- PRACTICA 13 MORE PACKAGES
--1. Crear paquete over_load. Crear dos funciones de nombre print_it. 
--Parámetros : una fecha o cadena e imprime fecha o número dependiendo de cómo se invoque.
-- Formato fecha : entrada DD-MON--YY salida FmMonth,dd yyyy. formato número 999,999.00
-- CABECERA
create or replace package over_load is
function print_it(p_arg in date) return varchar2;
function print_it(p_arg in varchar2) return number;
end over_load;

--CUERPO
create or replace package body over_load is
function print_it p_arg in date) return varchar2
v_cadena varchar2;
begin 
v_cadena := to_char(p_arg,'FmMonth, dd yyyy')
return v_cadena;
end print_it;

function print_it(p_arg in varchar2) return number is
v_numero number;
begin
v_numero := to_number(p_arg,'999,999.00')
return v_numero;
end print_it;

end over_load;

--2. Crear un nuevo paquete llamado CHECK_PACK para implementar una regla de negocio.
-- Crear procedimiento CHK_DEPT_JOB para verificar una combinación dada de deptid y job válida.
-- Debe ser una combinación que exista en la tabla empleados.
-- Utilizar una tabla para almacenar el departamento y job válidos.
-- La tabla necesita ser completada una sola vez
-- Lanzar una excepción si la combinación no es válida.

-- cabecera
create or replace package check_pack is
procedure chk_dept_job(p_deptid in employees.department_id%type,
                       p_jobid in employees.job_id%type);
end check_pack;

-- cuerpo
create or replace package body check_pack is

i number := 0;
-- Cursor que obtiene departamentoid y jobid
cursor emp_cur is
       select department_id, job_id
       from employees
-- Definimos tabla con un índice
type emp_table_type is table of emp_cur%rowtype index by binary_integer;
deptid_job emp_table_type;


-- Procedimiento
procedure chk_dept_job(p_deptid in employees.department_id%type,
                       p_jobid in employees.job_id%type) is

begin
-- Recorre los elementos de la tabla y los compara con los parámetros.
-- Si son iguales sale del procedimiento,sino, finaliza loop y lanza excepción  
for k in deptid_job.first .. deptid_job.last loop
  if p_deptid = deptid_job(k).department_id  and p_deptid = deptid_job(k).job_id then 
       return; -- SALE DEL PROCEDIMIENTO -- EXIT SALE DEL LOOP!!!
  end if;

end loop;

raise_application_error(-20230,'No coinciden dept y job');

end chk_dept_job;

-- procedimiento one-time-only
-- INICIALIZA LA TABLA deptid_job CON LOS REGISTROS DEL CURSOR
begin 
  for emp_rec in emp_cur loop
    deptid_job(i) := emp_rec;
    i := i + 1;
  end loop;

end chk_pack;
 
-- PRACTICA 14. ORACLE SUPPLIED PACKAGES
-- DBMS_SQL, DBMS_DDL, EXECUTE IMMEDIATE, DBMS_JOB.
-- Crear procedimiento drop_table que elimina la tabla especificada en el parámetro de entrada
-- Utilizar dbms_sql o execute immediate
-- DBMS_SQL: OPEN_CURSOR - PARSE(dyn_cursor number,'SQL',DBMS_SQL.NATIVE) - CLOSE_CURSOR
-- EXECUTE IMMEDIATE. EXECUTE_IMMEDIATE 'SQL'
-- Ejemplo DBMS_SQL
CREATE OR REPLACE PROCEDURE drop_table
  (p_table_name IN VARCHAR2)
IS
  dyn_cur NUMBER;
  dyn_err VARCHAR2(255);
BEGIN
  dyn_cur := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(dyn_cur, 'DROP TABLE '||
    			p_table_name, DBMS_SQL.NATIVE);
  DBMS_SQL.CLOSE_CURSOR(dyn_cur);
EXCEPTION
  WHEN OTHERS THEN dyn_err := SQLERRM;
    DBMS_SQL.CLOSE_CURSOR(dyn_cur);
    RAISE_APPLICATION_ERROR(-20600, dyn_err);
END drop_table;

-- Ejemplo con EXECUTE_IMMEDIATE (DEBE ESTAR EN MAYÚSCULAS)
create table emp_dump as
select * from employees;

CREATE or replace PROCEDURE DROP_TABLE2
  (p_table_name  IN  VARCHAR2)
IS
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ' || p_table_name;
END drop_table2;

--3. Crear procedimiento llamado ANALYZE_OBJECT que analiza un objeto pasado por parámetro
-- Utilizar DBMS_DDL y el método COMPUTE.
create or replace procedure analyze_object(p_object_type varchar2,
                                           p_object_name varchar2) is
begin
  dbms_ddl.analyze_object(type => p_object_type,
                               schema => user,
                               name => UPPER(p_object_name),
                               'COMPUTE'
                               );

end analyze_object;
 
--4. Definir un  trabajo que analice la tabla departments en 5 minutos (5/24*60).
VARIABLE jobno NUMBER

EXECUTE DBMS_JOB.SUBMIT(:jobno,           
       'ANALYZE_OBJECT (''TABLE'', ''DEPARTMENTS'');', 
        SYSDATE + 1/288)
PRINT jobno

--5. Uso de UTL_FILE. Crear procedimiento CROSS_AVGSAL que genera fichero de texto de
-- empleados que han excedido la media de salario de su departamento.
-- Aceptar 2 parámetros: directorio_salida y nombre_fichero
create or replace procedure cross_avgsal(p_filedir   in varchar2,
                                         p_filename1 in varchar2) is
  v_fh_1 UTL_FILE.FILE_TYPE;
  cursor cross_avg is
    select e.last_name, e.department_id, salary
      from employees e
     where e.salary >
           (select avg(salary) from employees group by e.department_id)
     order by e.department_id;

begin
  v_fh_1 := UTL_FILE.FOPEN(p_filedir, p_filename1, 'w');
  UTL_FILE.PUTF(v_fh_1, 'Employees with more than average salary:\n');
  UTL_FILE.PUTF(v_fh_1, 'REPORT GENERATED ON  %s\n\n', SYSDATE);
  FOR v_emp_info IN cross_avg LOOP
    UTL_FILE.PUTF(v_fh_1,
                  '%s   %s \n',
                  RPAD(v_emp_info.last_name, 30, ' '),
                  LPAD(TO_CHAR(v_emp_info.salary, '$99,999.00'), 12, ' '));
  END LOOP;
  UTL_FILE.NEW_LINE(v_fh_1);
  UTL_FILE.PUT_LINE(v_fh_1, '*** END OF REPORT ***');
  UTL_FILE.FCLOSE(v_fh_1);
  
EXCEPTION
  WHEN UTL_FILE.INVALID_FILEHANDLE THEN
    RAISE_APPLICATION_ERROR (-20001, 'Invalid File.');
    UTL_FILE.FCLOSE_ALL;
  WHEN UTL_FILE.WRITE_ERROR THEN
    RAISE_APPLICATION_ERROR (-20002, 
                              'Unable to write to file');
    UTL_FILE.FCLOSE_ALL;

end cross_avgsal;

-- PRACTICA 15
--1 Crear la tabla PERSONNEL. Insertar dos filas. Usar empty_clob y null para blob.
create table personnel
(
id number(6) constraint personnel_id_pk primary key,
last_name varchar2(35),
review clob,
picture blob
);

insert into personnel values(2034,'Allen',empty_clob(),null);
insert into personnel values(2035,'Bond',empty_clob(),null);

--2 Crear la tabla review_table. Contiene la revisión anual para cada empleado.
create table review_table 
(
employee_id number,
ann_review varchar2(2000)
);

insert into review_table
values (2034, 'Buen trabajo. Recomendación de incremento salario 500€');
insert into review_table
values (2035, 'Excelente trabajo. Recomendación de incremento salario 1000€');

--4 Actualizar la tabla personnel, en concreto el campo review. 
-- Completar clob para la primera fila con update
update personnel
set review = (select ann_review from review_table where employee_id = 2034)
where last_name = 'Allen';

-- Completar la segunda fila con dbms_lob
/*
DBMS_LOB.WRITE (
   lob_loc  IN OUT  NOCOPY CLOB   CHARACTER SET ANY_CS,
   amount   IN             BINARY_INTEGER,
   offset   IN             INTEGER,
   buffer   IN             VARCHAR2 CHARACTER SET lob_loc%CHARSET);
*/
declare
  lobloc clob;
  text   varchar2(2000);
  amount number;
  offset integer;
begin
  select ann_review into text from review_table where employee_id = 2035;
  select review
    into lobloc
    from personnel
   where last_name = 'Bond'
     for update;
  offset := 1;
  amount := length(text);
  dbms_lob.write(lobloc, amount, offset, text);
end;

--5. Crear un procedimiento que añade un localizador al bfile picture de la tabla countries
-- Cargar en la tabla countries un localizador de la imagen en el campo picture para 
-- todos paises con region_id = 1. Crear objeto directorio COUNTRY_PIC
-- añadimos campo picture a la tabla countries
alter table countries add picture bfile;

-- Crear un procedimiento llamado load_country_image que lee un localizador en 
-- la columna picture, debe testear si el fichero existe (dbms_lob.fileexists) sino
-- mostrar mensaje.
/*
BFILENAME(directorio,nombre_fichero). Devuelve un localizador de un bfile.
Ejemplo:
CREATE DIRECTORY media_dir AS '/demo/schema/product_media';

INSERT INTO print_media (product_id, ad_id, ad_graphic)
   VALUES (3000, 31001, 
      BFILENAME('MEDIA_DIR', 'modem_comp_ad.gif'));

DBMS_LOB.FILEEXISTS(file_loc):
FUNCTION DBMS_LOB.FILEEXISTS
   ( file_loc  IN  BFILE )
   RETURN INTEGER;
The file_loc parameter is the name of the file locator. The function returns one of the following values:

0 The file does not exist
 
1 The specified file exists
Exceptions

One of the following exceptions may be raised if the file_loc parameter contains an improper value (e.g., NULL):

DBMSLOB. NOEXIST_DIRECTORY
DBMSLOB. NOPRIV_DIRECTORY
DBMSLOB. INVALID_DIRECTORY
*/
create or replace procedure load_country_image(p_loc_dir varchar2) is
  -- p_loc_dir = a directorio emp_dir
  v_filename      varchar2(200);
  v_file          bfile;
  v_record_number number := 0;
begin

  for c in (select country_id, picture from countries where region_id = 1 for update) loop
    v_filename := c.country_id || '.tif';
    v_file     := bfilename(p_loc_dir, v_filename); -- devuelve localizador del fichero
  
    if dbms_lob.fileexists(v_file) = 1 then
      -- Si el fichero existe
      dbms_lob.fileopen(v_file); -- abrimos fichero
      --c.picture := v_file; -- insertamos localizador en picture
      UPDATE countries
	      SET picture = bfilename(p_loc_dir, v_filename)
	      WHERE region_id = 1;
      dbms_output.put_line('Fichero existe y cargado' || v_filename);
      dbms_lob.fileclose(v_file); -- cerramos fichero
      v_record_number := v_record_number + 1;
    else
      dbms_output.put_line('Fichero no existe' || v_filename);
    end if;
  
  end loop;
  DBMS_OUTPUT.PUT_LINE('TOTAL FICHEROS ACTUALIZADOS: ' || v_record_number);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_LOB.FILECLOSE(v_file);
    DBMS_OUTPUT.PUT_LINE('Program Error Occurred: ' || to_char(SQLCODE) ||
                         SQLERRM);
end load_country_image;







CREATE OR REPLACE PROCEDURE load_country_image (p_file_loc IN VARCHAR2)
IS
  v_file           BFILE;
  v_filename       VARCHAR2(40);
  v_record_number  NUMBER;
  v_file_exists    BOOLEAN;
  CURSOR country_pic_cursor IS
    SELECT country_id
      FROM countries
      WHERE region_id = 1
      FOR UPDATE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('LOADING LOCATORS TO IMAGES...');
  FOR country_record IN country_pic_cursor LOOP
    v_filename := country_record.country_id || '.tif';
    v_file := bfilename(p_file_loc, v_filename);
    v_file_exists := (DBMS_LOB.FILEEXISTS(v_file) = 1);
    IF v_file_exists THEN
     DBMS_LOB.FILEOPEN(v_file);
     UPDATE countries
       SET picture = bfilename(p_file_loc, v_filename)
       WHERE CURRENT OF country_pic_cursor;
     DBMS_OUTPUT.PUT_LINE('LOADED LOCATOR TO FILE: '|| v_filename ||
       ' SIZE: ' || DBMS_LOB.GETLENGTH(v_file));
     DBMS_LOB.FILECLOSE(v_file);
     v_record_number := country_pic_cursor%ROWCOUNT;
    ELSE
     DBMS_OUTPUT.PUT_LINE('Can not open the file ' || v_filename);
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('TOTAL FILES UPDATED: ' || v_record_number);   
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_LOB.FILECLOSE(v_file);
      DBMS_OUTPUT.PUT_LINE('Program Error Occurred: ' 
                             || to_char(SQLCODE) || SQLERRM);
END load_country_image;
update countries set picture = null;
select country_id,picture, dbms_lob.getlength(picture) 
  from countries
where region_id = 1;

--16. TRIGGERS
--1.Crear un procedimiento almacenado secure_dml que evita que DML se ejecuten fuera de
-- horario de oficina (9 a 5:30) devolviendo mensaje "solo se hacen cambios en horario"

CREATE OR REPLACE PROCEDURE secure_dml as

BEGIN
  IF TO_CHAR(SYSDATE,'HH24:MI') NOT BETWEEN '08:45' AND '16:45' 
    OR TO_CHAR(SYSDATE,'DAY') IN ('SAB','DOM') THEN
       RAISE_APPLICATION_ERROR(-20300,'No puedes hacer cambios fuera de horario de oficina.');
  END IF;
END secure_dml;

-- Crear un trigger secure_prod que llame al procedimiento anterior
CREATE OR REPLACE TRIGGER secure_prod
BEFORE INSERT OR UPDATE OR DELETE ON jobs
BEGIN
  secure_dml;
END secure_prod;

-- Test. Cambiar horario de oficina en el procedimiento
insert into jobs(job_id,job_title) values ('HR_MAN2','Human Resource Manager2');

--3. Empleados deben recibir un incremento automático de salario si el salario 
-- mínimo para un trabajo es incrementado
-- Crear procedimiento almacenado upd_emp_sal que actualice la cantidad de salario.
-- Acepta dos parámetros jobid y nuevo mínimo salario
CREATE OR REPLACE PROCEDURE upd_emp_sal (p_jobid in jobs.job_id%type,                                        p_newsalary in jobs.min_salary%type) 
IS
BEGIN
  UPDATE employees
  SET salary = p_newsalary 
  WHERE job_id = p_jobid AND salary < p_newsalary; 
END upd_emp_sal; 

-- Crear un trigger update_emp_salary en la tabla jobs que invoca al procedimiento anterior
-- si el salario mínimo en la tabla jobs es actualizado para un jobid
CREATE OR REPLACE TRIGGER update_emp_salary 
AFTER UPDATE OF min_salary ON jobs
FOR EACH ROW

BEGIN 
  upd_emp_sal(:NEW.JOB_ID,:NEW.MIN_SALARY);
END update_emp_salary;


-- Test
select last_name, first_name, salary
from employees
where job_id = 'IT_PROG';

update jobs
set min_salary = 5000
where job_id = 'IT_PROG'

select last_name, first_name, salary
from employees
where employee_id = 107;

-- PRACTICA 17. MORE TRIGGERS.
/* Reglas de negocio a aplicar a EMPLOYEES y DEPARTMENTS
Para implementarlas: usar constraints o triggers.
Se indica un paquete. Debe contener cualquier procedimiento o función usado en un trigger.
Regla1. SA_REP y SA_MAN siempre reciben comisión. El resto no reciben comisión.
Regla2. La tabla EMPLOYEES  debe contener solo un presidente.
Regla3. Un empleado nunca debería ser manager de más de 15 empleados.
Regla4. Salarios solo pueden ser incrementados. Nunca decrementados.
Regla5. Si un departamento se mueve a otra localización cada empleado de dicho departamento
recibe un incremento de salario del 2%.
*/
-- Especificación
CREATE OR REPLACE PACKAGE mgr_constraints_pkg
IS
  PROCEDURE check_president;
  PROCEDURE check_mgr;
  PROCEDURE new_location(p_deptid IN departments.department_id%TYPE);
  new_mgr employees.manager_id%TYPE := NULL;
END mgr_constraints_pkg;


-- Cuerpo
CREATE OR REPLACE PACKAGE BODY mgr_constraints_pkg
IS
-- Regla 1
-- Constraint

-- Regla 2
PROCEDURE check_president IS
v_count number;
BEGIN
  SELECT COUNT(*) INTO v_count FROM employees WHERE job_id = 'AD_PRES';
  IF v_count <> 1 THEN
    DBMS_OUTPUT.put_line('Número de presidentes <> 1');
  END IF;
END check_president;

-- Regla 3

PROCEDURE check_mgr IS

v_count number;
BEGIN
  IF new_mgr is not null THEN
    select count(e.manager_id) num_emp 
    into v_count
    from employees e join employees m on (e.manager_id = m.employee_id)
    where new_mgr = m.employee_id
    group by m.employee_id;
  END IF;
  IF v_count > 15 THEN
     RAISE_APPLICATION_ERROR(-20300,'Manager con más de 15 empleados'||new_mgr);
  END IF;

END check_mgr;

-- Regla 4



-- Regla 5
PROCEDURE new_location(p_deptid IN departments.department_id%TYPE) IS
BEGIN
  UPDATE employees
  SET salary = salary*1.02
  WHERE department_id = p_deptid;
END new_location;

END mgr_constraints_pkg;




-- TRIGGERS/CONSTRAINTS
-- Regla1
ALTER TABLE employees 
ADD CONSTRAINT emp_comm_chk
CHECK (commission_pct > 0 AND job_id IN ('SA_MAN','SA_REP')) NOVALIDATE;

-- Test
insert into employees (employee_id,last_name,job_id,email,hire_date,commission_pct) 
values (500,'Martinez','SA_REP','@martinez',sysdate,0);

-- Regla2
CREATE OR REPLACE TRIGGER trg_rule2 
AFTER INSERT OR UPDATE OF job_id ON employees
BEGIN
  mgr_constraints_pkg.check_president;
END trg_rule2;

-- Test
INSERT INTO employees
 		(employee_id, last_name, first_name, email, job_id,   
  		 hire_date, salary, department_id)
		VALUES (400,'Harris','Alice', 'AHARRIS', 'AD_PRES',
        	   SYSDATE, 20000, 20);


-- Regla3. Existe problema de tabla mutante. Procedimiento y trigger usan la tabla employees.
-- Para evitarlo se usa una variable global.
CREATE OR REPLACE TRIGGER set_mgr
AFTER INSERT or UPDATE of manager_id on employees
FOR EACH ROW
BEGIN
     -- To get round MUTATING TABLE ERROR
  mgr_constraints_pkg.new_mgr := :NEW.manager_id;
END set_mgr;
-- Para evitar problema de tabla mutante SE EJECUTA UN TRIGGER DE ESTAMENTO

CREATE OR REPLACE TRIGGER trg_rule3
AFTER INSERT OR UPDATE OF manager_id ON EMPLOYEES
--FOR EACH ROW Evitamos error de tabla mutante
begin
  mgr_constraints_pkg.check_mgr;
  mgr_constraints_pkg.new_mgr := NULL;
end trg_rule3;

-- Test

INSERT INTO employees
 (employee_id, last_name, first_name, email, job_id,   
  hire_date, salary, manager_id, department_id)
VALUES (401,'Johnson','Brian', 'BJOHNSON', 'SA_MAN',
        SYSDATE, 11000, 100, 80);

SELECT count(*)
FROM employees
WHERE manager_id = 100;

INSERT INTO employees
  		(employee_id, last_name, first_name, email, job_id,
   		 hire_date, salary, manager_id, department_id)
	 VALUES (404,'Kellogg','Tony', 'TKTKELLOGG', 'ST_MAN',
            SYSDATE, 7500, 100, 50);

INSERT INTO employees
  		(employee_id, last_name, first_name, email, job_id,
   		 hire_date, salary, manager_id, department_id)
	 VALUES (405,'Kellogg','Tony', 'TKKTKELLOGG', 'ST_MAN',
            SYSDATE, 7500, 100, 50);




-- Regla4
CREATE OR REPLACE TRIGGER trg_rule4
BEFORE UPDATE OF salary ON employees
FOR EACH ROW
WHEN (NEW.salary < OLD.salary)
BEGIN
  RAISE_APPLICATION_ERROR(-20002,'Salary may not be reduced');
END trg_rule4;

--Regla5
CREATE OR REPLACE TRIGGER trg_rule5
BEFORE UPDATE OF location_id ON departments
FOR EACH ROW
BEGIN
  mgr_constraints_pkg.new_location(:old.department_id);
END trg_rule5;

-- Test
 SELECT last_name, salary, department_id
      FROM   employees
      WHERE  department_id = 90;
      
UPDATE departments
       SET    location_id = 1600
       WHERE  department_id = 90;
       
SELECT last_name, salary, department_id
       FROM   employees
       WHERE  department_id = 90;


-- gere uma consulta para saber os 5 primeiros tipos de generos de filmes mais alugados

select *
from inventory;

select *
from rental;

select *
from film_category;

select *
from category;

select  CC.name, COUNT(CC.name)
from rental R
    INNER join inventory I on R.inventory_id = I.inventory_id 
    inner join film_category FC on I.film_id = FC.film_id
    inner join category CC on FC.category_id = CC.category_id
    WHERE R.customer_id = 77
    GROUP BY CC.name  -- group by so funciona com colunas que nao são unicas
    ORDER BY 2 desc
    LIMIT 5;

    create Procedure lista_top (codigo int)
 begin
     select  CC.name, COUNT(CC.name)
        from rental R
        INNER join inventory I on R.inventory_id = I.inventory_id 
        inner join film_category FC on I.film_id = FC.film_id
        inner join category CC on FC.category_id = CC.category_id
        WHERE R.customer_id = codigo
        GROUP BY CC.name  -- group by so funciona com colunas que nao são unicas
        ORDER BY 2 desc
        LIMIT 5;
 END;

 call lista_top(30);


-- desenvolva uma procedure para listar os clientes, valor pago pro gerente, nome do genrente, comissao, Sendo 5% para o gerente do codigo 1 e 3% para o gerente do codigo 1
 


-- primeira tentativa com alguns erros
select CONCAT(CC.first_name, " ", CC.last_name) as Nome_cliente,
CASE 
    WHEN S.staff_id = 1 THEN (SUM(P.amount) * 0.5)
    when S.staff_id = 2 THEN (SUM(P.amount) * 0.3) 
    END into total
CONCAT(S.first_name, " ", S.last_name) as Nome_Staff
from  customer CC 
inner join payment P on CC.customer_id = P.customer_id
inner join staff S on P.staff_id = S.staff_id
WHERE S.staff_id = 1; 

select 
CONCAT(C.first_name, " ",  C.last_name) as "Nome cliente",
CONCAT(SS.first_name, " ", SS.last_name) as "Nome Gerente",
sum(amount) as totalPago,
CASE p.staff_id
    WHEN 1 THEN (sum(amount) * 0.05) 
    WHEN 2 THEN (sum(amount) * 0.03)
END as comissao
from payment P
INNER JOIN  customer C on P.customer_id = C.customer_id 
INNER join staff SS on P.staff_id = SS.staff_id
GROUP BY P.staff_id, P.customer_id;

create Procedure pagamentos (codigo int)
begin

    select 
    CONCAT(C.first_name, " ",  C.last_name) as "Nome cliente",
    CONCAT(SS.first_name, " ", SS.last_name) as "Nome Gerente",
    sum(amount) as totalPago,
    CASE p.staff_id
        WHEN 1 THEN (sum(p.amount) * 0.05) 
        WHEN 2 THEN (sum(p.amount) * 0.03)
    END as comissao
    from payment P
    INNER JOIN  customer C on P.customer_id = C.customer_id 
    INNER join staff SS on P.staff_id = SS.staff_id
    WHERE P.customer_id = codigo
    GROUP BY P.staff_id, P.customer_id;

END;

drop Procedure pagamentos;

call pagamentos(200);

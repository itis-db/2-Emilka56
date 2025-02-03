alter table product add column artist varchar(10) check (artist != '' );
alter table user_session add constraint unique_email unique(email);
alter table address alter column house_number type numeric(10, 1) using house_number::numeric(10, 1);
alter table user_session alter column name type integer using case when name='Svetlana' then 1 when name='Polina' then 2 end;


--rollback
alter table product drop column artist;
alter table user_session drop constraint unique_email;
alter table address alter column house_number type integer using house_number::integer;
alter table user_session alter column name type varchar(50) using case when name =1 then 'Svetlana' when name='2' then 'Polina' end;

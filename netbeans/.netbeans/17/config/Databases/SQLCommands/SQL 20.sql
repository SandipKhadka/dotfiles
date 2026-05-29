select * from admin;

update `admin`
set `IS_SUPER_ADMIN`=false
where id=1;

select * from college;
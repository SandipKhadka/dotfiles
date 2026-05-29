select * from `admin`;

update `admin`
set `IS_SUPER_ADMIN`=true
where id = 4

select `CREATED_BY_ADMIN` from admin_profile;

update admin_profile
set `CREATED_BY_ADMIN`=4
where id = 4;

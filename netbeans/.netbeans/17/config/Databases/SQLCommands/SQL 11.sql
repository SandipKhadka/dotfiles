delete from student_shift
where `START_TIME` is not null

select `START_TIME` from student_shift
where `START_TIME` is not null;


select * from academic_year;

delete from academic_year
where `IS_RUNNING` = false

select `STATUS`,`BRANCH` from `admin`
;

select `NAME`,`ID` from branch

update `admin`
set `BRANCH` = 3
where `ID`=2
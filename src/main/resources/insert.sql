create or replace function Date2EnrollYear(dDate in date) -- 수강 신청 년도
    return number
is
    nYear number;
begin
    nYear := extract(year from dDate);
    if extract(month from dDate) >= 11 then
    nYear := nYear + 1;
    end if;
    return nYear;
end;
/
create or replace function Date2EnrollSemester(dDate in date) -- 수강 신청 학기
    return number
is
    nMonth number;
    nSemester number := 1;
begin
    nMonth := extract(month from dDate);
    if nMonth >= 5 and nMonth < 11 then
    nSemester := 2;
    end if;
    return nSemester;
end;
/
create or replace function totalEnrollUnit(nStudentId in number) -- 총 신청 학점
    return number
is
    nYear number;
    nSemester number;
    nSumCourseUnit number;
begin
	nYear := Date2EnrollYear(sysdate);
	nSemester := Date2EnrollSemester(sysdate);

    select sum(c.c_unit)
	into nSumCourseUnit
	from  enroll e, teach t, course c
	where e.t_id = t.t_id and  t.c_id = c.c_id and
	    e.s_id = nStudentId and t.t_year = nYear and t.t_semester = nSemester
    ;

    return nSumCourseUnit;
end;
/

create or replace function totalEnrollCount(nStudentId in number) -- 총 신청 과목 수
    return number
is
    nYear number;
    nSemester number;
    nSumCourseCount number;
begin
	nYear := Date2EnrollYear(sysdate);
	nSemester := Date2EnrollSemester(sysdate);

    select count (c.c_id)
	into nSumCourseCount
	from  enroll e, teach t, course c
	where e.t_id = t.t_id and  t.c_id = c.c_id and
	    e.s_id = nStudentId and t.t_year = nYear and t.t_semester = nSemester
    ;

    return nSumCourseCount;
end;
/

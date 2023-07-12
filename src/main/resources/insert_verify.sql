create or replace view vTeach(t_id, t_day1, t_day2, t_start, t_end) -- 요일, 시작, 종료 시간을 계산하기 위한 뷰
as
select t_id,
    case
        when t.t_day = 1 or t.t_day = 6 then 1
        when t.t_day = 2 or t.t_day = 7 then 2
        when t.t_day = 3 or t.t_day = 8 then 3
        when t.t_day = 4 then 4
        else 5
    end as t_day1,
    case
        when t.t_day = 3 or t.t_day = 6 then 3
        when t.t_day = 4 or t.t_day = 7 then 4
        when t.t_day = 5 or t.t_day = 8 then 5
        when t.t_day = 1 then 1
        else 2
    end as t_day2,
    t_time as t_start,
    case
        when t.T_DAY in (6,7,8) then t.T_TIME + (t.T_HOUR / 2)
        else t.T_TIME + t.T_HOUR
    end as t_end
from TEACH t
;

create or replace procedure InsertEnroll( -- 수강신청
    nStudentId in number,
    nTeachId in number,
    result out varchar2)
is
	too_many_sumCourseUnit exception;
	too_many_courses exception;
	too_many_students exception;
	duplicate_time exception;
    nCourseId number;
    nTeachNo number;
	nYear number;
	nSemester number;
	nSumCourseUnit number;
	nCourseUnit number;
	nCnt number;
	nTeachMax number;
begin
	result := ''; -- 결과 문장

	select c_id into nCourseId from TEACH where t_id = nTeachId;
	select t_no into nTeachNo from TEACH where t_id = nTeachId;

	/* 년도, 학기 알아내기 */
	nYear := Date2EnrollYear(sysdate);
	nSemester := Date2EnrollSemester(sysdate);

	/* 에러 처리 1 : 최대학점 초과여부 */
	nSumCourseUnit := totalEnrollUnit(nStudentId);

	select c_unit
	into nCourseUnit
	from teach t
	join course c on t.c_id = c.c_id
	where t.t_id = nTeachId;

	if (nSumCourseUnit + nCourseUnit > 18)
	then
		raise too_many_sumCourseUnit;
	end if;

	/* 에러 처리 2 : 동일한 과목 신청 여부 */
	select count(*)
	INTO nCnt
    from ENROLL e
    join TEACH t on t.T_ID = e.T_ID
    where e.s_id = nStudentId and t.c_id = nCourseId;

	IF (nCnt > 0)
	THEN
		RAISE too_many_courses;
	END IF;

	/* 에러 처리 3 : 수강신청 인원 초과 여부 */
	select t_max
	INTO nTeachMax
	FROM teach
	where t_id = nTeachId;

	select count(*)
	INTO   nCnt
	FROM   enroll
	where t_id = nTeachId;

	IF (nCnt >= nTeachMax)
	THEN
		RAISE too_many_students;
	END IF;

	/* 에러 처리 4 : 신청한 과목들 시간 중복 여부 */
    select count(*)
	into nCnt
    from enroll e
    join vteach vt on e.s_id = nStudentId and e.t_id = vt.t_id
        and ((vt.t_day1 = (select t_day1 from vteach where t_id = nTeachId)) -- 날짜
            or (vt.t_day1 = (select t_day2 from vteach where t_id = nTeachId))
            or (vt.t_day2 = (select t_day1 from vteach where t_id = nTeachId))
            or (vt.t_day2 = (select t_day2 from vteach where t_id = nTeachId)))
    join teach t on t.t_year = nYear and t.t_semester = nSemester and e.t_id = t.t_id -- 내 수업
    where ((vt.t_start >= (select t_start from vteach where t_id = nTeachId)
            and vt.t_start <= (select t_end from vteach where t_id = nTeachId))
       or (vt.t_end >= (select t_start from vteach where t_id = nTeachId)
            and vt.t_end <= (select t_end from vteach where t_id = nTeachId)))
    ;


	IF (nCnt > 0)
	THEN
			RAISE duplicate_time;
	END IF;

/* 수강 신청 등록 */
insert into enroll(T_ID, S_ID)
values (nTeachId, nStudentId);

commit;
result := '수강신청 등록이 완료되었습니다.';

EXCEPTION
	WHEN too_many_sumCourseUnit THEN
		result := '최대학점을 초과하였습니다';
	WHEN too_many_courses THEN
		result := '이미 등록된 과목을 신청하였습니다';
	WHEN too_many_students THEN
		result := '수강신청 인원이 초과되어 등록이 불가능합니다';
	WHEN duplicate_time THEN
		result := '이미 등록된 과목 중 중복되는 시간이 존재합니다';
	WHEN OTHERS then
		rollback;
		result := SQLCODE;
END;
/

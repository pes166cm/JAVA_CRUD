CREATE TABLE T3_VOTE(
	V_JUMIN CHAR(13) NOT NULL PRIMARY KEY,
	V_NAME VARCHAR2(20),
	C_NO CHAR(1),
	V_TIME VARCHAR2(4),
	V_AREA VARCHAR2(20),
	V_CONFIRM CHAR(1)
);

INSERT INTO T3_VOTE VALUES('9901011000001', '김유권', '1', '0930', '제1투표장', 'Y');
INSERT INTO T3_VOTE VALUES('8901011000002', '이유권', '2', '0930', '제2투표장', 'Y');
INSERT INTO T3_VOTE VALUES('6901011000003', '박유권', '3', '1030', '제3투표장', 'Y');
INSERT INTO T3_VOTE VALUES('5901011000004', '안유권', '4', '1030', '제1투표장', 'Y');
INSERT INTO T3_VOTE VALUES('7901011000005', '금유권', '5', '1130', '제2투표장', 'Y');
INSERT INTO T3_VOTE VALUES('8901012000006', '귀유권', '1', '1230', '제3투표장', 'N');
INSERT INTO T3_VOTE VALUES('5901012000007', '가유권', '1', '1230', '제4투표장', 'N');
INSERT INTO T3_VOTE VALUES('4901012000008', '나유권', '3', '1330', '제1투표장', 'N');
INSERT INTO T3_VOTE VALUES('7901012000009', '다유권', '3', '1330', '제2투표장', 'Y');
INSERT INTO T3_VOTE VALUES('8901012000010', '라유권', '4', '1000', '제3투표장', 'Y');
INSERT INTO T3_VOTE VALUES('9901012000011', '마유권', '5', '1010', '제4투표장', 'Y');
INSERT INTO T3_VOTE VALUES('6901012000012', '바유권', '1', '0920', '제1투표장', 'Y');

SELECT * FROM T3_VOTE;


CREATE TABLE T3_CANDIDATE(
	C_NO CHAR(1) NOT NULL PRIMARY KEY,
	C_NAME VARCHAR2(20),
	P_CODE VARCHAR2(2),
	C_SCHOOL CHAR(1),
	C_JUMIN CHAR(13),
	C_CITY VARCHAR2(20)
);

INSERT INTO T3_CANDIDATE VALUES('1', '김후보', 'P1', '1' , '6603011999991', '수선화동');
INSERT INTO T3_CANDIDATE VALUES('2', '이후보', 'P2', '3' , '5503011999992', '민들래동');
INSERT INTO T3_CANDIDATE VALUES('3', '박후보', 'P3', '2' , '6603011999993', '나팔꽃동');
INSERT INTO T3_CANDIDATE VALUES('4', '조후보', 'P4', '2' , '7703011999994', '진달래동');
INSERT INTO T3_CANDIDATE VALUES('5', '최후보', 'P5', '3' , '8803011999995', '개나리동');

SELECT * FROM T3_CANDIDATE;


CREATE TABLE T3_PARTY(
	P_CODE CHAR(2) NOT NULL PRIMARY KEY,
	P_NAME VARCHAR2(20),
	P_INDATE DATE,
	P_LEADER VARCHAR2(20),
	P_TEL1 CHAR(3),
	P_TEL2 CHAR(4),
	P_TEL3 CHAR(4)
);

INSERT INTO T3_PARTY VALUES('P1', 'A정당', '2010-01-01', '위대표', '02', '1111', '0001');
INSERT INTO T3_PARTY VALUES('P2', 'B정당', '2010-02-01', '명대표', '02', '1111', '0002');
INSERT INTO T3_PARTY VALUES('P3', 'C정당', '2010-03-01', '기대표', '02', '1111', '0003');
INSERT INTO T3_PARTY VALUES('P4', 'D정당', '2010-04-01', '옥대표', '02', '1111', '0004');
INSERT INTO T3_PARTY VALUES('P5', 'E정당', '2010-05-01', '임대표', '02', '1111', '0005');

SELECT * FROM T3_PARTY;


SELECT C_NO, C_NAME, 
decode(p_code, 'P1', 'A정당', 'P2', 'B정당', 'P3', 'C정당', 'P4', 'D정당', 'P5', 'E정당') P_CODE,
decode(C_SCHOOL, '1', '고졸', '2', '학사', '3', '석사') C_SCHOOL,
substr(C_JUMIN, 1, 6) || '-' || substr(C_JUMIN, 7, 7) C_JUMIN,
C_CITY FROM T3_CANDIDATE;

select A.c_no, A.c_name, B.p_name,
decode(A.c_school, '1', '고졸', '2', '학사', '3', '석사', '4', '박사') c_school,
substr(A.c_jumin, 1, 6) || '-' || substr(a.c_jumin, 7, 7) c_jumin,
A.c_city, B.p_tel1 || '-' || B.p_tel2 || '-' || B.p_tel3 tel 
from T3_CANDIDATE A, T3_PARTY B where A.p_code = B.p_code order by A.p_code;
 

select v_name, '19' || substr(v_jumin,1,2)||'년'||substr(v_jumin,3,2)||'월'||substr(v_jumin,5,2)||'일' birth,
'만'||(2024-(to_number('19'||substr(v_jumin,1,2))))||'세' age,
decode(substr(v_jumin,7,1),'1', '남', '2', '여') gender,
c_no, substr(v_time,1,2)||':'||substr(v_time,3,2) v_time,
decode(v_confirm,'Y', '확인', 'N', '미확인') v_confirm
from t3_vote;

select A.c_no, 
B.c_name, 
C.p_name, 
count(A.c_no) total,
rank() over(order by count(A.c_no) desc) rank
from t3_vote A, t3_candidate B, T3_PARTY C
where A.c_no = B.c_no and B.p_code = C.p_code and A.v_confirm = 'Y'
group by A.c_no, B.c_name, C.p_name
order by rank;








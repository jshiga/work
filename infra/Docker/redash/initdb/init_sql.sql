DROP TABLE IF EXISTS mst_users;
CREATE TABLE mst_users(
	"employee_id" varchar(256),
	"first_name" varchar(256),
	"last_name" varchar(256),
	"email" varchar(256),
	"job_id" varchar(256),
	"loaded_at" timestamp
);

INSERT INTO mst_users
VALUES
	('101','taro','nemoto','nemoto@example.com','11','2022-03-16'),
	('102','ziro','tanoue','tanoue@example.com','11','2022-03-16')
;

DROP TABLE IF EXISTS jobs;
CREATE TABLE jobs(
	"job_id" varchar(256),
	"job_title" varchar(256),
	"min_salary" INTEGER,
	"max_salary" INTEGER,
	"loaded_at" timestamp
)
;

INSERT INTO jobs
VALUES
	('11','datascientist',6000000,12000000,'2022-03-16'),
	('12','dataengineer',5000000,10000000,'2022-03-16')
;

-- Tạo bảng
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    symptoms TEXT[]
);

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    department VARCHAR(50)
);

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    appointment_date DATE,
    diagnosis VARCHAR(200),
    fee NUMERIC(10,2),
    status VARCHAR(20) DEFAULT 'Scheduled' -- Thêm cột status để thực hành View
);

-- Thêm dữ liệu mẫu
INSERT INTO patients (full_name, city, symptoms) VALUES 
('Nguyen Van A', 'Hanoi', '{fever, cough}'),
('Tran Thi B', 'Hanoi', '{headache}'),
('Le Van C', 'Da Nang', '{back pain}'),
('Pham Van D', 'HCM', '{fever}'),
('Hoang Thi E', 'Hanoi', '{sore throat}');

INSERT INTO doctors (full_name, department) VALUES 
('Dr. Smith', 'Internal Medicine'),
('Dr. Jones', 'Neurology');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, fee, status) VALUES 
(1, 1, '2024-02-01', 50.00, 'Scheduled'),
(2, 2, '2024-02-01', 100.00, 'Scheduled'),
(3, 1, '2024-02-02', 50.00, 'Completed'),
(4, 1, '2024-02-03', 55.00, 'Scheduled'),
(5, 2, '2024-02-03', 110.00, 'Scheduled');

--B-tree: tìm bệnh nhân theo số điện thoại (phone)
Create index idx_patients_phone_btree ON patients USING btree (phone);
--Hash: tìm bệnh nhân theo city
Create index idx_patients_city_hash ON patients USING hash (city);
--GIN: tìm bệnh nhân theo từ khóa trong mảng symptoms
Create index  idx_patients_symptoms_gin ON patients USING gin (symptoms);
--GiST: tìm cuộc hẹn theo khoảng phí (fee)
CREATE EXTENSION IF NOT EXISTS btree_gist;
Create index  idx_appointments_fee_gist ON appointments USING gist (fee);

--Tạo Clustered Index trên bảng appointments theo ngày khám
create index idx_appointments_date ON appointments(appointment_date);
CLUSTER appointments USING idx_appointments_date;

--Thực hiện các truy vấn trên View:
--Tìm top 3 bệnh nhân có tổng phí khám cao nhất
create view v_top_patients_spending AS
select 
    p.patient_id,
    p.full_name,
    SUM(a.fee) AS total_spent
from patients p
join appointments a ON p.patient_id = a.patient_id
group by p.patient_id, p.full_name
order by total_spent DESC
LIMIT 3;

-- Truy vấn kết quả từ View
SELECT * FROM v_top_patients_spending;
--Tính tổng số lượt khám theo bác sĩ
create view v_appointment_count_by_doctor AS
select 
    d.doctor_id,
    d.full_name AS doctor_name,
    d.department,
    COUNT(a.appointment_id) AS total_appointments
from doctors d
left join appointments a ON d.doctor_id = a.doctor_id
group by d.doctor_id, d.full_name, d.department;

-- Truy vấn kết quả từ View
SELECT * FROM v_appointment_count_by_doctor 
ORDER BY total_appointments DESC;

--Tạo View có thể cập nhật để thay đổi city của bệnh nhân:
--Thử cập nhật thành phố của 1 bệnh nhân qua View và kiểm tra lại bảng patients
create view v_patient_locations AS
select patient_id, full_name, city
from patients;

-- Cập nhật thông tin thông qua View
update v_patient_locations
SET city = 'Da Lat'
where patient_id = 1;
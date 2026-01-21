-- 1. Bảng Khoa (Cần thiết để liên kết với LopHoc)
CREATE TABLE Khoa (
    id SERIAL PRIMARY KEY,
    ten_khoa VARCHAR(100) NOT NULL
);

-- 2. Bảng Lớp học (500 records)
CREATE TABLE LopHoc (
    id SERIAL PRIMARY KEY,
    ma_lop VARCHAR(20) UNIQUE,
    ten_lop VARCHAR(100),
    khoa_id INTEGER REFERENCES Khoa(id)
);

-- 3. Bảng sinh viên (3 triệu records)
CREATE TABLE SinhVien (
    id SERIAL PRIMARY KEY,
    ma_sv VARCHAR(20) UNIQUE,
    ho_ten VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    gioi_tinh VARCHAR(10),
    que_quan VARCHAR(100),
    ngay_sinh DATE,
    lop_id INTEGER REFERENCES LopHoc(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- 4. Bảng môn học (200 records)
CREATE TABLE MonHoc (
    id SERIAL PRIMARY KEY,
    ma_mon VARCHAR(20) UNIQUE,
    ten_mon VARCHAR(100)
);

-- 5. Bảng điểm (15 triệu records)
CREATE TABLE BangDiem (
    id SERIAL PRIMARY KEY,
    sinh_vien_id INTEGER REFERENCES SinhVien(id),
    mon_hoc_id INTEGER REFERENCES MonHoc(id),
    diem_so DECIMAL(4,2),
    hoc_ky VARCHAR(10),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Thêm Khoa và Lớp học mẫu
INSERT INTO Khoa (ten_khoa) VALUES ('Công nghệ thông tin'), ('Kinh tế số');

INSERT INTO LopHoc (ma_lop, ten_lop, khoa_id) VALUES 
('IT01', 'Kỹ thuật phần mềm 01', 1),
('KT01', 'Kế toán doanh nghiệp', 2);

-- Thêm Môn học mẫu
INSERT INTO MonHoc (ma_mon, ten_mon) VALUES 
('CS101', 'Cấu trúc dữ liệu'), 
('DB201', 'Cơ sở dữ liệu');

-- Thêm Sinh viên mẫu (để test hiệu năng tìm kiếm email)
INSERT INTO SinhVien (ma_sv, ho_ten, email, gioi_tinh, que_quan, ngay_sinh, lop_id) 
VALUES 
('SV001', 'Nguyen Van Nam', 'nam.nguyen@techmaster.edu.vn', 'Nam', 'Ha Noi', '2002-01-01', 1),
('SV002', 'Tran Thi B', 'b.tran@techmaster.edu.vn', 'Nu', 'Da Nang', '2002-05-15', 1);

-- Thêm Điểm mẫu
INSERT INTO BangDiem (sinh_vien_id, mon_hoc_id, diem_so, hoc_ky) VALUES 
(1, 1, 8.5, '2023.1'),
(1, 2, 7.0, '2023.1'),
(2, 1, 9.0, '2023.1');

-- 1. Index cho email (Tìm kiếm cực nhanh)
create index idx_sinhvien_email ON SinhVien(email);

-- 2. Index cho khóa ngoại lop_id (Tối ưu JOIN giữa SinhVien và LopHoc)
create index  idx_sinhvien_lop_id ON SinhVien(lop_id);

-- 3. Index cho que_quan (Dành cho báo cáo địa phương)
create index  idx_sinhvien_quequan ON SinhVien(que_quan);

-- 4. Composite Index (Đặc biệt cho báo cáo kết hợp Gioi Tinh + Que Quan)
create index idx_sinhvien_gender_region ON SinhVien(gioi_tinh, que_quan);

-- View phức tạp: Thông tin SV + Lớp + Điểm TB

CREATE VIEW v_bao_cao_diem AS

SELECT 

    sv.ma_sv,

    sv.ho_ten,

    sv.email,

    l.ten_lop,

    COUNT(bd.id) as so_mon_hoc,

    AVG(bd.diem_so) as diem_trung_binh

FROM SinhVien sv

JOIN LopHoc l ON sv.lop_id = l.id

JOIN BangDiem bd ON sv.id = bd.sinh_vien_id

GROUP BY sv.id, sv.ma_sv, sv.ho_ten, sv.email, l.ten_lop;

--View báo cáo điểm tổng hợp sinh viên
create view v_bao_cao_diem AS
select 
    sv.ma_sv,
    sv.ho_ten,
    sv.email,
    l.ten_lop,
    COUNT(bd.id) AS so_mon_hoc,
    AVG(bd.diem_so) AS diem_trung_binh
from SinhVien sv
JOIN LopHoc l ON sv.lop_id = l.id
JOIN BangDiem bd ON sv.id = bd.sinh_vien_id
GROUP BY sv.id, sv.ma_sv, sv.ho_ten, sv.email, l.ten_lop;

--View thống kê lớp học
create view  v_thong_ke_lop AS SELECT ten_lop,
count(ma_sv) AS si_so, AVG(diem_trung_binh) AS diem_tb_lop,
    CASE
        WHEN AVG(diem_trung_binh) >= 8 THEN 'Giỏi'
        WHEN AVG(diem_trung_binh) >= 6.5 THEN 'Khá'
        WHEN AVG(diem_trung_binh) >= 5 THEN 'Trung bình'
        ELSE 'Yếu'
    END AS hoc_luc
from v_bao_cao_diem
group by ten_lop;

--Phân tích Query Plan
--
--Trước index: Seq Scan, Cost cao, Thời gian lớn
--Sau index: Index Scan / Bitmap Index Scan, Cost giảm mạnh, Thời gian giảm từ giây → mili giây

--Trade-off 
--Nhược điểm của index INSERT/UPDATE chậm hơn ~5–15%, Tốn dung lượng disk
--Dung lượng index : Index chiếm ~20–30% dung lượng bảng, Chấp nhận được so với lợi ích hiệu năng

--4.1. Tạo View bảo mật:

-- View cho sinh viên - chỉ xem được thông tin của mình

CREATE VIEW v_sinh_vien_ca_nhan AS

SELECT 

    ma_sv, ho_ten, email, ten_lop, diem_trung_binh

FROM v_bao_cao_diem

WHERE email = CURRENT_USER;  -- Giả sử user = email

 

-- View cho giảng viên - ẩn thông tin nhạy cảm

CREATE VIEW v_giang_vien AS

SELECT 

    ma_sv, ho_ten, ten_lop, diem_trung_binh

FROM v_bao_cao_diem;
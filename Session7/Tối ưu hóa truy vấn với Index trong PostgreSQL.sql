CREATE TABLE book (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(100),
    genre VARCHAR(50),
    price DECIMAL(10, 2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO book (title, author, genre, price, description)
VALUES 
('Dế Mèn Phiêu Lưu Ký', 'Tô Hoài', 'Văn học thiếu nhi', 55000.00, 'Một tác phẩm kinh điển về chú dế mèn nghị lực.'),
('Số Đỏ', 'Vũ Trọng Phụng', 'Tiểu thuyết', 72000.00, 'Tác phẩm trào phúng nổi tiếng về xã hội Việt Nam thời Pháp thuộc.'),
('Mắt Biếc', 'Nguyễn Nhật Ánh', 'Lãng mạn', 90000.00, 'Câu chuyện tình buồn giữa Ngạn và Hà Lan.');

--Tạo các chỉ mục phù hợp để tối ưu truy vấn sau:
create drop index idx_book_author on book(author);
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_book_author_trgm
ON book USING gin (author gin_trgm_ops);

--So sánh thời gian truy vấn trước và sau khi tạo Index (dùng EXPLAIN ANALYZE)
explain analyze
select * from book where author ilike '%Rowling%'

--Thử nghiệm các loại chỉ mục khác nhau:
--B-tree cho genre
--GIN cho title hoặc description (phục vụ tìm kiếm full-text)

create index idx_book_genre on book(genre);

create index idx_book_title_trgm
on book using gin(title gin_trgm_ops)

--Tạo một Clustered Index (sử dụng lệnh CLUSTER) trên bảng book theo cột genre và kiểm tra sự khác biệt trong hiệu suất
cluster book using idx_book_genre

--Viết báo cáo ngắn (5-7 dòng) giải thích:
--Loại chỉ mục nào hiệu quả nhất cho từng loại truy vấn?
--B-tree hiệu quả nhất cho truy vấn theo genre vì đây là tìm kiếm giá trị chính xác
-- gin thì hiệu quả cho author khi dùng ilike và kí tự % ở đầu
--Khi nào Hash index không được khuyến khích trong PostgreSQL?
--Hash index chỉ hỗ trợ phép so sánh bằng (=) không hỗ trợ cái khác
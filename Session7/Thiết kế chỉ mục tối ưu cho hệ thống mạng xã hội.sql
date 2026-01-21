-- Tạo bảng post
CREATE TABLE post (
    post_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    tags TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_public BOOLEAN DEFAULT TRUE
);

-- Tạo bảng post_like
CREATE TABLE post_like (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (post_id) REFERENCES post(post_id) ON DELETE CASCADE
);

INSERT INTO post (user_id, content, tags, is_public) VALUES
(1, 'Bài viết về Java cơ bản', ARRAY['java','backend','oop'], true),
(2, 'Học PostgreSQL và Index', ARRAY['postgresql','database','sql'], true),
(3, 'Chia sẻ kinh nghiệm Spring Boot', ARRAY['java','spring','backend'], true),
(1, 'Cuộc sống sinh viên IT', ARRAY['life','student'], true),
(4, 'Bài viết riêng tư', ARRAY['personal'], false),
(2, 'Tối ưu truy vấn với GIN index', ARRAY['postgresql','index','gin'], true),
(3, 'So sánh MySQL và PostgreSQL', ARRAY['database','mysql','postgresql'], true),
(5, 'Học lập trình từ con số 0', ARRAY['programming','basic'], true);

INSERT INTO post_like (user_id, post_id) VALUES
(2, 1),
(3, 1),
(4, 1),

(1, 2),
(3, 2),

(1, 3),
(2, 3),
(4, 3),
(5, 3),

(2, 6),
(3, 6),

(1, 7),
(5, 7);

--Tối ưu hóa truy vấn tìm kiếm bài đăng công khai theo từ khóa:
--Tạo Expression Index sử dụng LOWER(content) để tăng tốc tìm kiếm
create index idx_lower_content on post(lower(content));
-- nếu chưa tạo index thì sẽ có dòng 'Seq Scan on post' 
-- nếu tạo index thì sẽ hiện dòng 'index scan using idx_post_content_lower'
-- thay vì quét toàn bộ nó chỉ tìm đúng vị trí trong cây chỉ mục , tôcs độ sẽ nhanh hơn mấy lần


--Tạo GIN Index cho cột tags
Create index idx_post_tags on post using gin(tags)
--Phân tích hiệu suất bằng EXPLAIN ANALYZE
explain analyze select * from post where tags @ array['travel']

--Tạo Partial Index cho bài viết công khai gần đây:
create index idx_post_public_recent on post (created_at desc)
where is_public is true

--Kiểm tra hiệu suất với truy vấn:
explain analyze 
select * from post
where is_public = true and created_at > now()-interval '7 days';

--Tạo chỉ mục (user_id, created_at DESC)
create index idx_post_user_id on post(user_id, created_at desc)
--Kiểm tra hiệu suất khi người dùng xem “bài đăng gần đây của bạn bè”
EXPLAIN ANALYZE
SELECT *
FROM post
WHERE user_id IN (2, 3, 5)
ORDER BY created_at DESC
LIMIT 10;



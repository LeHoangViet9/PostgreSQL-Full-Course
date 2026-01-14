CREATE TABLE Product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price BIGINT,
    stock INT,
    manufacturer VARCHAR(50)
);
INSERT INTO Product (name, category, price, stock, manufacturer) VALUES
('Laptop Dell XPS 13', 'Laptop', 25000000, 12, 'Dell'),
('Chuột Logitech M90', 'Phụ kiện', 150000, 50, 'Logitech'),
('Bàn phím cơ Razer', 'Phụ kiện', 2200000, 0, 'Razer'),
('Macbook Air M2', 'Laptop', 32000000, 7, 'Apple'),
('iPhone 14 Pro Max', 'Điện thoại', 35000000, 15, 'Apple'),
('Laptop Dell XPS 13', 'Laptop', 25000000, 12, 'Dell'),
('Tai nghe AirPods 3', 'Phụ kiện', 4500000, NULL, 'Apple');


-- Thêm sản phẩm “Chuột không dây Logitech M170”, loại Phụ kiện, giá 300000, tồn kho 20, hãng Logitech
INSERT INTO Product (name, category, price, stock, manufacturer)
VALUES ('Chuột không dây Logitech M170', 'Phụ kiện', 300000, 20, 'Logitech');

--Tăng giá tất cả sản phẩm của Apple thêm 10%
UPDATE Product
SET price = price * 1.1
WHERE manufacturer = 'Apple';

-- Xóa sản phẩm có stock = 0
DELETE FROM Product
WHERE stock = 0;

-- Hiển thị sản phẩm có price BETWEEN 1000000 AND 30000000
SELECT *
FROM Product
WHERE price BETWEEN 1000000 AND 30000000;

-- Hiển thị sản phẩm có stock IS NULL
SELECT *
FROM Product
WHERE stock IS NULL;

-- Liệt kê danh sách hãng sản xuất duy nhất
SELECT DISTINCT manufacturer
FROM Product;

-- Hiển thị toàn bộ sản phẩm, sắp xếp giảm dần theo giá, sau đó tăng dần theo tên
SELECT *
FROM Product
ORDER BY price DESC, name ASC;

-- Tìm sản phẩm có tên chứa từ “laptop” (không phân biệt hoa thường)
SELECT *
FROM Product
WHERE name ILIKE '%laptop%';

-- Chỉ hiển thị 2 sản phẩm đầu tiên sau khi sắp xếp
SELECT *
FROM Product
ORDER BY price DESC, name ASC
LIMIT 2;

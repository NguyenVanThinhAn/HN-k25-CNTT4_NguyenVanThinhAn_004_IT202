SET SQL_SAFE_UPDATES = 0; -- Tắt safe mode
-- DROP DATABASE test; -- Có thể ctrl + shift + enter test nhanh
CREATE DATABASE test;

USE test;

CREATE TABLE Customer(
	customer_id varchar(5) primary key,
    customer_name varchar(100) not null,
    customer_email varchar(100) not null unique,
    customer_phone varchar(15) not null unique,
    customer_adress varchar(255) not null
);

CREATE TABLE Product(
	product_id varchar(5) primary key not null,
    product_name varchar(50) not null,
    category varchar(20) not null,
    product_price decimal(10,2) not null,
    stock_quantity int not null
);

CREATE TABLE Orders(
	orders_id int primary key not null auto_increment,
    customer_id varchar(5) not null,
    product_id varchar(5) not null,
    order_date date not null,
    order_quantity int not null,
    total_amount decimal(10,2) not null,
    FOREIGN KEY(customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY(product_id) REFERENCES Product(product_id)
);

CREATE TABLE Payment(
	payment_id int primary key not null auto_increment,
    order_id int not null,
    payment_date date not null,
    payment_method varchar(50) not null,
    payment_status varchar(50) not null,
    FOREIGN KEY(order_id) REFERENCES Orders(orders_id)
);

INSERT INTO Customer
VALUES
("C001","Nguyen Anh Tu","tu.nguyen@example.com","0987654321","Hanoi"),
("C002","Tran Thi Mai","mai.tran@example.com","0987654322","Ho Chi Minh"),
("C003","Le Minh Hoang","hoang.le@example.com","0987654323","Danang"),
("C004","Pham Hoang Nam","nam.pham@example.com","0987654324","Hue"),
("C005","Vu Minh Thu","thu.vu@example.com","0987654325","Hai Phong");

INSERT INTO Product
VALUES
("P001","Laptop Dell","Electronics",15000.00,10),
("P002","iPhone 15","Electronics",20000.00,5),
("P003","T-Shirt","Clothing",200.00,50),
("P004","Running Shoes","Footwear",1500.00,20),
("P005","Table Lamp","Furniture",500.00,15);

INSERT INTO Orders
VALUES
(1,"C001","P001","2025-06-01",1,15000.00),
(2,"C002","P003","2025-06-02",2,400.00),
(3,"C003","P002","2025-06-03",1,20000.00),
(4,"C004","P004","2025-06-03",1,1500.00),
(5,"C005","P001","2025-06-04",2,30000.00),
(6,"C005","P001","2025-06-04",2,30000.00); -- Thêm nhằm check thống kê số lượng đặt hàng mỗi customer

INSERT INTO Payment
VALUES
(1,1,"2025-06-01","Banking","Paid"),
(2,2,"2025-06-02","Cash","Paid"),
(3,3,"2025-06-03","Credit Card","Paid"),
(4,4,"2025-06-04","Banking","Pending"),
(5,5,"2025-06-05","Credit Card","Paid");

-- sửa
UPDATE Customer SET customer_phone = "0999888777" WHERE customer_id = "C001";
UPDATE Product SET product_price = 200.00 * 1.1, stock_quantity = 100 WHERE product_id = "P003";

-- xóa
DELETE FROM Payment WHERE payment_method = "Banking";

-- Hiển thị
SELECT product_id,product_name,product_price FROM Product WHERE category = "Electronics" AND product_price > 10000;
SELECT customer_name,customer_email,customer_adress FROM Customer WHERE customer_name LIKE "Nguyen%";
SELECT orders_id,order_date,total_amount FROM Orders ORDER BY total_amount DESC;
SELECT * FROM Payment ORDER BY payment_date DESC LIMIT 3;
SELECT product_id,product_name FROM Product LIMIT 3 OFFSET 2;

-- Truy vấn dữ liệu

-- Hiển thị danh sách đơn hàng gồm: order_id, customer_name , product_name và total_amount. Chỉ lấy những đơn hàng có total_amount lớn hơn 1000. (5 điểm)
SELECT ord.orders_id,cus.customer_name,ord.total_amount
FROM Customer cus
JOIN Orders ord ON ord.customer_id = cus.customer_id
JOIN Product pro ON ord.product_id = pro.product_id
WHERE ord.total_amount > 1000;

-- Liệt kê tất cả các sản phẩm trong hệ thống gồm: product_id, product_name và order_id tương ứng (nếu có). Kết quả phải bao gồm cả những sản phẩm chưa từng được đặt hàng. (5 điểm)
SELECT pro.product_id,pro.product_name,ord.orders_id
FROM Product pro
LEFT JOIN Orders ord ON ord.product_id = pro.product_id;

-- Tính tổng danh thu cho từng loại sản phẩm. Kết quả hiển thị 2 cột: category và Total_Revenue. (5 điểm)
SELECT pro.category,SUM(pro.product_price * order_quantity) as "doanh_thu"
FROM Product pro
JOIN Orders ord ON ord.product_id = pro.product_id
GROUP BY pro.category;

-- Thống kê số lượng đơn hàng của mỗi khách hàng. Hiển thị customer_name và Order_Count. Chỉ hiện những khách hàng đã đặt từ 2 đơn trở lên.(5 điểm)
SELECT cus.customer_name, COUNT(ord.customer_id) as "order_count"
FROM Customer cus
JOIN Orders ord ON ord.customer_id = cus.customer_id
GROUP BY cus.customer_id
HAVING COUNT(ord.customer_id) >= 2;

-- Lấy thông tin chi tiết các đơn hàng (order_id, customer_name, total_amount) có giá trị đơn hàng cao hơn giá trị trung bình của tất cả các đơn hàng trong bảng Order.(5 điểm)
SELECT ord.orders_id,cus.customer_name,ord.total_amount
FROM Orders ord
JOIN Customer cus ON cus.customer_id = ord.customer_id
GROUP BY ord.orders_id
HAVING ord.total_amount > (
	SELECT AVG(ord2.total_amount)
    FROM Orders ord2
);


-- Hiển thị customer_name và customer_phone của những khách hàng đã từng mua sản phẩm có danh mục là 'Electronics'. (5 điểm)
SELECT cus.customer_name,cus.customer_phone
FROM Customer cus
JOIN Orders ord ON ord.customer_id = cus.customer_id
JOIN Product pro ON pro.product_id = ord.product_id
WHERE pro.category = "Electronics";

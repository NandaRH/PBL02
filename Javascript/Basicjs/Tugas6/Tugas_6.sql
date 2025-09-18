drop procedure sp_ins_pelanggan;

create database if not exists warung;

use warung;

CREATE TABLE IF NOT EXISTS kelamin (
    kode INT PRIMARY KEY,
    nama VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS kota (
    kode INT PRIMARY KEY,
    nama VARCHAR(25)
);

create table if not exists pelanggan
(
    kode    varchar(20) primary key,
    nama    varchar(100),
    kelamin int,
    alamat  varchar(25),
    kota    int,
    FOREIGN KEY (kelamin) REFERENCES kelamin(kode),
    FOREIGN KEY (kota) REFERENCES kota(kode)
);

INSERT INTO kelamin (kode, nama) VALUES
(1, 'Pria'),
(2, 'Wanita');

INSERT INTO kota (kode, nama) VALUES
(1, 'Jakarta'),
(2, 'Bandung'),
(3, 'Surabaya');



DELIMITER //

CREATE PROCEDURE sp_ins_pelanggan(
    IN p_kode VARCHAR(20),
    IN p_nama VARCHAR(100),
    IN p_kode_kelamin INT,
    IN p_alamat VARCHAR(25),
    IN p_kode_kota INT
)
BEGIN
    INSERT INTO pelanggan (kode, nama, kelamin, alamat, kota)
    VALUES (p_kode, p_nama, p_kode_kelamin, p_alamat, p_kode_kota);
END//

DELIMITER ;

CALL sp_ins_pelanggan('PGl001','Mohammad',1,'priok' ,1);
CALL sp_ins_pelanggan('PGl002','Nuafal',1,'Cilincing' ,1);
CALL sp_ins_pelanggan('PGl003','Atila',1,'Bonjongsoang' ,2);
CALL sp_ins_pelanggan('PGl004','Tsalsa',2,'Buahbatu' ,2);
CALL sp_ins_pelanggan('PGl005','Damay',2,'Gubeng' ,3);
CALL sp_ins_pelanggan('PGl006','Tsaniy',1,'Darmo' ,3);
CALL sp_ins_pelanggan('PGl007','Nabila',2,'Lebak Bulus' ,1);

CREATE OR REPLACE VIEW vw_pelanggan_lengkap AS
SELECT
    p.kode AS kode_pelanggan,
    p.nama AS nama_pelanggan,
    k.nama AS kelamin,
    p.alamat,
    c.nama AS kota
FROM pelanggan p
JOIN kelamin k ON p.kelamin = k.kode
JOIN kota c ON p.kota = c.kode;

use warung;

CREATE TABLE IF NOT EXISTS satuan (
    kode INT PRIMARY KEY,
    nama VARCHAR(25)
);

create table if not exists produk (
        kode varchar(20) primary key ,
        nama varchar(100),
        satuan int,
        stock int,
        harga decimal(10,2),
        FOREIGN KEY (satuan) REFERENCES satuan(kode)
);

INSERT INTO satuan (kode, nama) VALUES
(1, 'Bungkus'),
(2, 'Pak'),
(3, 'Botol');

DELIMITER //

CREATE PROCEDURE sp_ins_produk(
    IN p_kode VARCHAR(20),
    IN p_nama VARCHAR(100),
    IN p_satuan INT,
    IN p_stock INT,
    IN p_harga DECIMAL(10,2)
)
BEGIN
    INSERT INTO produk (kode, nama, satuan, stock, harga)
    VALUES (p_kode, p_nama, p_satuan, p_stock, p_harga);
END//

DELIMITER ;

call sp_ins_produk('P001','Indomie',1,10,3000);
call sp_ins_produk('P002','Roti',2,3,18000);
call sp_ins_produk('P003','Kecap',3,8,4700);
call sp_ins_produk('P004','SaosTomat',3,8,5800);
call sp_ins_produk('P005','Bihun',1,5,3500);
call sp_ins_produk('P006','Sikat Gigi',2,5,15000);
call sp_ins_produk('P007','Pasta Gigi',2,7,10000);
call sp_ins_produk('P008','Saos Sambal',3,5,7300);

CREATE OR REPLACE VIEW v_produk_lengkap AS
SELECT
    p.kode,
    p.nama,
    s.nama AS satuan,
    p.stock,
    p.harga
FROM produk p
JOIN satuan s ON p.satuan = s.kode;


use warung;

CREATE TABLE penjualan (
    no_jual VARCHAR(20) PRIMARY KEY,     -- Nomor transaksi
    tgl_jual DATE,                       -- Tanggal transaksi
    kode_pelanggan VARCHAR(20),          -- Siapa pembelinya
    FOREIGN KEY (kode_pelanggan) REFERENCES pelanggan(kode)
);

CREATE TABLE detail_penjualan (
    no_jual VARCHAR(20),                 -- FK ke penjualan
    kode_produk VARCHAR(20),             -- Produk yang dibeli
    jumlah INT,                          -- Jumlah item
    PRIMARY KEY (no_jual, kode_produk),  -- Satu produk sekali dicatat di 1 transaksi
    FOREIGN KEY (no_jual) REFERENCES penjualan(no_jual),
    FOREIGN KEY (kode_produk) REFERENCES produk(kode)
);

INSERT INTO penjualan (no_jual, tgl_jual, kode_pelanggan)
VALUES
('J001', '2025-09-08', 'PGl003'),  -- Atila
('J002', '2025-09-08', 'PGl007'),  -- Nabila
('J003', '2025-09-09', 'PGl002'),  -- Naufal
('J004', '2025-09-10', 'PGl005');  -- Damay

-- J001 Atila
INSERT INTO detail_penjualan VALUES ('J001','P001',2); -- Indomie
INSERT INTO detail_penjualan VALUES ('J001','P003',1); -- Kecap
INSERT INTO detail_penjualan VALUES ('J001','P004',1); -- Saos Tomat

-- J002 Nabila
INSERT INTO detail_penjualan VALUES ('J002','P006',1); -- Sikat Gigi
INSERT INTO detail_penjualan VALUES ('J002','P007',1); -- Pasta Gigi

-- J003 Naufal
INSERT INTO detail_penjualan VALUES ('J003','P001',5); -- Indomie
INSERT INTO detail_penjualan VALUES ('J003','P004',2); -- Saos Tomat
INSERT INTO detail_penjualan VALUES ('J003','P008',2); -- Saos Sambal
INSERT INTO detail_penjualan VALUES ('J003','P003',1); -- Kecap

-- J004 Damay
INSERT INTO detail_penjualan VALUES ('J004','P002',3); -- Roti
INSERT INTO detail_penjualan VALUES ('J004','P004',2); -- Saos Tomat
INSERT INTO detail_penjualan VALUES ('J004','P008',2); -- Saos Sambal
INSERT INTO detail_penjualan VALUES ('J004','P006',1); -- Sikat Gigi
INSERT INTO detail_penjualan VALUES ('J004','P007',1); -- Pasta Gigi

CREATE VIEW vw_laporan_penjualan AS
SELECT
    p.no_jual,
    p.tgl_jual,
    pl.nama AS nama_pelanggan,
    pr.nama AS nama_produk,
    d.jumlah,
    pr.harga,
    (d.jumlah * pr.harga) AS subtotal
FROM penjualan p
JOIN pelanggan pl ON p.kode_pelanggan = pl.kode
JOIN detail_penjualan d ON p.no_jual = d.no_jual
JOIN produk pr ON d.kode_produk = pr.kode;

SELECT * FROM vw_laporan_penjualan;

DELIMITER //

CREATE FUNCTION fn_total_penjualan(p_no_jual VARCHAR(20))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(12,2);

    SELECT SUM(d.jumlah * pr.harga)
    INTO v_total
    FROM detail_penjualan d
    JOIN produk pr ON d.kode_produk = pr.kode
    WHERE d.no_jual = p_no_jual;

    RETURN IFNULL(v_total,0);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_ins_penjualan (
    IN p_no_jual VARCHAR(20),
    IN p_tgl_jual DATE,
    IN p_kode_pelanggan VARCHAR(20)
)
BEGIN
    INSERT INTO penjualan (no_jual, tgl_jual, kode_pelanggan)
    VALUES (p_no_jual, p_tgl_jual, p_kode_pelanggan);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_update_penjualan (
    IN p_no_jual VARCHAR(20),
    IN p_tgl_jual DATE,
    IN p_kode_pelanggan VARCHAR(20)
)
BEGIN
    UPDATE penjualan
    SET tgl_jual = p_tgl_jual,
        kode_pelanggan = p_kode_pelanggan
    WHERE no_jual = p_no_jual;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_delete_penjualan (
    IN p_no_jual VARCHAR(20)
)
BEGIN
    -- Hapus dulu detailnya (supaya tidak orphan)
    DELETE FROM detail_penjualan WHERE no_jual = p_no_jual;

    -- Baru hapus header
    DELETE FROM penjualan WHERE no_jual = p_no_jual;
END //

DELIMITER ;






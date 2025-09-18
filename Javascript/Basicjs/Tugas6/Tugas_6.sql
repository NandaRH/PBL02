drop database warung;

use warung;

create table if not exists pelanggan (
        kode varchar(20) primary key ,
        nama varchar(100),
        kelamin varchar(10),
        alamat varchar(25),
        kota varchar(25)
);

DELIMITER //

CREATE PROCEDURE sp_ins_pelanggan(
    IN p_kode VARCHAR(20),
    IN p_nama VARCHAR(100),
    IN p_kode_kelamin INT,
    IN p_alamat Varchar(25),
    IN p_kode_kota INT
)
BEGIN
    DECLARE v_kelamin VARCHAR(10);
    DECLARE v_kota VARCHAR(25);

    -- Mapping kelamin
    IF p_kode_kelamin = 1 THEN
        SET v_kelamin = 'Pria';
    ELSEIF p_kode_kelamin = 2 THEN
        SET v_kelamin = 'Wanita';
    ELSE
        SET v_kelamin = 'Tidak Diketahui';
    END IF;

    -- Mapping kota
    IF p_kode_kota = 1 THEN
        SET v_kota = 'Jakarta';
    ELSEIF p_kode_kota = 2 THEN
        SET v_kota = 'Bandung';
    ELSEIF p_kode_kota = 3 THEN
        SET v_kota = 'Surabaya';
    ELSE
        SET v_kota = 'Kota Lain';
    END IF;

    -- Insert ke tabel pelanggan
    INSERT INTO pelanggan (kode, nama, kelamin, alamat, kota)
    VALUES (p_kode, p_nama, v_kelamin, p_alamat, v_kota);
END//

DELIMITER ;

CALL sp_ins_pelanggan('PGl001','Mohammad',1,'priok' ,1);
CALL sp_ins_pelanggan('PGl002','Nuafal',1,'Cilincing' ,1);
CALL sp_ins_pelanggan('PGl003','Atila',1,'Bonjongsoang' ,2);
CALL sp_ins_pelanggan('PGl004','Tsalsa',2,'Buahbatu' ,2);
CALL sp_ins_pelanggan('PGl005','Damay',2,'Gubeng' ,3);
CALL sp_ins_pelanggan('PGl006','Tsaniy',1,'Darmo' ,3);
CALL sp_ins_pelanggan('PGl007','Nabila',2,'Lebak Bulus' ,1);

DELIMITER $$

CREATE PROCEDURE sp_manage_pelanggan (
    IN p_aksi VARCHAR(10),         -- DELETE atau UPDATE
    IN p_kode VARCHAR(20),         -- kode pelanggan
    IN p_nama VARCHAR(100),        -- nama baru (untuk UPDATE)
    IN p_kode_kelamin INT,         -- kode kelamin baru (untuk UPDATE)
    IN p_alamat VARCHAR(25),       -- alamat baru (untuk UPDATE)
    IN p_kode_kota INT             -- kode kota baru (untuk UPDATE)
)
BEGIN
    DECLARE v_kelamin VARCHAR(10);
    DECLARE v_kota VARCHAR(25);

    -- mapping kelamin
    IF p_kode_kelamin = 1 THEN
        SET v_kelamin = 'Pria';
    ELSEIF p_kode_kelamin = 2 THEN
        SET v_kelamin = 'Wanita';
    ELSE
        SET v_kelamin = 'Tidak Diketahui';
    END IF;

    -- mapping kota
    IF p_kode_kota = 1 THEN
        SET v_kota = 'Jakarta';
    ELSEIF p_kode_kota = 2 THEN
        SET v_kota = 'Bandung';
    ELSEIF p_kode_kota = 3 THEN
        SET v_kota = 'Surabaya';
    ELSE
        SET v_kota = 'Kota Lain';
    END IF;

    -- pilih aksi
    IF UPPER(p_aksi) = 'DELETE' THEN
        DELETE FROM pelanggan WHERE kode = p_kode;

    ELSEIF UPPER(p_aksi) = 'UPDATE' THEN
        UPDATE pelanggan
        SET nama    = p_nama,
            kelamin = v_kelamin,
            alamat  = p_alamat,
            kota    = v_kota
        WHERE kode = p_kode;
    END IF;
END$$

DELIMITER ;


SELECT * FROM pelanggan;


use warung;

create table if not exists produk (
        kode varchar(20) primary key ,
        nama varchar(100),
        satuan varchar(20),
        stock int,
        harga int
);

DELIMITER //

CREATE PROCEDURE sp_ins_produk(
    IN p_kode VARCHAR(20),
    IN p_nama VARCHAR(100),
    IN p_kode_satuan INT,
    IN p_stock int,
    IN p_harga int
)
BEGIN
    DECLARE v_satuan varchar(20);

    -- Mapping satuan
    IF p_kode_satuan = 1 THEN
        SET v_satuan= 'Bungkus';
    ELSEIF p_kode_satuan = 2 THEN
        SET v_satuan = 'Pak';
    ELSEif p_kode_satuan = 3 then
        SET v_satuan= 'Botol';
    Else
        set v_satuan='Tidak ada Satuan';
    End if;

    -- Insert ke tabel produk
    INSERT INTO produk (kode, nama, satuan, stock, harga)
    VALUES (p_kode, p_nama, v_satuan, p_stock, p_harga);
END//

DELIMITER ;

call sp_ins_produk('P001','indomie',1,10,3000);
call sp_ins_produk('P002','Roti',2,3,18000);
call sp_ins_produk('P003','Kecap',3,8,4700);
call sp_ins_produk('P004','SaosTomat',3,8,5800);
call sp_ins_produk('P005','Bihun',1,5,3500);
call sp_ins_produk('P006','Sikat Gigi',2,5,15000);
call sp_ins_produk('P007','Pasta Gigi',2,7,10000);
call sp_ins_produk('P008','Saos Sambal',3,5,7300);

select * from produk;

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






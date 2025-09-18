/* --- Awal DDL --- */
# Menghapus database
DROP DATABASE pbl2;

# Membuat database
/*
# IF NOT EXISTS
# Mencari nama database, jika tidak ditemukan maka akan membuat database
# jika ditemukan maka isi didalam database akan dilewati semuanya
*/
CREATE DATABASE IF NOT EXISTS pbl2;

# Menunjuk database yang digunakan
USE pbl2;

# Membuat table definisi
CREATE TABLE IF NOT EXISTS siswa ( 
	nis 	varchar(5), 
    nama 	varchar(50), 
    alamat 	varchar(100), 
    kota 	varchar(25)
);

# Merubah nama kolom
ALTER TABLE siswa 
	RENAME COLUMN nis TO nisa;

# DESCRIBE siswa;

# Merubah nama kolom sekaligus atribut tipe datanya
ALTER TABLE siswa 
	CHANGE nisa nis VARCHAR(10);

# Menampilkan seluruh table pada database
# SHOW TABLES;

# Menampilkan atribut pada table tertentu
# DESCRIBE siswa;

/* --- Akhir DDL --- */
/* --- Awal DML --- */

# Memasukkan hanya 1 record
INSERT siswa VALUES ('1234567890', 'Septiawan', 'Cirendeu', 'Jakarta');
# Memasukkan banyak record
INSERT siswa VALUES
	('1234567890', 'Damayanti', 'Gubeng', 'Surabaya'),
    ('1234567890', 'Dzakiy', 'Gubeng', 'Surabaya'),
    ('1234567890', 'Dzaka', 'Ciganitri', 'Bandung'),
    ('1234567890', 'Nabila', 'Ciganitri', 'Bandung');
    
UPDATE siswa
SET nis = '2345678901'
WHERE nama = 'Damayanti';

UPDATE siswa
SET nis = '3456789012'
WHERE nama = 'Dzakiy';

UPDATE siswa
SET nis = '4567890123'
WHERE nama = 'Dzaka';

UPDATE siswa
SET nis = '5678901234'
WHERE nama = 'Nabila';

ALTER TABLE siswa
	ADD PRIMARY KEY (nis);
    
# DESCRIBE siswa;

# SELECT 	* FROM 	siswa;

/* --- Akhir DML --- */

CREATE TABLE kota (
	kode	varchar(1) primary key,
    nama	varchar(10)
);

# show tables;

DELIMITER //
CREATE PROCEDURE sp_ins_kota (
	sp_kode	varchar(1),
    sp_nama	varchar(10)
)
BEGIN
	INSERT kota VALUES (sp_kode, sp_nama);
    select 	* from	kota;
END//
DELIMITER ;

CALL sp_ins_kota('1', 'Bandung');
CALL sp_ins_kota('2', 'Surabaya');
CALL sp_ins_kota('3', 'Jakarta');

select  *
from	siswa;

select  *
from	kota;

update siswa
set kota = '2'
where alamat = 'Gubeng';

update siswa
set kota = '1'
where alamat = 'Ciganitri';

update siswa
set kota = '3'
where alamat = 'Cirendeu';

ALTER TABLE siswa 
	CHANGE kota kd_kota VARCHAR(1);
    
alter table siswa
	add foreign key (kd_kota)
    references kota(kode);
    
create view vw_jmlsiswa_kota as
select	kota.nama, count(kota.nama) as Jumlah_Siswa
from	siswa, kota
where	siswa.kd_kota = kota.kode and
		kota.nama = 'Bandung'
group by kota.nama;
    
describe siswa;

select *
from vw_jmlsiswa_kota
where nama = 'bandung';

DELIMITER //
CREATE PROCEDURE sp_jmlsiswa_by_kota (
    sp_nama	varchar(10)
)
BEGIN
	select 	*
    from 	vw_jmlsiswa_kota
    where	nama = sp_nama;
END//
DELIMITER ;

call sp_jmlsiswa_by_kota('Surabaya');
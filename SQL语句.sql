/*
Navicat SQL Server Data Transfer

Source Server         : SQL Server
Source Server Version : 140000
Source Host           : localhost:1433
Source Database       : YYGLXT
Source Schema         : dbo

Target Server Type    : SQL Server
Target Server Version : 140000
File Encoding         : 65001
*/

CREATE DATABASE drugsystem
ON PRIMARY
(NAME = 'tsg_data',
FILENAME = 
'C:\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\tsg_data.mdf',
SIZE = 5MB,
MAXSIZE = 500MB,
FILEGROWTH = 10%)
LOG ON
(NAME = 'tsg_log',
FILENAME = 
'C:\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\tsg_log.ldf',
SIZE = 3MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1MB)

-- ----------------------------
-- Table structure for 仓库
-- ----------------------------

GO
CREATE TABLE 仓库 (
药品编号 varchar(8) NOT NULL ,
药品数量 int NOT NULL DEFAULT (0) 
)


GO

-- ----------------------------
-- Table structure for 订单
-- ----------------------------

GO
CREATE TABLE 订单 (
订单号 varchar(8) NOT NULL ,
下单日期 date NOT NULL ,
药品编号 varchar(8) NOT NULL ,
数量 int NOT NULL ,
总额 float(53) NOT NULL ,
订单状态 varchar(1) NOT NULL DEFAULT ('0') CHECK(订单状态 in ('0','1')),
客户编号 varchar(8) NOT NULL 
)


GO

-- ----------------------------
-- Table structure for 供应商
-- ----------------------------

GO
CREATE TABLE 供应商 (
供应商编号 varchar(8) NOT NULL ,
供应商名称 varchar(90) NOT NULL ,
供应商联系方式 varchar(90) NOT NULL ,
供应商地址 varchar(90) NOT NULL 
)


GO

-- ----------------------------
-- Table structure for 客户
-- ----------------------------

GO
CREATE TABLE 客户 (
客户编号 varchar(8) NOT NULL ,
客户姓名 varchar(30) NOT NULL ,
客户联系方式 varchar(30) NOT NULL ,
客户登录密码 varchar(30) NOT NULL ,
客户地址 varchar(90) NOT NULL 
)


GO

-- ----------------------------
-- Table structure for 入库
-- ----------------------------

GO
CREATE TABLE 入库 (
入库单号 varchar(8) NOT NULL ,
药品编号 varchar(8) NOT NULL ,
入库数量 int NOT NULL ,
入库日期 date NOT NULL 
)


GO

-- ----------------------------
-- Table structure for 药品
-- ----------------------------

GO
CREATE TABLE 药品 (
药品编号 varchar(8) NOT NULL ,
药品名称 varchar(90) NOT NULL ,
药品功效 varchar(90) NULL ,
药品单价 float(53) NOT NULL ,
有效期 varchar(30) NOT NULL ,
药品类型 varchar(30) NOT NULL ,
供应商编号 varchar(8) NOT NULL 
)


GO

-- ----------------------------
-- Table structure for 员工
-- ----------------------------
GO
CREATE TABLE 员工 (
员工照片 image default NULL,
员工工号 varchar(8) NOT NULL ,
员工姓名 varchar(30) NOT NULL ,
员工联系方式 varchar(30) NOT NULL ,
员工登录密码 varchar(30) NOT NULL ,
员工职务 varchar(30) NOT NULL ,
是否管理员 varchar(1) NOT NULL DEFAULT ('0') CHECK(是否管理员 in ('0','1'))
)


GO

-- ----------------------------
-- View structure for 仓库查询
-- ----------------------------

GO
CREATE VIEW 仓库查询 AS 
SELECT
仓库.药品编号,
药品.药品名称,
仓库.药品数量

FROM 仓库
INNER JOIN 药品 ON 仓库.药品编号 = 药品.药品编号
GO

-- ----------------------------
-- View,procedure structure for 当月统计
-- ----------------------------

GO
CREATE VIEW 当月统计 AS 
SELECT
订单.下单日期,
药品.药品名称,
订单.数量,
订单.总额
FROM 订单
INNER JOIN 药品 ON 订单.药品编号 = 药品.药品编号
WHERE
订单.订单状态 = 1
and MONTH(下单日期)=MONTH(GETDATE());
GO

GO
CREATE PROCEDURE 月统计
    @订单数量 int, @销售额 float(53)
AS
BEGIN
	SET @订单数量=(SELECT COUNT(*) FROM 当月统计)
	SET @销售额=(SELECT COUNT(总额) FROM 当月统计)
END

GO

-- ----------------------------
-- View structure for 管理员登录
-- ----------------------------

GO
CREATE VIEW 管理员登录 AS 
SELECT
员工.员工工号 AS 管理员工号,
员工.员工姓名 AS 管理员姓名,
员工.员工登录密码 AS 管理员登录密码

FROM 员工
WHERE
员工.是否管理员 = 1
GO

-- ----------------------------
-- View structure for 客户登录
-- ----------------------------

GO
CREATE VIEW 客户登录 AS 
SELECT
客户.客户编号,
客户.客户姓名,
客户.客户登录密码

FROM 客户
GO

-- ----------------------------
-- View structure for 客户看订单
-- ----------------------------

GO
CREATE VIEW 客户看订单 AS 
SELECT
订单.订单号,
订单.下单日期,
订单.药品编号,
药品.药品名称,
客户.客户姓名,
客户.客户地址,
订单.客户编号,
订单.数量,
订单.总额,
订单.订单状态

FROM 订单
INNER JOIN 药品 ON 订单.药品编号 = 药品.药品编号
INNER JOIN 客户 ON 订单.客户编号 = 客户.客户编号
GO

-- ----------------------------
-- View structure for 员工登录
-- ----------------------------

GO
CREATE VIEW 员工登录 AS 
SELECT
员工.员工工号,
员工.员工姓名,
员工.员工登录密码

FROM 员工
GO

-- ----------------------------
-- View structure for 在售药品
-- ----------------------------

GO
CREATE VIEW 在售药品 AS 
SELECT
药品.药品编号,
药品.药品名称,
药品.药品功效,
药品.药品单价,
药品.有效期,
药品.药品类型,
仓库.药品数量 AS 药品余量

FROM
药品
INNER JOIN 仓库 ON 仓库.药品编号 = 药品.药品编号
WHERE
仓库.药品数量 > 0
GO

-- ----------------------------
-- Primary Key structure for table 仓库
-- ----------------------------
ALTER TABLE 仓库 ADD PRIMARY KEY (药品编号)
GO

-- ----------------------------
-- Primary Key structure for table 订单
-- ----------------------------
ALTER TABLE 订单 ADD PRIMARY KEY (订单号)
GO

-- ----------------------------
-- Primary Key structure for table 供应商
-- ----------------------------
ALTER TABLE 供应商 ADD PRIMARY KEY (供应商编号)
GO

-- ----------------------------
-- Primary Key structure for table 客户
-- ----------------------------
ALTER TABLE 客户 ADD PRIMARY KEY (客户编号)
GO

-- ----------------------------
-- Indexes structure for table 入库
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table 入库
-- ----------------------------
ALTER TABLE 入库 ADD PRIMARY KEY (入库单号)
GO

-- ----------------------------
-- Triggers structure for table 入库
-- ----------------------------

GO
CREATE TRIGGER 入库触发器
ON 入库
AFTER INSERT
AS
    declare @数量 int,@药品 varchar(8)
    --在inserted表中查询已经插入记录信息
    select @数量 = 入库数量,@药品 = 药品编号 from inserted;
    update 仓库 set 药品数量 = 药品数量 + @数量 where 药品编号=@药品;

GO

GO
CREATE TRIGGER 退货触发器
ON 入库
AFTER DELETE
AS
    declare @数量 int,@药品 varchar(8)
    --在inserted表中查询已经插入记录信息
    select @数量 = 入库数量,@药品 = 药品编号 from deleted;
    update 仓库 set 药品数量 = 药品数量 - @数量 where 药品编号=@药品;

GO

-- ----------------------------
-- Primary Key structure for table 药品
-- ----------------------------
ALTER TABLE 药品 ADD PRIMARY KEY (药品编号)
GO

-- ----------------------------
-- Triggers structure for table 药品
-- ----------------------------

GO
CREATE TRIGGER 仓库更新
ON 药品
AFTER INSERT
AS
    declare @药品 varchar(8)
    --在inserted表中查询已经插入记录信息
    select @药品 = 药品编号 from inserted;
    insert into 仓库(药品编号) values(@药品);

GO

-- ----------------------------
-- Primary Key structure for table 员工
-- ----------------------------
ALTER TABLE 员工 ADD PRIMARY KEY (员工工号)
GO

-- ----------------------------
-- Foreign Key structure for table 仓库
-- ----------------------------
ALTER TABLE 仓库 ADD FOREIGN KEY (药品编号) REFERENCES 药品 (药品编号) ON DELETE CASCADE ON UPDATE CASCADE
GO

-- ----------------------------
-- Foreign Key structure for table 订单
-- ----------------------------
ALTER TABLE 订单 ADD FOREIGN KEY (客户编号) REFERENCES 客户 (客户编号) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE 订单 ADD FOREIGN KEY (药品编号) REFERENCES 药品 (药品编号) ON DELETE CASCADE ON UPDATE CASCADE
GO

-- ----------------------------
-- Foreign Key structure for table 入库
-- ----------------------------
ALTER TABLE 入库 ADD FOREIGN KEY (药品编号) REFERENCES 药品 (药品编号) ON DELETE CASCADE ON UPDATE CASCADE
GO

-- ----------------------------
-- Foreign Key structure for table 药品
-- ----------------------------
ALTER TABLE 药品 ADD FOREIGN KEY (供应商编号) REFERENCES 供应商 (供应商编号) ON DELETE CASCADE ON UPDATE CASCADE
GO

CREATE INDEX A ON 仓库(药品编号 ASC)
CREATE INDEX B ON 药品(药品编号 ASC)
CREATE INDEX C ON 订单(下单日期 DESC)
CREATE INDEX D ON 供应商(供应商编号 ASC)
CREATE INDEX E ON 客户(客户编号 ASC)
CREATE INDEX F ON 入库(入库单号 ASC)
CREATE INDEX G ON 员工(员工工号 ASC)



use drugsystem
GO
EXEC sp_addlogin 'system','yww_39485184'
GO
EXEC sp_grantdbaccess 'system','客户'
GO
EXEC sp_grantdbaccess 'system','员工'
GO
EXEC sp_grantdbaccess 'system','管理员'

GO
EXEC sp_addrolemember  'db_owner', '管理员'

GO
GRANT SELECT,INSERT,UPDATE ON 仓库 TO 员工
GO
GRANT SELECT,INSERT,UPDATE ON 药品 TO 员工
GO
GRANT SELECT,INSERT,UPDATE ON 订单 TO 员工
GO
GRANT SELECT,INSERT,UPDATE ON 供应商 TO 员工
GO
GRANT SELECT,INSERT,UPDATE ON 客户 TO 员工
GO
GRANT SELECT,INSERT,UPDATE ON 入库 TO 员工

GO
GRANT SELECT ON 客户看订单 TO 客户
GO
GRANT SELECT ON 在售药品 TO 客户
GO
GRANT INSERT ON 订单 TO 客户
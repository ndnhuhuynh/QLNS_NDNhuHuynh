

USE [master]
GO

/****** Object:  Database [QLNS]     ******/
CREATE DATABASE [QLNS]
GO

USE [QLNS]
GO



/****** Object:  User [pbnhansu]     ******/
CREATE USER [pbnhansu] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NT AUTHORITY\LOCAL SERVICE]     ******/
CREATE USER [NT AUTHORITY\LOCAL SERVICE] FOR LOGIN [NT AUTHORITY\LOCAL SERVICE] WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'pbnhansu'
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'NT AUTHORITY\LOCAL SERVICE'
GO
/****** Object:  StoredProcedure [dbo].[sp_PB_ChamcongNhanvien_Insert]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 07-05-2012
-- Description:	Tao bang cham cong ngay
-- =============================================
CREATE PROCEDURE [dbo].[sp_PB_ChamcongNhanvien_Insert]
	@Mabangchamcong uniqueidentifier,
	@MaNV varchar(10),
	@Sogiocong int,
	@Sogionghiphep int,
	@CreatedByUser uniqueidentifier,
	@CreatedByDate datetime
AS
BEGIN
	insert into PB_ChamcongNhanvien
		values
			(
				@Mabangchamcong,
				@MaNV,
				@Sogiocong,
				@Sogionghiphep,
				@CreatedByUser,
				@CreatedByDate
			)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PB_Chamtangca_Insert]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 07-05-2012
-- Description:	Tao bang cham cong tang ca
-- =============================================
CREATE PROCEDURE [dbo].[sp_PB_Chamtangca_Insert]
	@Mabangchamcong uniqueidentifier,
	@MaNV varchar(10),
	@TCthuong int,
	@TCchunhat int,
	@TCnghile int,
	@CreatedByUser uniqueidentifier,
	@CreatedByDate datetime
AS
BEGIN
	insert into PB_Chamtangca
		values
			(
				@Mabangchamcong,
				@MaNV,
				@TCthuong,
				@TCchunhat,
				@TCnghile,
				@CreatedByUser,
				@CreatedByDate
			)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PB_Luongtangca_Insert]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 07-05-2012
-- Description:	Tao bang luong tang ca
-- =============================================
CREATE PROCEDURE [dbo].[sp_PB_Luongtangca_Insert]
	@Mabangchamcong uniqueidentifier,
	@MaNV varchar(10),
	@LuongGio int,
	@Sotangcathuong int,
	@Sotangcachunhat int,
	@Sotangcale int,
	@CreatedByUser uniqueidentifier,
	@CreatedByDate datetime
AS
BEGIN
	insert into PB_Luongtangca
		values
			(
				@Mabangchamcong,
				@MaNV,
				@LuongGio,
				@Sotangcathuong,
				@Sotangcachunhat,
				@Sotangcale,
				@CreatedByUser,
				@CreatedByDate
			)
END


GO
/****** Object:  StoredProcedure [dbo].[sp_PB_Luongtangca_Insert_One]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 07-05-2012
-- Description:	Tinh luong tang ca nhan vien
-- =============================================
CREATE PROCEDURE [dbo].[sp_PB_Luongtangca_Insert_One]
	@Mabangluong uniqueidentifier,
	@MaNV varchar(10),
	@Luongtoithieu int,
	@Tongsogioquydinh int,
	@Sogiotangcathuong int,
	@Sogiotangcachunhat int,
	@Sogiotangcanghile int,
	@CreatedByUser uniqueidentifier,
	@CreatedByDate datetime
AS
BEGIN
	declare @Thang int
	declare @Nam int

	--Bien su dung cho tung nhan vien khi insert vao PB_Luongtangca
	declare @Luongcoban int
	declare @Hesoluong float
	declare @LuongGio int

	set @Thang = (select Thang from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @Nam = (select Nam from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	
	--He so luong
	set @Hesoluong = (select Hesoluong from PB_Thaydoibacluong
						where MaNV = @MaNV and IsCurrent = 1)
	--Luong co ban
	set @Luongcoban = @Luongtoithieu * @Hesoluong

	--LuongGio
	set @LuongGio = @Luongcoban / @Tongsogioquydinh

	insert into PB_Luongtangca
		values
			(
				@Mabangluong,
				@MaNV,
				@LuongGio,
				@Sogiotangcathuong,
				@Sogiotangcachunhat,
				@Sogiotangcanghile,
				@CreatedByUser,
				@CreatedByDate
			)
END



GO
/****** Object:  StoredProcedure [dbo].[sp_PB_Luongtangca_Select_All]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 10-05-2012
-- Description:	So luong tang ca theo Mabangluong
-- =============================================
CREATE PROCEDURE [dbo].[sp_PB_Luongtangca_Select_All]
	@Mabangluong uniqueidentifier
AS
BEGIN
	declare @HS_Thuong float
	declare @HS_Chunhat float
	declare @HS_Nghile float

	--He so tang ca thuong
	set @HS_Thuong = (select Hesothuong from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	
	--He so tang ca chu nhat
	set @HS_Chunhat = (select Hesochunhat from PB_Danhsachbangluong where Mabangluong = @Mabangluong)

	--He so tang ca ngay nghi - le
	set @HS_Nghile = (select Hesonghile from PB_Danhsachbangluong where Mabangluong = @Mabangluong)

	select PB_Luongtangca.Mabangluong, MaNV, LuongGio,
		(LuongGio * @HS_Thuong) as Tientangcathuong,
		Sotangcathuong,
		(LuongGio * @HS_Chunhat) as Tientangcachunhat,
		Sotangcachunhat,
		(LuongGio * @HS_Nghile) as Tientangcanghile,
		Sotangcale,
		(((LuongGio * @HS_Thuong)*Sotangcathuong)
			+ ((LuongGio * @HS_Chunhat)*Sotangcachunhat)
			+ ((LuongGio * @HS_Nghile)*Sotangcale)) as Tongluongtangca
		from PB_Luongtangca inner join PB_Danhsachbangluong
		on PB_Luongtangca.Mabangluong = PB_Danhsachbangluong.Mabangluong
		where PB_Luongtangca.Mabangluong = @Mabangluong
END



GO
/****** Object:  StoredProcedure [dbo].[sp_PB_SoLuong_Insert]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 07-05-2012
-- Description:	Tao bang so luong
-- =============================================
CREATE PROCEDURE [dbo].[sp_PB_SoLuong_Insert]
	@Mabangluong uniqueidentifier,
	@MaNV varchar(10),
	@Hesoluong float,
	@Tonggiocongthucte int,
	@Nghiphep int,
	@BHXH bit,
	@BHYT bit,
	@BHTN bit,
	@Phicongdoan bit,
	@Tienthue int,
	@Songuoiphuthuoc int,
	@Sotienconlaichiuthue int,
	@Tiendongthue int,
	@Phicongtac int,
	@Tongtamung int,
	@Tongphucap int,
	@Tongthuong int,
	@CreatedByUser uniqueidentifier,
	@CreatedByDate datetime
AS
BEGIN
	insert into PB_SoLuong
		values
			(
				@Mabangluong,
				@MaNV,
				@Hesoluong,
				@Tonggiocongthucte,
				@Nghiphep,
				@BHXH,
				@BHYT,
				@BHTN,
				@Phicongdoan,
				@Tienthue,
				@Songuoiphuthuoc,
				@Sotienconlaichiuthue,
				@Tiendongthue,
				@Phicongtac,
				@Tongtamung,
				@Tongphucap,
				@Tongthuong,
				@CreatedByUser,
				@CreatedByDate
			)
END




GO
/****** Object:  StoredProcedure [dbo].[sp_PB_SoLuong_Insert_One]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 07-05-2012
-- Description:	Tinh luong nhan vien
-- =============================================
CREATE PROCEDURE [dbo].[sp_PB_SoLuong_Insert_One]
	@Mabangluong uniqueidentifier,
	@MaNV varchar(10),
	@Luongtoithieu int,
	@Tongsogioquydinh int,
	@Tonggiocongthucte int,
	@Nghiphep int,
	@Tienbatdautinhthue int,
	@Tienmoinguoiphuthuoc int,
	@BHXH_HS float,
	@BHYT_HS float,
	@BHTN_HS float,
	@BHXHMAX int,
	@Phicongdoan_HS float,
	@PhicongdoanMAX int,
	@CreatedByUser uniqueidentifier,
	@CreatedByDate datetime
AS
BEGIN
	declare @Thang int
	declare @Nam int

	--Bien su dung cho tung nhan vien khi insert vao PB_Soluong
	declare @BHXH bit
	declare @BHYT bit
	declare @BHTN bit
	declare @Phicongdoan bit
	declare @Phicongtac int
	declare @Tongtamung int
	declare @Tongphucap int
	declare @Tongthuong int
	declare @Luongcoban int
	declare @Hesoluong float

	set @Thang = (select Thang from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @Nam = (select Nam from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	
	set @BHXH = (select BHXH from PB_Nhanvien where MaNV = @MaNV)
	set @BHYT = (select BHYT from PB_Nhanvien where MaNV = @MaNV)
	set @BHTN = (select BHTN from PB_Nhanvien where MaNV = @MaNV)
	set @Phicongdoan = (select Phicongdoan from PB_Nhanvien where MaNV = @MaNV)
	
	--Tong thuong
	if (select sum(Sotien) from PB_KhenthuongNhanvien
			where MaNV = @MaNV
					and month(Ngaykhenthuong) = @Thang
					and year(Ngaykhenthuong) = @Nam) is not null
		set @Tongthuong = (select sum(Sotien) from PB_KhenthuongNhanvien
							where MaNV = @MaNV
									and month(Ngaykhenthuong) = @Thang
									and year(Ngaykhenthuong) = @Nam)
	else set @Tongthuong = 0

	--Tong phu cap
	if (select sum(Sotien) from PB_PhucapNhanvien
			where MaNV = @MaNV) is not null
		set @Tongphucap = (select sum(Sotien) from PB_PhucapNhanvien
							where MaNV = @MaNV)
	else set @Tongphucap = 0

	--He so luong
	set @Hesoluong = (select Hesoluong from PB_Thaydoibacluong
						where MaNV = @MaNV and IsCurrent = 1)
	-- Luong co ban
	set @Luongcoban = @Luongtoithieu * @Hesoluong

	

	declare @TienBHXH int
	declare @TienBHYT int
	declare @TienBHTN int
	declare @TienPhicongdoan int
	--TienBHXH
	if (@BHXH = 1)
		begin
			set @TienBHXH = (@BHXH_HS * @Luongcoban) / 100
			if (@TienBHXH > @BHXHMAX)
				set @TienBHXH = @BHXHMAX
		end
	else
		set @TienBHXH = 0
	--TienBHYT
	if (@BHYT = 1)
		set @TienBHYT = (@BHYT_HS * @Luongcoban) / 100
	else
		set @TienBHYT = 0
	--TienBHTN
	if (@BHTN = 1)
		set @TienBHTN = (@BHTN_HS * @Luongcoban) / 100
	else
		set @TienBHTN = 0
	--TienPhicongdoan
	if (@Phicongdoan = 1)
		begin
			set @TienPhicongdoan = (@Phicongdoan_HS * @Luongcoban) / 100
			if (@TienPhicongdoan > @PhicongdoanMAX)
				set @TienPhicongdoan = @PhicongdoanMAX
		end
	else
		set @TienPhicongdoan = 0

	--Tong luong
	declare @Tongluong int	
	set @Tongluong = ((@Luongcoban * (@Tonggiocongthucte + @Nghiphep)) / @Tongsogioquydinh
						- @TienBHXH - @TienBHYT - @TienBHTN - @TienPhicongdoan
						+ @Tongthuong + @Tongphucap)

	--So nguoi phu thuoc
	declare @Songuoiphuthuoc int
	set @Songuoiphuthuoc = (select count(*)
								from PB_Nguoithannhanvien
								where MaNV = @MaNV and Phuthuoc = 1
							)
	--Tienthue
	declare @Tienthue int
	if (@Tongluong > @Tienbatdautinhthue)
		set @Tienthue = (@Tongluong - @Tienbatdautinhthue)
	else
		set @Tienthue = 0

	--So tien con lai phai chiu thue
	declare @Sotienconlaichiuthue int
	set @Sotienconlaichiuthue = @Tienthue - (@Songuoiphuthuoc * @Tienmoinguoiphuthuoc)
	if (@Sotienconlaichiuthue < 0)
		set @Sotienconlaichiuthue = 0

	--Tien dong thue
	declare @Tiendongthue int
	
	if(@Sotienconlaichiuthue<5000000) 
	    set @Tiendongthue=@Sotienconlaichiuthue*0.05
	else if(@Sotienconlaichiuthue<10000000) 
	    set @Tiendongthue=@Sotienconlaichiuthue*0.1 - (0.05*5000000)
	else if(@Sotienconlaichiuthue<18000000) 
	    set @Tiendongthue=@Sotienconlaichiuthue*0.15 - (0.1*5000000 + 0.05*5000000)
	else if(@Sotienconlaichiuthue<32000000) 
	    set @Tiendongthue=@Sotienconlaichiuthue * 0.2 - (0.15*8000000 + 0.1*5000000+0.05*5000000)
	else if(@Sotienconlaichiuthue<52000000) 
	    set @Tiendongthue=@Sotienconlaichiuthue*0.25-(0.2*14000000+0.15*8000000+0.1*5000000+0.05*5000000)
	else if(@Sotienconlaichiuthue<80000000) 
	    set @Tiendongthue=@Sotienconlaichiuthue*0.3-(0.25*20000000+0.2*14000000+0.15*8000000+0.1*5000000+0.05*5000000)
	else set @Tiendongthue=@Sotienconlaichiuthue*0.35-(0.3*28000000+0.25*20000000+0.2*14000000+0.15*8000000+0.1*5000000+0.05*5000000)
	
	--Phi cong tac
	if ((select sum(Tiendicongtac) from PB_Dicongtac
			where MaNV = @MaNV
					and month(Tungay) = @Thang
					and year(Tungay) = @Nam)) is not null
		set @Phicongtac = (select sum(Tiendicongtac) from PB_Dicongtac
							where MaNV = @MaNV
									and month(Tungay) = @Thang
									and year(Tungay) = @Nam)
	else set @Phicongtac = 0

	--Tong tam ung
	if (select sum(Sotien) from PB_TamungNhanvien
			where MaNV = @MaNV
					and month(Ngaytamung) = @Thang
					and year(Ngaytamung) = @Nam) is not null
		set @Tongtamung = (select sum(Sotien) from PB_TamungNhanvien
							where MaNV = @MaNV
									and month(Ngaytamung) = @Thang
									and year(Ngaytamung) = @Nam)
	else set @Tongtamung = 0
	

	insert into PB_SoLuong
		values
			(
				@Mabangluong,
				@MaNV,
				@Hesoluong,
				@Tonggiocongthucte,
				@Nghiphep,
				@BHXH,
				@BHYT,
				@BHTN,
				@Phicongdoan,
				@Tienthue,
				@Songuoiphuthuoc,
				@Sotienconlaichiuthue,
				@Tiendongthue,
				@Phicongtac,
				@Tongtamung,
				@Tongphucap,
				@Tongthuong,
				@CreatedByUser,
				@CreatedByDate
			)
END







GO
/****** Object:  StoredProcedure [dbo].[sp_PB_SoLuong_Select_All]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 10-05-2012
-- Description:	Select bang luong ngay theo mabangluong
-- =============================================
CREATE PROCEDURE [dbo].[sp_PB_SoLuong_Select_All]
	@Mabangluong uniqueidentifier
AS
BEGIN
	--bien
	declare @Nhanvien table(MaNV varchar(10))
	declare @MaNV varchar(10)
	declare @Bangluong table
							(
								Mabangluong uniqueidentifier, MaNV varchar(10),
								Luongcoban int,
								Tonggiocongthucte int, Nghiphep int,
								TienBHXH int, TienBHYT int, TienBHTN int, TienPhicongdoan int,
								Tienluong int,
								TienThueTNCN int,
								Tongtamung int,
								Tongphucap int,
								Tongthuong int,
								Tongkhautru int,
								Tienlamthem int,
								Phicongtac int,
								Thuclanh int
							)
	
	--Nhanvien
	insert into @Nhanvien select MaNV from PB_SoLuong where Mabangluong = @Mabangluong
	
	--Khai bao cursor
	DECLARE cur_Nhanvien CURSOR
	FOR 
		  SELECT MaNV FROM @Nhanvien
	--Mo cursor
	OPEN cur_Nhanvien
	--Doc du lieu
	FETCH NEXT FROM cur_Nhanvien
		INTO @MaNV
	WHILE @@FETCH_STATUS = 0
	BEGIN
		  --Xu ly dong moi vua doc duoc
			--Insert vao @Bangluong
			insert into @Bangluong exec sp_PB_SoLuong_Select_Nhanvien @Mabangluong, @MaNV
			
			--Thuc hien doc tiep cac dong ke
			FETCH NEXT FROM cur_Nhanvien
				INTO @MaNV
	END
	--Dong Cursor
	CLOSE cur_Nhanvien
	DEALLOCATE cur_Nhanvien
	
	select * from @Bangluong
END



GO
/****** Object:  StoredProcedure [dbo].[sp_PB_SoLuong_Select_Nhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 10-05-2012
-- Description:	Select bang luong ngay cua 1 nhan vien
-- exec sp_PB_SoLuong_Select_Nhanvien 'f0b60bb8-ea85-407f-a86d-dd6032728b8b', 'NV00000001'
-- =============================================
CREATE PROCEDURE [dbo].[sp_PB_SoLuong_Select_Nhanvien]
	@Mabangluong uniqueidentifier,
	@MaNV varchar(10)
AS
BEGIN
	--Mot so tham so can thiet
	declare @Luongtoithieu int
	declare @Hesoluong float
	declare @Luongcoban int
	declare @Tonggiocongthucte int
	declare @Nghiphep int
	declare @Phicongtac int
	declare @Tongtamung int
	declare @Tongphucap int
	declare @Tongthuong int
	declare @Tongkhautru int
	declare @BHXH_NV bit
	declare @BHYT_NV bit
	declare @BHTN_NV bit
	declare @Phicongdoan_NV bit
	declare @Tongluong int
	declare @Tiendongthue int
	declare @Tienlamthem int
	
	declare @Tongsogioquydinh int
	declare @Tienbatdautinhthue int
	declare @Tienmoinguoiphuthuoc int
	declare @BHXH float
	declare @BHYT float
	declare @BHTN float
	declare @BHXHMAX int
	declare @Phicongdoan float
	declare @PhicongdoanMax int
	
	set @Luongtoithieu = (select Luongtoithieu from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @Tongsogioquydinh = (select Tongsogioquydinh from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @Tienbatdautinhthue = (select Tienbatdautinhthue from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @Tienmoinguoiphuthuoc = (select Tienmoinguoiphuthuoc from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @BHXH = (select BHXH from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @BHYT = (select BHYT from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @BHTN = (select BHTN from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @BHXHMAX = (select BHXHMAX from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @Phicongdoan = (select Phicongdoan from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	set @PhicongdoanMAX = (select PhicongdoanMax from PB_Danhsachbangluong where Mabangluong = @Mabangluong)
	
	set @BHXH_NV = (select BHXH from PB_SoLuong where Mabangluong = @Mabangluong and MaNV = @MaNV)
	set @BHYT_NV = (select BHYT from PB_SoLuong where Mabangluong = @Mabangluong and MaNV = @MaNV)
	set @BHTN_NV = (select BHTN from PB_SoLuong where Mabangluong = @Mabangluong and MaNV = @MaNV)
	set @Phicongdoan_NV = (select Phicongdoan from PB_SoLuong where Mabangluong = @Mabangluong and MaNV = @MaNV)

	set @Tonggiocongthucte = (select Tonggiocongthucte from PB_SoLuong where Mabangluong = @Mabangluong and MaNV = @MaNV)
	set @Nghiphep = (select Nghiphep from PB_SoLuong where Mabangluong = @Mabangluong and MaNV = @MaNV)
	
	set @Tongthuong = (select Tongthuong from PB_SoLuong
						where  Mabangluong = @Mabangluong
							and MaNV = @MaNV)
	set @Tongphucap = (select Tongphucap from PB_SoLuong
						where  Mabangluong = @Mabangluong
							and MaNV = @MaNV)

	--He so luong
	set @Hesoluong = (select Hesoluong from PB_SoLuong
						where  Mabangluong = @Mabangluong
							and MaNV = @MaNV)
	-- Luong co ban
	set @Luongcoban = @Luongtoithieu * @Hesoluong

	

	declare @TienBHXH int
	declare @TienBHYT int
	declare @TienBHTN int
	declare @TienPhicongdoan int
	--TienBHXH
	if (@BHXH_NV = 1)
		begin
			set @TienBHXH = ((@BHXH * @Luongcoban) /100)
			if (@TienBHXH > @BHXHMAX)
				set @TienBHXH = @BHXHMAX
		end
	else
		set @TienBHXH = 0
	--TienBHYT
	if (@BHYT_NV = 1)
		set @TienBHYT = ((@BHYT * @Luongcoban) / 100)
	else
		set @TienBHYT = 0
	--TienBHTN
	if (@BHTN_NV = 1)
		set @TienBHTN = ((@BHTN * @Luongcoban) / 100)
	else
		set @TienBHTN = 0
	--TienPhicongdoan
	if (@Phicongdoan_NV = 1)
		begin
			set @TienPhicongdoan = ((@Phicongdoan * @Luongcoban) / 100)
			if (@TienPhicongdoan > @PhicongdoanMAX)
				set @TienPhicongdoan = @PhicongdoanMAX
		end
	else
		set @TienPhicongdoan = 0

	--Tong luong	
	set @Tongluong = ((@Luongcoban * (@Tonggiocongthucte + @Nghiphep)) / @Tongsogioquydinh
						- @TienBHXH - @TienBHYT - @TienBHTN - @TienPhicongdoan
						+ @Tongthuong + @Tongphucap)


	--Tien dong thue
	set @Tiendongthue = (select Tiendongthue from PB_SoLuong
									where  Mabangluong = @Mabangluong
										and MaNV = @MaNV)
	
	--Phi cong tac
	set @Phicongtac = (select Phicongtac from PB_SoLuong
									where  Mabangluong = @Mabangluong
										and MaNV = @MaNV)
	--Tong tam ung
	set @Tongtamung = (select Tongtamung from PB_SoLuong
									where  Mabangluong = @Mabangluong
										and MaNV = @MaNV)

	--Tongphucap
	set @Tongphucap = (select Tongphucap from PB_SoLuong
									where  Mabangluong = @Mabangluong
										and MaNV = @MaNV)

	--Tongthuong
	set @Tongthuong = (select Tongthuong from PB_SoLuong
									where  Mabangluong = @Mabangluong
										and MaNV = @MaNV)

	--Tienlamthem
	if (select sum(Sotien) from PB_Luonglamthem
				where  Mabangluong = @Mabangluong
					and MaNV = @MaNV) is not null
		set @Tienlamthem = (select sum(Sotien) from PB_Luonglamthem
										where  Mabangluong = @Mabangluong
											and MaNV = @MaNV)
	else set @Tienlamthem = 0

	--Tongkhautru
	if (select sum(Sotien) from PB_KhautruNhanvien
			where  Mabangluong = @Mabangluong
				and MaNV = @MaNV) is not null
		set @Tongkhautru = (select sum(Sotien) from PB_KhautruNhanvien
										where  Mabangluong = @Mabangluong
											and MaNV = @MaNV)
	else set @Tongkhautru = 0

	select Mabangluong = @Mabangluong, MaNV = @MaNV,
		Luongcoban = @Luongcoban,
		Tonggiocongthucte = @Tonggiocongthucte, Nghiphep = @Nghiphep,
		TienBHXH = @TienBHXH, TienBHYT = @TienBHYT, TienBHTN = @TienBHTN, TienPhicongdoan = @TienPhicongdoan,
		Tienluong = ((@Luongcoban * (@Tonggiocongthucte + @Nghiphep)) / @Tongsogioquydinh),
		TienThueTNCN = @Tiendongthue,
		Tongtamung = @Tongtamung,
		Tongphucap = @Tongphucap,
		Tongthuong = @Tongthuong,
		Tongkhautru = @Tongkhautru,
		Tienlamthem = @Tienlamthem,
		Phicongtac = @Phicongtac,
		Thuclanh = (((@Luongcoban * (@Tonggiocongthucte + @Nghiphep)) / @Tongsogioquydinh)
					- @TienBHXH - @TienBHYT - @TienBHTN - @TienPhicongdoan
					- @Tiendongthue - @Tongkhautru - @Tongtamung
					+ @Phicongtac + @Tongthuong + @Tongphucap + @Tienlamthem)
END





GO
/****** Object:  StoredProcedure [dbo].[sp_PB_ToNhom_Tinhsonhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac	
-- Create date: 03-05-2012
-- Description:	Proc tinh lai so nhan vien cua to
-- =============================================
CREATE PROCEDURE [dbo].[sp_PB_ToNhom_Tinhsonhanvien]
	@toid int
AS
BEGIN
	update PB_ToNhom
		set Tongsonhanvien = (select count(MaNV)
								from PB_Nhanvien
								where MaToNhom = @toid)
	where MaToNhom = @toid
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_Backup]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 20/04/2012
-- Description:	Backup database - Override
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_Backup]
	@directory nvarchar(500),
	@filename varchar(100)
AS
BEGIN
	declare @file_directory nvarchar(600)
	set @file_directory = @directory + @filename
	BACKUP DATABASE QLNS
	TO  DISK = @file_directory
	WITH NOFORMAT, INIT,
	NAME = @filename, SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	--exec sp_SYS_Backup 'C:\backup\','qlns.bak'
END


GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_ChangePass]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 11-05-2012
-- Description:	Doi mat khau
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_ChangePass]
	@Username varchar(30),
	@NewPassword nvarchar(50)
AS
BEGIN
	if exists(select Username from SYS_Nguoidung
				where
					 Username = @Username)
	begin
		update SYS_Nguoidung
			set Password = PWDENCRYPT(@NewPassword)
			where Username = @Username
		--Cap nhat thanh cong
		select err=0
		return
	end
	--Mat khau khong hop le
	select err=1
END


GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_CheckLogin]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyễn Phương Bắc
-- Create date: 05/12/2011
-- Description:	Kiểm tra đăng nhập, Nếu đăng nhập thành công sẽ trả ra bảng thông tin về tài khoản
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_CheckLogin]
	@Username varchar(30),
	@Password nvarchar(50)
AS
BEGIN
	if exists (select Username from SYS_Nguoidung where Username=@Username and IsDelete = 0)
	begin
		if exists (select Username from SYS_Nguoidung where Username=@Username and PWDCOMPARE(@Password,Password) = 1)
		begin
			if exists (select Username from SYS_Nguoidung where Username=@Username and IsLock = 0)
				begin
						--Tang so lan dang nhap len de xu ly dang nhap 2 nguoi cung luc
					declare @NumberOfLogin int
					set @NumberOfLogin = (select NumberOfLogin
											from SYS_Nguoidung
											where Username = @Username) + 1
					update SYS_Nguoidung
						set NumberOfLogin = @NumberOfLogin,
							LaterLogin = getdate()
						where Username = @Username

					--Insert vao bang nhat ky he thong
					insert into SYS_Nhatkyhethong values
						(
							@Username,
							getdate(),
							1,
							1,
							null
						)
					select err=0,
							SYS_Nguoidung.ID,
							Email,
							Fullname,
							NumberOfLogin
						from SYS_Nguoidung
						where Username=@Username --Login is success
				end
			else
				select err=3 --Account is locked
		end
		else
			select err=2 --Password is wrong
	end
	else
		select err=1	--Username not exists
END




GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_GetBackPass]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 11-05-2012
-- Description:	Lay lai mat khau
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_GetBackPass]
	@Username varchar(30),
	@CodeResetPassForget uniqueidentifier,
	@NewPassword nvarchar(50)
AS
BEGIN
	if exists (select Username from SYS_Nguoidung
						where Username = @Username
							and CodeResetPassForget = @CodeResetPassForget)
	begin
		update SYS_Nguoidung
			set Password = PWDENCRYPT(@NewPassword),
				CodeResetPassForget = newid()
			where Username = @Username
			--Thay doi mat khau thanh cong
		select err=0
		return
	end
	--CodeResetPass khong dung
	select err=1
END


GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_Nguoidung_Insert]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 11-05-2012
-- Description:	Insert Account
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_Nguoidung_Insert]
	@Username varchar(30),
	@Password nvarchar(50),
	@Email nvarchar(50),
	@Fullname nvarchar(50),
	@IsSuper bit,
	@CreatedByUser nvarchar(255)
AS
BEGIN
	if exists (select Username from SYS_Nguoidung where Username = @Username)
	begin
		--Tai khoan nay da duoc tao
		select err=1
		return
	end
	if exists (select Email from SYS_Nguoidung where Email = @Email)
	begin
		--Email da co nguoi su dung
		select err=2
		return
	end
	insert into SYS_Nguoidung
		values
			(
				newid(),
				@Username,
				PWDENCRYPT(@Password),
				0,
				newid(),
				@Email,
				@Fullname,
				0,
				getdate(),
				1,
				0,
				@IsSuper,
				@CreatedByUser,
				getdate(),
				null
			)
	--Insert thanh cong
	select err=0
END





GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_Nhatkyhethong_Delete]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 13-05-2012
-- Description:	Xoa nhat ky he thong
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_Nhatkyhethong_Delete]
	@Username varchar(30),
	@from datetime,
	@to datetime
AS
BEGIN
	delete from SYS_Nhatkyhethong where Thoigian between @from and @to
	insert into SYS_Nhatkyhethong values
		(
			@Username,
			getdate(),
			38,
			8,
			N'Từ ' + convert(varchar(25),@from) + N' đến ' + convert(varchar(25),@to)
		)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_Nhatkyhethong_Insert]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 13-05-2012
-- Description:	Insert Nhat ky he thong
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_Nhatkyhethong_Insert]
	@Username varchar(30),
	@Chucnang int,
	@Hanhdong int,
	@Doituong nvarchar(255)
AS
BEGIN
	insert into SYS_Nhatkyhethong values
		(
			@Username,
			getdate(),
			@Chucnang,
			@Hanhdong,
			@Doituong
		)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_ReNewPass]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 11-05-2012
-- Description:	Doi mat khau trong truong hop reset lai mat khau thong qua ma xac nhan
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_ReNewPass]
	@Username varchar(30),
	@NewPassword nvarchar(50)
AS
BEGIN
	update SYS_Nguoidung
		set Password = PWDENCRYPT(@NewPassword)
		where Username = @Username
	--Cap nhat thanh cong
	select err=0
END



GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_ResetPass]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 11-05-2012
-- Description:	Reset mat khau cho Account co yeu cau
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_ResetPass]
	@Username varchar(30)
AS
BEGIN
	update SYS_Nguoidung
		set Password = PWDENCRYPT('123456'),
			IsRequireResetPass = 0
		where Username = @Username
	--Reset mat khau thanh cong
END




GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_Restore]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 20/04/2012
-- Description:	Restore database
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_Restore]
	@directoryfilename nvarchar(600)
AS
BEGIN
	RESTORE DATABASE QLNS
	FROM  DISK = @directoryfilename
	WITH  FILE = 1,  NOUNLOAD,  STATS = 10
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_SetFullRoll]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 12-05-2012
-- Description:	Set full quyen cho tai khoan
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_SetFullRoll]
	@UserID uniqueidentifier,
	@CreatedByUser uniqueidentifier
AS
BEGIN
	declare @RollID int	

	--Khai bao cursor
	DECLARE cur_quyen CURSOR
	FOR 
		  SELECT ID FROM SYS_Quyen
	--Mo cursor
	OPEN cur_quyen
	--Doc du lieu
	FETCH NEXT FROM cur_quyen
		INTO @RollID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		  --Xu ly dong moi vua doc duoc
			--Insert vao SYS_Phanquyen
			insert into SYS_Phanquyen values
				(
					@UserID,
					@RollID,
					@CreatedByUser,
					getdate()
				)
			
			--Thuc hien doc tiep cac dong ke
			FETCH NEXT FROM cur_quyen
				INTO @RollID
	END
	--Dong Cursor
	CLOSE cur_quyen
	DEALLOCATE cur_quyen
END


GO
/****** Object:  StoredProcedure [dbo].[sp_SYS_UnInstallRollForUser]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nguyen Phuong Bac
-- Create date: 13-05-2012
-- Description:	Xoa tat ca quyen cua Tai khoan
-- =============================================
CREATE PROCEDURE [dbo].[sp_SYS_UnInstallRollForUser]
	@Username varchar(30)
AS
BEGIN
	declare @UserID uniqueidentifier
	set @UserID = (select ID from SYS_Nguoidung where Username = @Username)
	delete from SYS_PhanQuyen where UserID = @UserID
END

GO
/****** Object:  Table [dbo].[DIC_BacLuong]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_BacLuong](
	[MaNgach] [int] NOT NULL,
	[Bac] [int] NOT NULL,
	[Tenbac] [nvarchar](50) NOT NULL,
	[Heso] [float] NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_BacLuong] PRIMARY KEY CLUSTERED 
(
	[MaNgach] ASC,
	[Bac] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Bangcap]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Bangcap](
	[Mabang] [int] IDENTITY(1,1) NOT NULL,
	[Tenbang] [nvarchar](50) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Bangcap_1] PRIMARY KEY CLUSTERED 
(
	[Mabang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Cauhinhcongthuc]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Cauhinhcongthuc](
	[Macauhinh] [uniqueidentifier] NOT NULL,
	[Ngayapdung] [datetime] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
	[BHXH] [float] NOT NULL,
	[BHYT] [float] NOT NULL,
	[BHTN] [float] NOT NULL,
	[BHXHMAX] [int] NOT NULL,
	[Phicongdoan] [float] NOT NULL,
	[PhicongdoanMax] [int] NOT NULL,
	[TinhThueTNCN] [int] NOT NULL,
	[Chinguoiphuthuoc] [int] NOT NULL,
	[Tangcathuong] [float] NOT NULL,
	[Tangchunhat] [float] NOT NULL,
	[Tangnghile] [float] NOT NULL,
	[Nguoiky] [nvarchar](100) NOT NULL,
	[Chucvunguoiky] [nvarchar](50) NOT NULL,
	[Ngayky] [datetime] NOT NULL,
	[Mota] [ntext] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Baohiem] PRIMARY KEY CLUSTERED 
(
	[Macauhinh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Chucvu]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Chucvu](
	[Machucvu] [int] IDENTITY(1,1) NOT NULL,
	[Tenchucvu] [nvarchar](50) NOT NULL,
	[Captren] [int] NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Chucvu] PRIMARY KEY CLUSTERED 
(
	[Machucvu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Chuyenmon]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Chuyenmon](
	[Machuyenmon] [int] IDENTITY(1,1) NOT NULL,
	[Tenchuyenmon] [nvarchar](50) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Chuyenmon_1] PRIMARY KEY CLUSTERED 
(
	[Machuyenmon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Congviec]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Congviec](
	[Macongviec] [int] IDENTITY(1,1) NOT NULL,
	[Tencongviec] [nvarchar](50) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Congviec_1] PRIMARY KEY CLUSTERED 
(
	[Macongviec] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Dantoc]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Dantoc](
	[Madantoc] [int] IDENTITY(1,1) NOT NULL,
	[Tendantoc] [nvarchar](50) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Dantoc] PRIMARY KEY CLUSTERED 
(
	[Madantoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_NgachLuong]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_NgachLuong](
	[MaNgach] [int] IDENTITY(1,1) NOT NULL,
	[TenNgach] [nvarchar](50) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_NgachLuong] PRIMARY KEY CLUSTERED 
(
	[MaNgach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Ngonngu]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Ngonngu](
	[Mangonngu] [int] IDENTITY(1,1) NOT NULL,
	[Tenngonngu] [nvarchar](50) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Ngonngu] PRIMARY KEY CLUSTERED 
(
	[Mangonngu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Phucap]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Phucap](
	[Maphucap] [int] IDENTITY(1,1) NOT NULL,
	[Tenphucap] [nvarchar](50) NOT NULL,
	[Tienlonnhat] [int] NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_DIC_Phucap] PRIMARY KEY CLUSTERED 
(
	[Maphucap] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Quanhegiadinh]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Quanhegiadinh](
	[Maquanhe] [int] IDENTITY(1,1) NOT NULL,
	[Tenquanhe] [nvarchar](50) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Quanhegiadinh] PRIMARY KEY CLUSTERED 
(
	[Maquanhe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Quoctich]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Quoctich](
	[Maquoctich] [int] IDENTITY(1,1) NOT NULL,
	[Tenquoctich] [nvarchar](50) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Quoctich] PRIMARY KEY CLUSTERED 
(
	[Maquoctich] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Tinhoc]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Tinhoc](
	[MaTH] [int] IDENTITY(1,1) NOT NULL,
	[TenTH] [nvarchar](50) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Tinhoc] PRIMARY KEY CLUSTERED 
(
	[MaTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIC_Tongiao]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIC_Tongiao](
	[MaTG] [int] IDENTITY(1,1) NOT NULL,
	[TenTG] [nvarchar](50) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Tongiao] PRIMARY KEY CLUSTERED 
(
	[MaTG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PB_ChamcongNhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_ChamcongNhanvien](
	[Mabangchamcong] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[Sogiocong] [int] NOT NULL,
	[Sogionghiphep] [int] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Chamcong_1] PRIMARY KEY CLUSTERED 
(
	[Mabangchamcong] ASC,
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Chamnghiphep]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Chamnghiphep](
	[MaNV] [varchar](10) NOT NULL,
	[Namkinhnghiem] [tinyint] NULL,
	[Duocnghipheptrongnam] [tinyint] NULL,
	[T1] [int] NULL,
	[T2] [int] NULL,
	[T3] [int] NULL,
	[T4] [int] NULL,
	[T5] [int] NULL,
	[T6] [int] NULL,
	[T7] [int] NULL,
	[T8] [int] NULL,
	[T9] [int] NULL,
	[T10] [int] NULL,
	[T11] [int] NULL,
	[T12] [int] NULL,
 CONSTRAINT [PK_PB_Chamnghiphep] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Chamtangca]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Chamtangca](
	[Mabangchamcong] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[TCthuong] [int] NOT NULL,
	[TCchunhat] [int] NOT NULL,
	[TCnghile] [int] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Chamtangca_1] PRIMARY KEY CLUSTERED 
(
	[Mabangchamcong] ASC,
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Danhgianhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Danhgianhanvien](
	[Madanhgia] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[Ngay] [datetime] NOT NULL,
	[Tinhthankyluat] [nvarchar](255) NOT NULL,
	[Ketqualamviec] [nvarchar](255) NOT NULL,
	[Daoduc] [nvarchar](255) NOT NULL,
	[Tinhthanhochoi] [nvarchar](255) NOT NULL,
	[Tinhthanlamviec] [nvarchar](255) NOT NULL,
	[Danhgiachung] [nvarchar](255) NOT NULL,
	[Diem] [float] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_Danhgianhanvien] PRIMARY KEY CLUSTERED 
(
	[Madanhgia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Danhsachbangluong]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PB_Danhsachbangluong](
	[Mabangluong] [uniqueidentifier] NOT NULL,
	[Thang] [int] NOT NULL,
	[Nam] [int] NOT NULL,
	[Nguoiky] [nvarchar](40) NULL,
	[Chucvunguoiky] [nvarchar](50) NULL,
	[Ngayky] [datetime] NULL,
	[Luongtoithieu] [int] NOT NULL,
	[Tongsogioquydinh] [int] NOT NULL,
	[Tienbatdautinhthue] [int] NOT NULL,
	[Tienmoinguoiphuthuoc] [int] NOT NULL,
	[Hesothuong] [float] NOT NULL,
	[Hesochunhat] [float] NOT NULL,
	[Hesonghile] [float] NOT NULL,
	[BHXH] [float] NOT NULL,
	[BHYT] [float] NOT NULL,
	[BHTN] [float] NOT NULL,
	[BHXHMAX] [int] NOT NULL,
	[Phicongdoan] [float] NOT NULL,
	[PhicongdoanMax] [int] NOT NULL,
	[IsLock] [bit] NOT NULL,
	[IsFinish] [bit] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_Danhsachbangluong] PRIMARY KEY CLUSTERED 
(
	[Mabangluong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PB_Danhsachchamcong]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PB_Danhsachchamcong](
	[Mabangchamcong] [uniqueidentifier] NOT NULL,
	[Thang] [int] NOT NULL,
	[Nam] [int] NOT NULL,
	[Nguoiky] [nvarchar](40) NULL,
	[Chucvunguoiky] [nvarchar](50) NULL,
	[Ngayky] [datetime] NULL,
	[IsLock] [bit] NOT NULL,
	[IsFinish] [bit] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_Danhsachchamcong] PRIMARY KEY CLUSTERED 
(
	[Mabangchamcong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PB_Dicongtac]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Dicongtac](
	[Macongtac] [int] IDENTITY(1,1) NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[Veviec] [nvarchar](50) NOT NULL,
	[LyDo] [nvarchar](255) NOT NULL,
	[Noicongtac] [nvarchar](100) NOT NULL,
	[Tungay] [datetime] NOT NULL,
	[Denngay] [datetime] NOT NULL,
	[Tiendicongtac] [int] NOT NULL,
	[Nguoiky] [nvarchar](40) NOT NULL,
	[Chucvunguoiky] [nvarchar](50) NOT NULL,
	[Ngayky] [datetime] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_Dicongtac] PRIMARY KEY CLUSTERED 
(
	[Macongtac] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_KhautruNhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_KhautruNhanvien](
	[Mabangluong] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[Makhautru] [int] IDENTITY(1,1) NOT NULL,
	[Tenkhautru] [nvarchar](50) NOT NULL,
	[Sotien] [int] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_KhautruNhanvien] PRIMARY KEY CLUSTERED 
(
	[Mabangluong] ASC,
	[MaNV] ASC,
	[Makhautru] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_KhenthuongNhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_KhenthuongNhanvien](
	[Makhenthuong] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[Ngaykhenthuong] [datetime] NOT NULL,
	[Tenkhenthuong] [nvarchar](50) NOT NULL,
	[LyDo] [nvarchar](100) NOT NULL,
	[Hinhthuckhenthuong] [nvarchar](50) NOT NULL,
	[Sotien] [int] NOT NULL,
	[Nguoiky] [nvarchar](40) NOT NULL,
	[Chucvunguoiky] [nvarchar](50) NOT NULL,
	[Ngayky] [datetime] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_KhenthuongNhanvien] PRIMARY KEY CLUSTERED 
(
	[Makhenthuong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_KyluatNhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_KyluatNhanvien](
	[Makyluat] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[Tenkyluat] [nvarchar](50) NOT NULL,
	[Ngayxayra] [datetime] NOT NULL,
	[Ngaykyluat] [datetime] NOT NULL,
	[Diadiem] [nvarchar](100) NOT NULL,
	[Nguoichungkien] [nvarchar](100) NOT NULL,
	[Motasuviec] [nvarchar](500) NOT NULL,
	[Hinhthuckyluat] [nvarchar](100) NOT NULL,
	[Nguoibikyluatgiaithich] [nvarchar](500) NOT NULL,
	[LyDo] [nvarchar](100) NOT NULL,
	[Nguoiky] [nvarchar](100) NOT NULL,
	[Chucvunguoiky] [nvarchar](50) NOT NULL,
	[Ngayky] [datetime] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_KyluatNhanvien] PRIMARY KEY CLUSTERED 
(
	[Makyluat] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Luonglamthem]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Luonglamthem](
	[Mabangluong] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[Maluonglamthem] [int] IDENTITY(1,1) NOT NULL,
	[Tenluonglamthem] [nvarchar](255) NOT NULL,
	[Sotien] [int] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_Luonglamthem] PRIMARY KEY CLUSTERED 
(
	[Mabangluong] ASC,
	[MaNV] ASC,
	[Maluonglamthem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Luongtangca]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Luongtangca](
	[Mabangluong] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[LuongGio] [int] NOT NULL,
	[Sotangcathuong] [int] NOT NULL,
	[Sotangcachunhat] [int] NOT NULL,
	[Sotangcale] [int] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_Luongtangca] PRIMARY KEY CLUSTERED 
(
	[Mabangluong] ASC,
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Luongtoithieu]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PB_Luongtoithieu](
	[MaLTT] [uniqueidentifier] NOT NULL,
	[Ngayapdung] [datetime] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
	[Sotien] [int] NOT NULL,
	[Nguoiky] [nvarchar](40) NOT NULL,
	[Chucvunguoiky] [nvarchar](50) NOT NULL,
	[Ngayky] [datetime] NOT NULL,
	[Mota] [nvarchar](500) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Luongtoithieu] PRIMARY KEY CLUSTERED 
(
	[MaLTT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PB_Nguoithannhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Nguoithannhanvien](
	[Manguoithan] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[Hotennguoithan] [nvarchar](40) NOT NULL,
	[Quanhe] [int] NOT NULL,
	[Diachi] [nvarchar](100) NOT NULL,
	[Email] [varchar](50) NULL,
	[Dienthoai] [varchar](20) NULL,
	[Phuthuoc] [bit] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Nguoithannhanvien] PRIMARY KEY CLUSTERED 
(
	[Manguoithan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Nhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Nhanvien](
	[MaNV] [varchar](10) NOT NULL,
	[HoNV] [nvarchar](30) NOT NULL,
	[TenNV] [nvarchar](10) NOT NULL,
	[Bidanh] [nvarchar](40) NULL,
	[Nu] [bit] NOT NULL,
	[Hinhanh] [nvarchar](255) NULL,
	[Ngaysinh] [datetime] NOT NULL,
	[Noisinh] [nvarchar](50) NOT NULL,
	[Honnhan] [bit] NOT NULL,
	[Diachi] [nvarchar](100) NOT NULL,
	[Tamtru] [nvarchar](100) NULL,
	[Dienthoaididong] [varchar](20) NULL,
	[Dienthoainha] [varchar](20) NULL,
	[Email] [varchar](50) NULL,
	[SoCMNN] [char](9) NOT NULL,
	[Ngaycap] [datetime] NOT NULL,
	[Noicap] [nvarchar](50) NOT NULL,
	[Ngayvaolam] [datetime] NOT NULL,
	[Suckhoe] [nvarchar](50) NOT NULL,
	[Chieucao] [tinyint] NOT NULL,
	[Cannang] [tinyint] NOT NULL,
	[Tinhtrang] [tinyint] NOT NULL,
	[Maquoctich] [int] NOT NULL,
	[Madantoc] [int] NOT NULL,
	[Matongiao] [int] NOT NULL,
	[Mabangcap] [int] NOT NULL,
	[Mangonngu] [int] NULL,
	[Machuyenmon] [int] NULL,
	[Matinhoc] [int] NULL,
	[MaToNhom] [int] NULL,
	[BHXH] [bit] NOT NULL,
	[BHYT] [bit] NOT NULL,
	[BHTN] [bit] NOT NULL,
	[Phicongdoan] [bit] NOT NULL,
	[GhiChu] [ntext] NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Nhanvien] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Phongban]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Phongban](
	[Maphong] [int] IDENTITY(1,1) NOT NULL,
	[Tenphong] [nvarchar](50) NOT NULL,
	[Dienthoai] [varchar](20) NULL,
	[Tongsonhanvien] [int] NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Phongban] PRIMARY KEY CLUSTERED 
(
	[Maphong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_PhucapNhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_PhucapNhanvien](
	[MaNV] [varchar](10) NOT NULL,
	[Maphucap] [int] NOT NULL,
	[Sotien] [int] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_PhucapNhanvien] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC,
	[Maphucap] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_SoLuong]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_SoLuong](
	[Mabangluong] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[Hesoluong] [float] NOT NULL,
	[Tonggiocongthucte] [int] NOT NULL,
	[Nghiphep] [int] NOT NULL,
	[BHXH] [bit] NOT NULL,
	[BHYT] [bit] NOT NULL,
	[BHTN] [bit] NOT NULL,
	[Phicongdoan] [bit] NOT NULL,
	[Tienthue] [int] NOT NULL,
	[Songuoiphuthuoc] [int] NOT NULL,
	[Sotienconlaichiuthue] [int] NOT NULL,
	[Tiendongthue] [int] NOT NULL,
	[Phicongtac] [int] NOT NULL,
	[Tongtamung] [int] NOT NULL,
	[Tongphucap] [int] NOT NULL,
	[Tongthuong] [int] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Soluong] PRIMARY KEY CLUSTERED 
(
	[Mabangluong] ASC,
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Tainanlaodong]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Tainanlaodong](
	[Matnld] [int] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[Veviec] [nvarchar](50) NOT NULL,
	[LyDo] [nvarchar](255) NOT NULL,
	[Ngayxayra] [datetime] NOT NULL,
	[Diadiem] [nvarchar](100) NOT NULL,
	[Mota] [nvarchar](500) NOT NULL,
	[Thiethai] [nvarchar](500) NOT NULL,
	[Thuongtat] [nvarchar](100) NOT NULL,
	[Boithuong] [nvarchar](500) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_Tainanlaodong] PRIMARY KEY CLUSTERED 
(
	[Matnld] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_TamungNhanvien]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_TamungNhanvien](
	[Matamung] [uniqueidentifier] NOT NULL,
	[MaNV] [varchar](10) NOT NULL,
	[LyDo] [nvarchar](100) NOT NULL,
	[Ngaytamung] [datetime] NOT NULL,
	[Sotien] [int] NOT NULL,
	[Nguoiky] [nvarchar](40) NOT NULL,
	[Chucvunguoiky] [nvarchar](50) NOT NULL,
	[Ngayky] [datetime] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PB_TamungNhanvien] PRIMARY KEY CLUSTERED 
(
	[Matamung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Thaydoibacluong]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Thaydoibacluong](
	[MaNV] [varchar](10) NOT NULL,
	[Ngayapdung] [datetime] NOT NULL,
	[MaNgach] [int] NOT NULL,
	[BacLuong] [int] NOT NULL,
	[Hesoluong] [float] NOT NULL,
	[Nguoiky] [nvarchar](40) NULL,
	[Chucvunguoiky] [nvarchar](50) NULL,
	[Ngayky] [datetime] NOT NULL,
	[LyDo] [nvarchar](100) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
 CONSTRAINT [PK_Thaydoibacluong] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC,
	[Ngayapdung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Thaydoichucvu]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Thaydoichucvu](
	[MaNV] [varchar](10) NOT NULL,
	[Machucvu] [int] NOT NULL,
	[Ngayapdung] [datetime] NOT NULL,
	[Nguoiky] [nvarchar](40) NULL,
	[Chucvunguoiky] [nvarchar](50) NULL,
	[Ngayky] [datetime] NOT NULL,
	[LyDo] [nvarchar](100) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
 CONSTRAINT [PK_Thangchuc] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC,
	[Machucvu] ASC,
	[Ngayapdung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Thaydoicongviec]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Thaydoicongviec](
	[MaNV] [varchar](10) NOT NULL,
	[Macongviec] [int] NOT NULL,
	[Ngayapdung] [datetime] NOT NULL,
	[Nguoiky] [nvarchar](40) NULL,
	[Chucvunguoiky] [nvarchar](50) NULL,
	[Ngayky] [datetime] NOT NULL,
	[LyDo] [nvarchar](100) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
 CONSTRAINT [PK_Thaydoicongviec] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC,
	[Macongviec] ASC,
	[Ngayapdung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Thaydoiphongban]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PB_Thaydoiphongban](
	[MaNV] [varchar](10) NOT NULL,
	[Maphong] [int] NOT NULL,
	[Ngayapdung] [datetime] NOT NULL,
	[Nguoiky] [nvarchar](40) NULL,
	[Chucvunguoiky] [nvarchar](50) NULL,
	[Ngayky] [datetime] NOT NULL,
	[LyDo] [nvarchar](100) NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
 CONSTRAINT [PK_Congviec] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC,
	[Maphong] ASC,
	[Ngayapdung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PB_Thaydoitongsongaychamcong]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PB_Thaydoitongsongaychamcong](
	[Masongay] [uniqueidentifier] NOT NULL,
	[Ngayapdung] [datetime] NOT NULL,
	[Tongsongaychamcong] [tinyint] NOT NULL,
	[Nguoiky] [nvarchar](40) NOT NULL,
	[Chucvunguoiky] [nvarchar](50) NOT NULL,
	[Ngayky] [datetime] NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
 CONSTRAINT [PK_Thaydoisongaychamcong] PRIMARY KEY CLUSTERED 
(
	[Masongay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PB_ToNhom]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PB_ToNhom](
	[MaToNhom] [int] IDENTITY(1,1) NOT NULL,
	[Maphong] [int] NOT NULL,
	[TenToNhom] [nvarchar](50) NULL,
	[Tongsonhanvien] [int] NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ToNhom] PRIMARY KEY CLUSTERED 
(
	[MaToNhom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYS_Chucnang]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_Chucnang](
	[FunctionID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NULL,
 CONSTRAINT [PK_SYS_Chucnang] PRIMARY KEY CLUSTERED 
(
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYS_Hanhdong]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_Hanhdong](
	[ActivityID] [int] NOT NULL,
	[ActivityName] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYS_Hanhdong] PRIMARY KEY CLUSTERED 
(
	[ActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYS_IndexPage]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_IndexPage](
	[ID] [int] NOT NULL,
	[ContentOfIndex] [ntext] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SYS_IndexPage] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYS_Nguoidung]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SYS_Nguoidung](
	[ID] [uniqueidentifier] NOT NULL,
	[Username] [varchar](30) NOT NULL,
	[Password] [varbinary](50) NOT NULL,
	[IsRequireResetPass] [bit] NOT NULL,
	[CodeResetPassForget] [uniqueidentifier] NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Fullname] [nvarchar](50) NOT NULL,
	[NumberOfLogin] [bigint] NOT NULL,
	[LaterLogin] [datetime] NOT NULL,
	[IsLock] [bit] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[IsSuper] [bit] NOT NULL,
	[CreatedByUser] [varchar](255) NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
	[GhiChu] [nvarchar](100) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SYS_Nhatkyhethong]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SYS_Nhatkyhethong](
	[Username] [varchar](30) NOT NULL,
	[Thoigian] [datetime] NOT NULL,
	[Chucnang] [int] NOT NULL,
	[Hanhdong] [int] NOT NULL,
	[Doituong] [nvarchar](255) NULL,
 CONSTRAINT [PK_SYS_Nhatkyhethong] PRIMARY KEY CLUSTERED 
(
	[Username] ASC,
	[Thoigian] ASC,
	[Chucnang] ASC,
	[Hanhdong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SYS_PhanQuyen]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_PhanQuyen](
	[UserID] [uniqueidentifier] NOT NULL,
	[RollID] [int] NOT NULL,
	[CreatedByUser] [uniqueidentifier] NOT NULL,
	[CreatedByDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SYS_PhanQuyen] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[RollID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYS_Quyen]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_Quyen](
	[ID] [int] NOT NULL,
	[Rollname] [nvarchar](50) NOT NULL,
	[Description] [ntext] NOT NULL,
 CONSTRAINT [PK_Quyen] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[View_DIC_Cauhinhcongthuc_HT]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_DIC_Cauhinhcongthuc_HT]
AS
SELECT     Macauhinh, Ngayapdung, IsCurrent, BHXH, BHYT, BHTN, BHXHMAX, Phicongdoan, PhicongdoanMax, TinhThueTNCN, Chinguoiphuthuoc, 
                      Tangcathuong, Tangchunhat, Tangnghile, Nguoiky, Chucvunguoiky, Ngayky, Mota, CreatedByUser, CreatedByDate
FROM         dbo.DIC_Cauhinhcongthuc
WHERE     (IsCurrent = 1 OR
                      IsCurrent IS NULL)

GO
/****** Object:  View [dbo].[View_PB_Luongtoithieu_HT]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_PB_Luongtoithieu_HT]
AS
SELECT     MaLTT, Ngayapdung, IsCurrent, Sotien, Nguoiky, Ngayky, Mota, CreatedByUser, CreatedByDate
FROM         dbo.PB_Luongtoithieu
WHERE     (IsCurrent = 1 OR
                      IsCurrent IS NULL)

GO
/****** Object:  View [dbo].[View_PB_Nhanvien_Thaydoichucvu]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_PB_Nhanvien_Thaydoichucvu]
AS
SELECT     dbo.PB_Nhanvien.MaNV, dbo.PB_Nhanvien.HoNV, dbo.PB_Nhanvien.TenNV, dbo.PB_Nhanvien.Bidanh, dbo.PB_Nhanvien.Nu, 
                      dbo.PB_Nhanvien.Ngaysinh, dbo.PB_Thaydoichucvu.Machucvu, dbo.PB_Thaydoichucvu.IsCurrent, dbo.PB_Thaydoichucvu.Ngayapdung, 
                      dbo.DIC_Chucvu.Tenchucvu, dbo.PB_Nhanvien.Tinhtrang
FROM         dbo.PB_Nhanvien INNER JOIN
                      dbo.PB_Thaydoichucvu ON dbo.PB_Nhanvien.MaNV = dbo.PB_Thaydoichucvu.MaNV INNER JOIN
                      dbo.DIC_Chucvu ON dbo.PB_Thaydoichucvu.Machucvu = dbo.DIC_Chucvu.Machucvu
WHERE     (dbo.PB_Thaydoichucvu.IsCurrent = 1)

GO
/****** Object:  View [dbo].[View_PB_Nhanvien_Thongtincanhan]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_PB_Nhanvien_Thongtincanhan]
AS
SELECT     dbo.PB_Nhanvien.MaNV, dbo.PB_Nhanvien.HoNV, dbo.PB_Nhanvien.TenNV, dbo.PB_Nhanvien.Bidanh, dbo.PB_Nhanvien.Nu, 
                      dbo.PB_Nhanvien.Hinhanh, dbo.PB_Nhanvien.Ngaysinh, dbo.PB_Nhanvien.Noisinh, dbo.PB_Nhanvien.Honnhan, dbo.PB_Nhanvien.Diachi, 
                      dbo.PB_Nhanvien.Tamtru, dbo.PB_Nhanvien.Dienthoaididong, dbo.PB_Nhanvien.Dienthoainha, dbo.PB_Nhanvien.Email, dbo.PB_Nhanvien.SoCMNN, 
                      dbo.PB_Nhanvien.Ngaycap, dbo.PB_Nhanvien.Ngayvaolam, dbo.PB_Nhanvien.Suckhoe, dbo.PB_Nhanvien.Chieucao, dbo.PB_Nhanvien.Cannang, 
                      dbo.PB_Nhanvien.Tinhtrang, dbo.PB_Nhanvien.Maquoctich, dbo.PB_Nhanvien.Madantoc, dbo.PB_Nhanvien.Matongiao, 
                      dbo.PB_Nhanvien.Mabangcap, dbo.PB_Nhanvien.Mangonngu, dbo.PB_Nhanvien.Machuyenmon, dbo.PB_Nhanvien.Matinhoc, 
                      dbo.PB_Nhanvien.GhiChu, dbo.PB_Nhanvien.CreatedByDate, dbo.PB_Nhanvien.CreatedByUser, dbo.DIC_Bangcap.Tenbang, 
                      dbo.DIC_Quoctich.Tenquoctich, dbo.DIC_Tinhoc.TenTH, dbo.DIC_Tongiao.TenTG, dbo.DIC_Chuyenmon.Tenchuyenmon, dbo.DIC_Dantoc.Tendantoc, 
                      dbo.DIC_Ngonngu.Tenngonngu, dbo.PB_Nhanvien.Noicap
FROM         dbo.DIC_Dantoc INNER JOIN
                      dbo.PB_Nhanvien ON dbo.DIC_Dantoc.Madantoc = dbo.PB_Nhanvien.Madantoc INNER JOIN
                      dbo.DIC_Quoctich ON dbo.PB_Nhanvien.Maquoctich = dbo.DIC_Quoctich.Maquoctich INNER JOIN
                      dbo.DIC_Tongiao ON dbo.PB_Nhanvien.Matongiao = dbo.DIC_Tongiao.MaTG INNER JOIN
                      dbo.DIC_Bangcap ON dbo.PB_Nhanvien.Mabangcap = dbo.DIC_Bangcap.Mabang LEFT OUTER JOIN
                      dbo.DIC_Ngonngu ON dbo.PB_Nhanvien.Mangonngu = dbo.DIC_Ngonngu.Mangonngu LEFT OUTER JOIN
                      dbo.DIC_Chuyenmon ON dbo.PB_Nhanvien.Machuyenmon = dbo.DIC_Chuyenmon.Machuyenmon LEFT OUTER JOIN
                      dbo.DIC_Tinhoc ON dbo.PB_Nhanvien.Matinhoc = dbo.DIC_Tinhoc.MaTH

GO
/****** Object:  View [dbo].[View_PB_Nhanvien_Thongtincoban]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_PB_Nhanvien_Thongtincoban]
AS
SELECT     dbo.PB_Nhanvien.MaNV, dbo.PB_Nhanvien.HoNV, dbo.PB_Nhanvien.TenNV, dbo.PB_Nhanvien.Nu, dbo.PB_Nhanvien.Ngaysinh, 
                      dbo.PB_Nhanvien.MaToNhom, dbo.PB_ToNhom.TenToNhom, dbo.PB_Thaydoiphongban.Maphong, dbo.PB_Phongban.Tenphong, 
                      dbo.PB_Thaydoiphongban.IsCurrent AS PhongHT, dbo.PB_Thaydoichucvu.Machucvu, dbo.DIC_Chucvu.Tenchucvu, 
                      dbo.PB_Thaydoichucvu.IsCurrent AS ChucvuHT, dbo.PB_Thaydoicongviec.Macongviec, dbo.DIC_Congviec.Tencongviec, 
                      dbo.PB_Thaydoicongviec.IsCurrent AS CongviecHT, dbo.PB_Nhanvien.Tinhtrang
FROM         dbo.PB_Nhanvien LEFT OUTER JOIN
                      dbo.PB_Phongban INNER JOIN
                      dbo.PB_Thaydoiphongban ON dbo.PB_Phongban.Maphong = dbo.PB_Thaydoiphongban.Maphong ON 
                      dbo.PB_Nhanvien.MaNV = dbo.PB_Thaydoiphongban.MaNV LEFT OUTER JOIN
                      dbo.DIC_Chucvu INNER JOIN
                      dbo.PB_Thaydoichucvu ON dbo.DIC_Chucvu.Machucvu = dbo.PB_Thaydoichucvu.Machucvu ON 
                      dbo.PB_Nhanvien.MaNV = dbo.PB_Thaydoichucvu.MaNV LEFT OUTER JOIN
                      dbo.DIC_Congviec INNER JOIN
                      dbo.PB_Thaydoicongviec ON dbo.DIC_Congviec.Macongviec = dbo.PB_Thaydoicongviec.Macongviec ON 
                      dbo.PB_Nhanvien.MaNV = dbo.PB_Thaydoicongviec.MaNV LEFT OUTER JOIN
                      dbo.PB_ToNhom ON dbo.PB_Nhanvien.MaToNhom = dbo.PB_ToNhom.MaToNhom
WHERE     (dbo.PB_Thaydoiphongban.IsCurrent = 1 OR
                      dbo.PB_Thaydoiphongban.IsCurrent IS NULL) AND (dbo.PB_Thaydoichucvu.IsCurrent = 1 OR
                      dbo.PB_Thaydoichucvu.IsCurrent IS NULL) AND (dbo.PB_Thaydoicongviec.IsCurrent = 1 OR
                      dbo.PB_Thaydoicongviec.IsCurrent IS NULL)

GO
/****** Object:  View [dbo].[View_PB_Nhanvien_Thongtincongviec]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_PB_Nhanvien_Thongtincongviec]
AS
SELECT     dbo.PB_Nhanvien.MaNV, dbo.PB_Nhanvien.HoNV, dbo.PB_Nhanvien.TenNV, dbo.PB_Nhanvien.Nu, dbo.PB_Nhanvien.Tinhtrang, 
                      dbo.PB_Nhanvien.BHXH, dbo.PB_Nhanvien.BHYT, dbo.PB_Nhanvien.BHTN, dbo.PB_Nhanvien.Phicongdoan, dbo.PB_Nhanvien.MaToNhom, 
                      dbo.PB_Thaydoiphongban.Maphong, dbo.PB_Phongban.Tenphong, dbo.PB_Thaydoiphongban.IsCurrent AS PhongbanHT, 
                      dbo.PB_ToNhom.TenToNhom, dbo.PB_Thaydoichucvu.Machucvu, dbo.DIC_Chucvu.Tenchucvu, dbo.PB_Thaydoichucvu.IsCurrent AS ChucvuHT, 
                      dbo.PB_Thaydoicongviec.Macongviec, dbo.DIC_Congviec.Tencongviec, dbo.PB_Thaydoicongviec.IsCurrent AS CongviecHT, 
                      dbo.PB_Thaydoibacluong.MaNgach, dbo.PB_Thaydoibacluong.Hesoluong, dbo.PB_Thaydoibacluong.IsCurrent AS BacluongHT, 
                      dbo.PB_Thaydoibacluong.BacLuong, dbo.PB_Thaydoibacluong.Ngayapdung, dbo.DIC_NgachLuong.TenNgach, dbo.DIC_BacLuong.Tenbac
FROM         dbo.PB_Thaydoicongviec INNER JOIN
                      dbo.DIC_Congviec ON dbo.PB_Thaydoicongviec.Macongviec = dbo.DIC_Congviec.Macongviec RIGHT OUTER JOIN
                      dbo.DIC_BacLuong INNER JOIN
                      dbo.DIC_NgachLuong ON dbo.DIC_BacLuong.MaNgach = dbo.DIC_NgachLuong.MaNgach INNER JOIN
                      dbo.PB_Thaydoibacluong ON dbo.DIC_BacLuong.MaNgach = dbo.PB_Thaydoibacluong.MaNgach AND 
                      dbo.DIC_BacLuong.Bac = dbo.PB_Thaydoibacluong.BacLuong RIGHT OUTER JOIN
                      dbo.PB_ToNhom RIGHT OUTER JOIN
                      dbo.PB_Nhanvien ON dbo.PB_ToNhom.MaToNhom = dbo.PB_Nhanvien.MaToNhom ON dbo.PB_Thaydoibacluong.MaNV = dbo.PB_Nhanvien.MaNV ON 
                      dbo.PB_Thaydoicongviec.MaNV = dbo.PB_Nhanvien.MaNV LEFT OUTER JOIN
                      dbo.PB_Phongban INNER JOIN
                      dbo.PB_Thaydoiphongban ON dbo.PB_Phongban.Maphong = dbo.PB_Thaydoiphongban.Maphong ON 
                      dbo.PB_Nhanvien.MaNV = dbo.PB_Thaydoiphongban.MaNV LEFT OUTER JOIN
                      dbo.DIC_Chucvu INNER JOIN
                      dbo.PB_Thaydoichucvu ON dbo.DIC_Chucvu.Machucvu = dbo.PB_Thaydoichucvu.Machucvu ON 
                      dbo.PB_Nhanvien.MaNV = dbo.PB_Thaydoichucvu.MaNV
WHERE     (dbo.PB_Thaydoiphongban.IsCurrent = 1 OR
                      dbo.PB_Thaydoiphongban.IsCurrent IS NULL) AND (dbo.PB_Thaydoichucvu.IsCurrent = 1 OR
                      dbo.PB_Thaydoichucvu.IsCurrent IS NULL) AND (dbo.PB_Thaydoicongviec.IsCurrent = 1 OR
                      dbo.PB_Thaydoicongviec.IsCurrent IS NULL) AND (dbo.PB_Thaydoibacluong.IsCurrent = 1 OR
                      dbo.PB_Thaydoibacluong.IsCurrent IS NULL)

GO
INSERT [dbo].[DIC_BacLuong] ([MaNgach], [Bac], [Tenbac], [Heso], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (1, 1, N'Bậc 1', 1.52, N'A1-N1', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800A1AD87 AS DateTime))
INSERT [dbo].[DIC_BacLuong] ([MaNgach], [Bac], [Tenbac], [Heso], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (1, 2, N'Bậc 2', 1.2, N'JLNKJ', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800A1B7F7 AS DateTime))
INSERT [dbo].[DIC_BacLuong] ([MaNgach], [Bac], [Tenbac], [Heso], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (1, 3, N'Bậc 3', 1.7, N'ASDF', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800A1D05A AS DateTime))
INSERT [dbo].[DIC_BacLuong] ([MaNgach], [Bac], [Tenbac], [Heso], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (1, 4, N'Bậc 4', 1.8, N'SD', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800A1E95E AS DateTime))
INSERT [dbo].[DIC_BacLuong] ([MaNgach], [Bac], [Tenbac], [Heso], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (2, 1, N'Bậc 1', 1.5, N'A1-N1', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800A292E7 AS DateTime))
INSERT [dbo].[DIC_BacLuong] ([MaNgach], [Bac], [Tenbac], [Heso], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (2, 2, N'Bậc 2', 1.58, N'ASDF', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800A2A2D5 AS DateTime))
SET IDENTITY_INSERT [dbo].[DIC_Bangcap] ON 

INSERT [dbo].[DIC_Bangcap] ([Mabang], [Tenbang], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (1, N'THCS', N'Bằng cấp 2', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A03700F623C1 AS DateTime), 0)
INSERT [dbo].[DIC_Bangcap] ([Mabang], [Tenbang], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (2, N'THCS', N'a', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A03A00DACC72 AS DateTime), 1)
INSERT [dbo].[DIC_Bangcap] ([Mabang], [Tenbang], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (6, N'THPT', N'Trung học phổ thông', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A03900915FA8 AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[DIC_Bangcap] OFF
INSERT [dbo].[DIC_Cauhinhcongthuc] ([Macauhinh], [Ngayapdung], [IsCurrent], [BHXH], [BHYT], [BHTN], [BHXHMAX], [Phicongdoan], [PhicongdoanMax], [TinhThueTNCN], [Chinguoiphuthuoc], [Tangcathuong], [Tangchunhat], [Tangnghile], [Nguoiky], [Chucvunguoiky], [Ngayky], [Mota], [CreatedByUser], [CreatedByDate]) VALUES (N'932b3abe-30b0-4c59-8a95-1e4c56aeca0e', CAST(0x0000A054010AE0EB AS DateTime), 1, 2, 1, 2, 100000000, 1, 300000, 5000000, 1200000, 2, 2, 3, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A05400000000 AS DateTime), N'Lười ghi quá đi ah!
Người sau vào ghi nha!', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A054010AE0EB AS DateTime))
INSERT [dbo].[DIC_Cauhinhcongthuc] ([Macauhinh], [Ngayapdung], [IsCurrent], [BHXH], [BHYT], [BHTN], [BHXHMAX], [Phicongdoan], [PhicongdoanMax], [TinhThueTNCN], [Chinguoiphuthuoc], [Tangcathuong], [Tangchunhat], [Tangnghile], [Nguoiky], [Chucvunguoiky], [Ngayky], [Mota], [CreatedByUser], [CreatedByDate]) VALUES (N'8b19efd2-da6a-4fe6-89cc-6da01c0cbd7a', CAST(0x0000A04900343BC5 AS DateTime), 0, 1.5, 1.2, 1.6, 100000000, 0.5, 300000, 5000000, 1200000, 1.5, 2, 3, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04900000000 AS DateTime), N'Lười ghi quá đi ah!
Người sau vào ghi nha!', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04900343BC5 AS DateTime))
SET IDENTITY_INSERT [dbo].[DIC_Chucvu] ON 

INSERT [dbo].[DIC_Chucvu] ([Machucvu], [Tenchucvu], [Captren], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (1, N'Tổng giám đốc', 0, N'Boss của công ty đó', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A03B00B3C529 AS DateTime), 1)
INSERT [dbo].[DIC_Chucvu] ([Machucvu], [Tenchucvu], [Captren], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (3, N'Giám đốc', 1, N'Dưới cấp Tống', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A03B00B7383E AS DateTime), 1)
INSERT [dbo].[DIC_Chucvu] ([Machucvu], [Tenchucvu], [Captren], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (4, N'Trưởng phòng', 3, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A03F009E3EF3 AS DateTime), 1)
INSERT [dbo].[DIC_Chucvu] ([Machucvu], [Tenchucvu], [Captren], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (5, N'Nhân viên', 4, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A048008A5981 AS DateTime), 1)
INSERT [dbo].[DIC_Chucvu] ([Machucvu], [Tenchucvu], [Captren], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (6, N'Phó phòng', 4, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A048008FADC0 AS DateTime), 1)
INSERT [dbo].[DIC_Chucvu] ([Machucvu], [Tenchucvu], [Captren], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (7, N'Phó giám đốc', 3, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A051011AF287 AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[DIC_Chucvu] OFF
SET IDENTITY_INSERT [dbo].[DIC_Chuyenmon] ON 

INSERT [dbo].[DIC_Chuyenmon] ([Machuyenmon], [Tenchuyenmon], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (1, N'Công nghệ thông tin', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A038015B002C AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[DIC_Chuyenmon] OFF
SET IDENTITY_INSERT [dbo].[DIC_Congviec] ON 

INSERT [dbo].[DIC_Congviec] ([Macongviec], [Tencongviec], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (1, N'Lắp rắp máy', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0380159B3DB AS DateTime), 1)
INSERT [dbo].[DIC_Congviec] ([Macongviec], [Tencongviec], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (2, N'Công nhân hàn', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0380159C455 AS DateTime), 1)
INSERT [dbo].[DIC_Congviec] ([Macongviec], [Tencongviec], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (3, N'Quản lý', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800BD5C59 AS DateTime), 1)
INSERT [dbo].[DIC_Congviec] ([Macongviec], [Tencongviec], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (4, N'Ngồi chơi xơi nước', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800BDA22B AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[DIC_Congviec] OFF
SET IDENTITY_INSERT [dbo].[DIC_Dantoc] ON 

INSERT [dbo].[DIC_Dantoc] ([Madantoc], [Tendantoc], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (1, N'Kinh', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0380159D7A2 AS DateTime), 1)
INSERT [dbo].[DIC_Dantoc] ([Madantoc], [Tendantoc], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (2, N'Tày', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0380159E57A AS DateTime), 1)
INSERT [dbo].[DIC_Dantoc] ([Madantoc], [Tendantoc], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (3, N'Hơ Mông', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A038015C8DA8 AS DateTime), 1)
INSERT [dbo].[DIC_Dantoc] ([Madantoc], [Tendantoc], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (4, N'Thái', N'Dân tộc này đẹp gái lắm đó nha', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A048008B201A AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[DIC_Dantoc] OFF
SET IDENTITY_INSERT [dbo].[DIC_NgachLuong] ON 

INSERT [dbo].[DIC_NgachLuong] ([MaNgach], [TenNgach], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (1, N'A1-N1', N'A1-N1', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A03F00F9F08F AS DateTime))
INSERT [dbo].[DIC_NgachLuong] ([MaNgach], [TenNgach], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (2, N'A1-N2', N'A1-N2', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A03F00F9FF30 AS DateTime))
INSERT [dbo].[DIC_NgachLuong] ([MaNgach], [TenNgach], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (3, N'A2-N1', N'A2-N1', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A03F00FA0A23 AS DateTime))
INSERT [dbo].[DIC_NgachLuong] ([MaNgach], [TenNgach], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (4, N'A2-N2', N'A2-N2', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A03F00FA1232 AS DateTime))
SET IDENTITY_INSERT [dbo].[DIC_NgachLuong] OFF
SET IDENTITY_INSERT [dbo].[DIC_Ngonngu] ON 

INSERT [dbo].[DIC_Ngonngu] ([Mangonngu], [Tenngonngu], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (1, N'Tiếng Anh A', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A038015D09CD AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[DIC_Ngonngu] OFF
SET IDENTITY_INSERT [dbo].[DIC_Phucap] ON 

INSERT [dbo].[DIC_Phucap] ([Maphucap], [Tenphucap], [Tienlonnhat], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (1, N'Đi lại', 1000000, N'Phụ cấp đi lại cho nhân viên', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0490034CEEA AS DateTime))
INSERT [dbo].[DIC_Phucap] ([Maphucap], [Tenphucap], [Tienlonnhat], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (3, N'Độc hại', 1500000, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04900D1D36B AS DateTime))
INSERT [dbo].[DIC_Phucap] ([Maphucap], [Tenphucap], [Tienlonnhat], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (4, N'Chức vụ', 1000000, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04900D1ECF1 AS DateTime))
SET IDENTITY_INSERT [dbo].[DIC_Phucap] OFF
SET IDENTITY_INSERT [dbo].[DIC_Quanhegiadinh] ON 

INSERT [dbo].[DIC_Quanhegiadinh] ([Maquanhe], [Tenquanhe], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (1, N'Bố', N'Cha của nhân viên :)', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A038015DC8E9 AS DateTime), 1)
INSERT [dbo].[DIC_Quanhegiadinh] ([Maquanhe], [Tenquanhe], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (3, N'Anh', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04900F7D93B AS DateTime), 1)
INSERT [dbo].[DIC_Quanhegiadinh] ([Maquanhe], [Tenquanhe], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (4, N'Em', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04900FA3BA6 AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[DIC_Quanhegiadinh] OFF
SET IDENTITY_INSERT [dbo].[DIC_Quoctich] ON 

INSERT [dbo].[DIC_Quoctich] ([Maquoctich], [Tenquoctich], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (1, N'Việt Nam', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A038015E1BA8 AS DateTime), 1)
INSERT [dbo].[DIC_Quoctich] ([Maquoctich], [Tenquoctich], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (2, N'Lào', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A038015E290F AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[DIC_Quoctich] OFF
SET IDENTITY_INSERT [dbo].[DIC_Tinhoc] ON 

INSERT [dbo].[DIC_Tinhoc] ([MaTH], [TenTH], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (1, N'Bằng A', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A038015E5398 AS DateTime), 1)
INSERT [dbo].[DIC_Tinhoc] ([MaTH], [TenTH], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (2, N'Bằng B', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0390092906B AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[DIC_Tinhoc] OFF
SET IDENTITY_INSERT [dbo].[DIC_Tongiao] ON 

INSERT [dbo].[DIC_Tongiao] ([MaTG], [TenTG], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (1, N'Thiên Chúa', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A038015EB585 AS DateTime), 1)
INSERT [dbo].[DIC_Tongiao] ([MaTG], [TenTG], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (2, N'Phật giáo', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A038015EC6D2 AS DateTime), 1)
INSERT [dbo].[DIC_Tongiao] ([MaTG], [TenTG], [GhiChu], [CreatedByUser], [CreatedByDate], [IsActive]) VALUES (4, N'Hindu', N'asdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0390092BB23 AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[DIC_Tongiao] OFF
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000001', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000002', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000003', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000004', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000005', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000006', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000007', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000001', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000002', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000003', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000004', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000005', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000006', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000007', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000001', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000002', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000003', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000004', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000005', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000006', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000007', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000001', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000002', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000003', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000004', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000005', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000006', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000007', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000001', 208, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009F9BC9 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000002', 190, 4, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009FBD67 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000003', 200, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009FA83C AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000004', 200, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009FA83C AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000005', 208, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009F9BC9 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000006', 208, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009F9BC9 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000001', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000002', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000003', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000004', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000005', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000006', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000007', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000001', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000002', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000003', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000004', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000005', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000006', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000007', 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000001', 210, 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05401088F29 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000002', 210, 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05401088F29 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000003', 210, 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05401088F29 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000004', 210, 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05401088F29 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000005', 210, 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05401088F29 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000006', 210, 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05401088F29 AS DateTime))
INSERT [dbo].[PB_ChamcongNhanvien] ([Mabangchamcong], [MaNV], [Sogiocong], [Sogionghiphep], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000007', 210, 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05401088F29 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000001', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000002', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000003', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000004', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000005', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000006', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', N'NV00000007', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000001', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000002', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000003', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000004', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000005', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000006', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', N'NV00000007', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000001', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000002', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000003', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000004', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000005', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000006', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', N'NV00000007', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000001', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000002', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000003', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000004', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000005', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000006', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', N'NV00000007', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000001', 51, 8, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009FD221 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000002', 51, 8, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009FD221 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000003', 45, 0, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009FDCC0 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000004', 51, 8, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009FD221 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000005', 45, 0, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009FDCC0 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', N'NV00000006', 51, 8, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009FD221 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000001', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000002', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000003', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000004', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000005', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000006', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', N'NV00000007', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000001', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000002', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000003', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000004', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000005', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000006', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', N'NV00000007', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000001', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0540107AAAF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000002', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0540107AAAF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000003', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0540107AAAF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000004', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0540107AAAF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000005', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0540107AAAF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000006', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0540107AAAF AS DateTime))
INSERT [dbo].[PB_Chamtangca] ([Mabangchamcong], [MaNV], [TCthuong], [TCchunhat], [TCnghile], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', N'NV00000007', 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0540107AAAF AS DateTime))
INSERT [dbo].[PB_Danhsachbangluong] ([Mabangluong], [Thang], [Nam], [Nguoiky], [Chucvunguoiky], [Ngayky], [Luongtoithieu], [Tongsogioquydinh], [Tienbatdautinhthue], [Tienmoinguoiphuthuoc], [Hesothuong], [Hesochunhat], [Hesonghile], [BHXH], [BHYT], [BHTN], [BHXHMAX], [Phicongdoan], [PhicongdoanMax], [IsLock], [IsFinish], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', 4, 2012, NULL, NULL, NULL, 2100000, 208, 5000000, 1200000, 1.5, 2, 3, 1.5, 1.2, 1.6, 100000000, 0.5, 300000, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_Danhsachchamcong] ([Mabangchamcong], [Thang], [Nam], [Nguoiky], [Chucvunguoiky], [Ngayky], [IsLock], [IsFinish], [CreatedByUser], [CreatedByDate]) VALUES (N'a8974522-31ca-4de8-a301-1db5b53e81a3', 12, 2008, NULL, NULL, NULL, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E7A184 AS DateTime))
INSERT [dbo].[PB_Danhsachchamcong] ([Mabangchamcong], [Thang], [Nam], [Nguoiky], [Chucvunguoiky], [Ngayky], [IsLock], [IsFinish], [CreatedByUser], [CreatedByDate]) VALUES (N'b78cdb56-fe99-4b37-8607-2882bfc5384c', 11, 2009, NULL, NULL, NULL, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520145905F AS DateTime))
INSERT [dbo].[PB_Danhsachchamcong] ([Mabangchamcong], [Thang], [Nam], [Nguoiky], [Chucvunguoiky], [Ngayky], [IsLock], [IsFinish], [CreatedByUser], [CreatedByDate]) VALUES (N'dbeb3255-4365-45d8-8da3-2dc690d0da78', 4, 2009, NULL, NULL, NULL, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014575EF AS DateTime))
INSERT [dbo].[PB_Danhsachchamcong] ([Mabangchamcong], [Thang], [Nam], [Nguoiky], [Chucvunguoiky], [Ngayky], [IsLock], [IsFinish], [CreatedByUser], [CreatedByDate]) VALUES (N'3a6ab00d-d21b-4410-aa6c-4221e899b360', 4, 2010, NULL, NULL, NULL, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A052014683B8 AS DateTime))
INSERT [dbo].[PB_Danhsachchamcong] ([Mabangchamcong], [Thang], [Nam], [Nguoiky], [Chucvunguoiky], [Ngayky], [IsLock], [IsFinish], [CreatedByUser], [CreatedByDate]) VALUES (N'21ab6283-58be-4e59-a98b-8e809c566aea', 4, 2012, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), 1, 1, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009F8E8C AS DateTime))
INSERT [dbo].[PB_Danhsachchamcong] ([Mabangchamcong], [Thang], [Nam], [Nguoiky], [Chucvunguoiky], [Ngayky], [IsLock], [IsFinish], [CreatedByUser], [CreatedByDate]) VALUES (N'ceef8095-2237-4f47-9dc8-b3be11d462c0', 10, 2010, NULL, NULL, NULL, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520146C689 AS DateTime))
INSERT [dbo].[PB_Danhsachchamcong] ([Mabangchamcong], [Thang], [Nam], [Nguoiky], [Chucvunguoiky], [Ngayky], [IsLock], [IsFinish], [CreatedByUser], [CreatedByDate]) VALUES (N'3e3c30ff-270b-4ee3-8919-b7f1f1fa9c08', 4, 2008, NULL, NULL, NULL, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05200E8329C AS DateTime))
INSERT [dbo].[PB_Danhsachchamcong] ([Mabangchamcong], [Thang], [Nam], [Nguoiky], [Chucvunguoiky], [Ngayky], [IsLock], [IsFinish], [CreatedByUser], [CreatedByDate]) VALUES (N'2c85aa56-cba0-45bc-8686-de8b5ad082b0', 5, 2012, NULL, NULL, NULL, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0540107AAAF AS DateTime))
SET IDENTITY_INSERT [dbo].[PB_Dicongtac] ON 

INSERT [dbo].[PB_Dicongtac] ([Macongtac], [MaNV], [Veviec], [LyDo], [Noicongtac], [Tungay], [Denngay], [Tiendicongtac], [Nguoiky], [Chucvunguoiky], [Ngayky], [CreatedByUser], [CreatedByDate]) VALUES (1, N'NV00000004', N'Lâu lâu đi giải trí thôi đó mà', N'Tại người ta nhớ em nên người ta bảo đi!', N'Công ty đầu tư và phát triển kỹ thuật số Lầu Xanh', CAST(0x0000A04A00000000 AS DateTime), CAST(0x0000A04C00000000 AS DateTime), 1200000, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04A00000000 AS DateTime), N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04A00B52F29 AS DateTime))
INSERT [dbo].[PB_Dicongtac] ([Macongtac], [MaNV], [Veviec], [LyDo], [Noicongtac], [Tungay], [Denngay], [Tiendicongtac], [Nguoiky], [Chucvunguoiky], [Ngayky], [CreatedByUser], [CreatedByDate]) VALUES (2, N'NV00000005', N'Đi về quê chơi!', N'Tại em nó nhớ nhà quá đó mà!', N'Hải Dương', CAST(0x0000A04A00000000 AS DateTime), CAST(0x0000A04C00000000 AS DateTime), 0, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04A00000000 AS DateTime), N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04A00C09A09 AS DateTime))
INSERT [dbo].[PB_Dicongtac] ([Macongtac], [MaNV], [Veviec], [LyDo], [Noicongtac], [Tungay], [Denngay], [Tiendicongtac], [Nguoiky], [Chucvunguoiky], [Ngayky], [CreatedByUser], [CreatedByDate]) VALUES (3, N'NV00000006', N'Biên Hòa - Đồng Nai', N'Biên Hòa - Đồng Nai', N'Biên Hòa - Đồng Nai', CAST(0x0000A04B00000000 AS DateTime), CAST(0x0000A04C00000000 AS DateTime), 150000000, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04B00000000 AS DateTime), N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04B00BBD896 AS DateTime))
SET IDENTITY_INSERT [dbo].[PB_Dicongtac] OFF
INSERT [dbo].[PB_KhenthuongNhanvien] ([Makhenthuong], [MaNV], [Ngaykhenthuong], [Tenkhenthuong], [LyDo], [Hinhthuckhenthuong], [Sotien], [Nguoiky], [Chucvunguoiky], [Ngayky], [CreatedByUser], [CreatedByDate]) VALUES (N'7693d470-b579-474d-9e2d-717e207c70aa', N'NV00000001', CAST(0x0000A04A00000000 AS DateTime), N'Thưởng lãnh đạo', N'Dụ được 1 hợp đồng lớn', N'Tiền mặt + Bằng khen', 5000000, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04A00000000 AS DateTime), N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04A00F08E61 AS DateTime))
INSERT [dbo].[PB_KyluatNhanvien] ([Makyluat], [MaNV], [Tenkyluat], [Ngayxayra], [Ngaykyluat], [Diadiem], [Nguoichungkien], [Motasuviec], [Hinhthuckyluat], [Nguoibikyluatgiaithich], [LyDo], [Nguoiky], [Chucvunguoiky], [Ngayky], [CreatedByUser], [CreatedByDate]) VALUES (N'21c9ba57-cc21-47a1-bd25-34859843bdab', N'NV00000005', N'Không mặc đồng phục', CAST(0x0000A05200000000 AS DateTime), CAST(0x0000A05A00000000 AS DateTime), N'Công ty ChangShin Vietnam', N'Nguyễn Thị Kim Hằng, Nguyễn Thị Thu Hiền', N'Không mặc đồng phục.
Không mô tả gì thêm', N'Khiển trách', N'Uhm thì không mặc đồng phục.
Có sao không nào?', N'Không mặc đồng phục', N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A05A00000000 AS DateTime), N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05A00AD767E AS DateTime))
INSERT [dbo].[PB_Luongtangca] ([Mabangluong], [MaNV], [LuongGio], [Sotangcathuong], [Sotangcachunhat], [Sotangcale], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000001', 15951, 51, 8, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_Luongtangca] ([Mabangluong], [MaNV], [LuongGio], [Sotangcathuong], [Sotangcachunhat], [Sotangcale], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000002', 15144, 51, 8, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_Luongtangca] ([Mabangluong], [MaNV], [LuongGio], [Sotangcathuong], [Sotangcachunhat], [Sotangcale], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000003', 15144, 45, 0, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_Luongtangca] ([Mabangluong], [MaNV], [LuongGio], [Sotangcathuong], [Sotangcachunhat], [Sotangcale], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000004', 12115, 51, 8, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_Luongtangca] ([Mabangluong], [MaNV], [LuongGio], [Sotangcathuong], [Sotangcachunhat], [Sotangcale], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000005', 15346, 45, 0, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_Luongtangca] ([Mabangluong], [MaNV], [LuongGio], [Sotangcathuong], [Sotangcachunhat], [Sotangcale], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000006', 15346, 51, 8, 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_Luongtoithieu] ([MaLTT], [Ngayapdung], [IsCurrent], [Sotien], [Nguoiky], [Chucvunguoiky], [Ngayky], [Mota], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (N'801672c2-e303-4e68-8db2-ee7e85b303b1', CAST(0x0000A0490036627F AS DateTime), 1, 2100000, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04900000000 AS DateTime), N'Lười mô tả lắm rồi!', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0490036627F AS DateTime))
INSERT [dbo].[PB_Nguoithannhanvien] ([Manguoithan], [MaNV], [Hotennguoithan], [Quanhe], [Diachi], [Email], [Dienthoai], [Phuthuoc], [CreatedByUser], [CreatedByDate]) VALUES (N'b4742b99-ef4a-40c4-a185-1011c0b4e03c', N'NV00000001', N'Nguyễn Văn Thắng', 4, N'415 - Ấp Tân Bắc - Xã Bình Minh - Huyện Trảng Bom - Tỉnh Đồng Nai', N'', N'', 1, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04900FA508B AS DateTime))
INSERT [dbo].[PB_Nguoithannhanvien] ([Manguoithan], [MaNV], [Hotennguoithan], [Quanhe], [Diachi], [Email], [Dienthoai], [Phuthuoc], [CreatedByUser], [CreatedByDate]) VALUES (N'a18ce090-c7cc-43d5-bff6-12b503b5bf6d', N'NV00000005', N'Lý Vũ Đạt', 3, N'Hải Dượng', N'', N'', 1, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04900FC61EB AS DateTime))
INSERT [dbo].[PB_Nguoithannhanvien] ([Manguoithan], [MaNV], [Hotennguoithan], [Quanhe], [Diachi], [Email], [Dienthoai], [Phuthuoc], [CreatedByUser], [CreatedByDate]) VALUES (N'698c2049-49bb-41d4-850f-44f27a67de92', N'NV00000001', N'Nguyễn Hoài Nam', 3, N'415 - Ấp Tân Bắc - Xã Bình Minh - Huyện Trảng Bom - Tỉnh Đồng Nai', N'', N'', 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04900F7EA92 AS DateTime))
INSERT [dbo].[PB_Nguoithannhanvien] ([Manguoithan], [MaNV], [Hotennguoithan], [Quanhe], [Diachi], [Email], [Dienthoai], [Phuthuoc], [CreatedByUser], [CreatedByDate]) VALUES (N'd58157a4-fca4-429f-800a-d9a243524cdb', N'NV00000001', N'Nguyễn Quốc Việt', 4, N'415 - Ấp Tân Bắc - Xã Bình Minh - Huyện Trảng Bom - Tỉnh Đồng Nai', N'', N'', 1, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04901000523 AS DateTime))
INSERT [dbo].[PB_Nhanvien] ([MaNV], [HoNV], [TenNV], [Bidanh], [Nu], [Hinhanh], [Ngaysinh], [Noisinh], [Honnhan], [Diachi], [Tamtru], [Dienthoaididong], [Dienthoainha], [Email], [SoCMNN], [Ngaycap], [Noicap], [Ngayvaolam], [Suckhoe], [Chieucao], [Cannang], [Tinhtrang], [Maquoctich], [Madantoc], [Matongiao], [Mabangcap], [Mangonngu], [Machuyenmon], [Matinhoc], [MaToNhom], [BHXH], [BHYT], [BHTN], [Phicongdoan], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000001', N'Nguyễn Phương', N'Bắc', N'', 0, N'NV00000001.jpg', CAST(0x0000833E00000000 AS DateTime), N'Đồng Nai', 0, N'415 - Ấp Tân Bắc - Xã Bình Minh - Huyện Trảng Bom - Tỉnh Đồng Nai', N'', N'01218876498', N'0613674482', N'k5cnttnguyenphuongbac@gmail.com', N'113246544', CAST(0x0000A04400000000 AS DateTime), N'Đồng Nai', CAST(0x0000A04401198E5F AS DateTime), N'Cực kỳ tốt', 160, 50, 1, 1, 1, 1, 6, 1, NULL, NULL, NULL, 1, 1, 1, 0, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04500A75922 AS DateTime))
INSERT [dbo].[PB_Nhanvien] ([MaNV], [HoNV], [TenNV], [Bidanh], [Nu], [Hinhanh], [Ngaysinh], [Noisinh], [Honnhan], [Diachi], [Tamtru], [Dienthoaididong], [Dienthoainha], [Email], [SoCMNN], [Ngaycap], [Noicap], [Ngayvaolam], [Suckhoe], [Chieucao], [Cannang], [Tinhtrang], [Maquoctich], [Madantoc], [Matongiao], [Mabangcap], [Mangonngu], [Machuyenmon], [Matinhoc], [MaToNhom], [BHXH], [BHYT], [BHTN], [Phicongdoan], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000002', N'Nguyễn Hoàng Quốc', N'Thái', N'', 0, N'NV00000002.JPG', CAST(0x0000827900000000 AS DateTime), N'Đồng Nai', 0, N'Biên Hòa - Đồng Nai', N'', N'', N'', N'', N'123456789', CAST(0x00009D7400000000 AS DateTime), N'Đồng Nai', CAST(0x0000A04500F2CF6B AS DateTime), N'To khỏe', 168, 65, 1, 1, 3, 4, 6, NULL, NULL, NULL, NULL, 1, 1, 1, 0, N'adsfasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A514C7 AS DateTime))
INSERT [dbo].[PB_Nhanvien] ([MaNV], [HoNV], [TenNV], [Bidanh], [Nu], [Hinhanh], [Ngaysinh], [Noisinh], [Honnhan], [Diachi], [Tamtru], [Dienthoaididong], [Dienthoainha], [Email], [SoCMNN], [Ngaycap], [Noicap], [Ngayvaolam], [Suckhoe], [Chieucao], [Cannang], [Tinhtrang], [Maquoctich], [Madantoc], [Matongiao], [Mabangcap], [Mangonngu], [Machuyenmon], [Matinhoc], [MaToNhom], [BHXH], [BHYT], [BHTN], [Phicongdoan], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000003', N'Nguyễn Thị Kim', N'Hằng', N'', 1, N'NV00000003.JPG', CAST(0x0000828100000000 AS DateTime), N'Đồng Nai', 0, N'Đồng Nai', N'Long Bình - Đồng Nai', N'', N'', N'', N'123456789', CAST(0x0000A03000000000 AS DateTime), N'Đồng Nai', CAST(0x0000A0450108CD9A AS DateTime), N'Gầy quá đi', 158, 43, 1, 1, 1, 2, 6, NULL, NULL, NULL, 1, 1, 1, 1, 1, N'asdf', N'40738b3f-f44b-4fe9-9d5b-38e1be950378', CAST(0x0000A053011A687B AS DateTime))
INSERT [dbo].[PB_Nhanvien] ([MaNV], [HoNV], [TenNV], [Bidanh], [Nu], [Hinhanh], [Ngaysinh], [Noisinh], [Honnhan], [Diachi], [Tamtru], [Dienthoaididong], [Dienthoainha], [Email], [SoCMNN], [Ngaycap], [Noicap], [Ngayvaolam], [Suckhoe], [Chieucao], [Cannang], [Tinhtrang], [Maquoctich], [Madantoc], [Matongiao], [Mabangcap], [Mangonngu], [Machuyenmon], [Matinhoc], [MaToNhom], [BHXH], [BHYT], [BHTN], [Phicongdoan], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000004', N'Nguyễn Thị Thu', N'Hiền', N'Hiền mát', 1, N'NV00000004.JPG', CAST(0x0000824000000000 AS DateTime), N'Đồng Nai', 0, N'Biên Hòa - Đồng Nai', N'', N'321634645', N'', N'canhhongruclua@yahoo.com', N'132135465', CAST(0x0000A04400000000 AS DateTime), N'Đồng Nai', CAST(0x0000A048008C4436 AS DateTime), N'Gấy quá đi ah', 156, 42, 1, 1, 4, 2, 6, NULL, NULL, NULL, NULL, 1, 1, 1, 0, N'Nhân viên gương mẫu', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A048008C4436 AS DateTime))
INSERT [dbo].[PB_Nhanvien] ([MaNV], [HoNV], [TenNV], [Bidanh], [Nu], [Hinhanh], [Ngaysinh], [Noisinh], [Honnhan], [Diachi], [Tamtru], [Dienthoaididong], [Dienthoainha], [Email], [SoCMNN], [Ngaycap], [Noicap], [Ngayvaolam], [Suckhoe], [Chieucao], [Cannang], [Tinhtrang], [Maquoctich], [Madantoc], [Matongiao], [Mabangcap], [Mangonngu], [Machuyenmon], [Matinhoc], [MaToNhom], [BHXH], [BHYT], [BHTN], [Phicongdoan], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000005', N'Vũ Quốc', N'Đạt', N'Đạt đẹp trai', 0, N'NV00000005.JPG', CAST(0x000082EE00000000 AS DateTime), N'Hải Dương', 0, N'Long Bình - Biên Hòa - Đồng Nai', N'', N'', N'', N'', N'132465465', CAST(0x0000A04400000000 AS DateTime), N'Hải Dương', CAST(0x0000A048008DE2ED AS DateTime), N'Very Good', 160, 54, 1, 1, 3, 2, 6, NULL, NULL, NULL, 3, 1, 1, 1, 0, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A048008DF850 AS DateTime))
INSERT [dbo].[PB_Nhanvien] ([MaNV], [HoNV], [TenNV], [Bidanh], [Nu], [Hinhanh], [Ngaysinh], [Noisinh], [Honnhan], [Diachi], [Tamtru], [Dienthoaididong], [Dienthoainha], [Email], [SoCMNN], [Ngaycap], [Noicap], [Ngayvaolam], [Suckhoe], [Chieucao], [Cannang], [Tinhtrang], [Maquoctich], [Madantoc], [Matongiao], [Mabangcap], [Mangonngu], [Machuyenmon], [Matinhoc], [MaToNhom], [BHXH], [BHYT], [BHTN], [Phicongdoan], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000006', N'Trần Thanh', N'Thủy', N'Thủy Dẹp Gái', 0, N'NV00000006.JPG', CAST(0x0000824700000000 AS DateTime), N'Đồng Nai', 0, N'Biên Hòa - Đồng Nai', N'', N'', N'', N'', N'113246544', CAST(0x0000A04500000000 AS DateTime), N'Đồng Nai', CAST(0x0000A04800CCE26F AS DateTime), N'Cực kỳ tốt', 163, 56, 1, 1, 1, 1, 6, NULL, NULL, NULL, NULL, 1, 1, 1, 1, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800CD8AE4 AS DateTime))
INSERT [dbo].[PB_Nhanvien] ([MaNV], [HoNV], [TenNV], [Bidanh], [Nu], [Hinhanh], [Ngaysinh], [Noisinh], [Honnhan], [Diachi], [Tamtru], [Dienthoaididong], [Dienthoainha], [Email], [SoCMNN], [Ngaycap], [Noicap], [Ngayvaolam], [Suckhoe], [Chieucao], [Cannang], [Tinhtrang], [Maquoctich], [Madantoc], [Matongiao], [Mabangcap], [Mangonngu], [Machuyenmon], [Matinhoc], [MaToNhom], [BHXH], [BHYT], [BHTN], [Phicongdoan], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000007', N'Chu Minh', N'Khang', N'Khang khờ', 0, N'NV00000007.JPG', CAST(0x000080F000000000 AS DateTime), N'Đồng Nai', 0, N'Biên Hòa - Đồng Nai', N'', N'', N'', N'', N'123456479', CAST(0x00009D7B00000000 AS DateTime), N'Đồng Nai', CAST(0x0000A04E00A7779A AS DateTime), N'To nhưng không khỏe cho lắm', 165, 65, 1, 1, 1, 2, 6, 1, 1, 2, NULL, 1, 1, 1, 0, N'sdfasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05400DE24B7 AS DateTime))
INSERT [dbo].[PB_Nhanvien] ([MaNV], [HoNV], [TenNV], [Bidanh], [Nu], [Hinhanh], [Ngaysinh], [Noisinh], [Honnhan], [Diachi], [Tamtru], [Dienthoaididong], [Dienthoainha], [Email], [SoCMNN], [Ngaycap], [Noicap], [Ngayvaolam], [Suckhoe], [Chieucao], [Cannang], [Tinhtrang], [Maquoctich], [Madantoc], [Matongiao], [Mabangcap], [Mangonngu], [Machuyenmon], [Matinhoc], [MaToNhom], [BHXH], [BHYT], [BHTN], [Phicongdoan], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000008', N'Hoàng Bảo', N'Trung', N'Bảo Trang', 0, NULL, CAST(0x0000834000000000 AS DateTime), N'Đồng Nai', 0, N'Biên Hòa - Đồng Nai', N'', N'01688786834', N'', N'', N'123456798', CAST(0x00009A9D00000000 AS DateTime), N'Đồng Nai', CAST(0x0000A05D00AAF7E2 AS DateTime), N'Gầy lắm', 160, 50, 1, 1, 1, 1, 6, 1, 1, 2, NULL, 1, 1, 1, 0, N'Nhân viên này có tiền sử bệnh tim', N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', CAST(0x0000A05D00AAF7E2 AS DateTime))
SET IDENTITY_INSERT [dbo].[PB_Phongban] ON 

INSERT [dbo].[PB_Phongban] ([Maphong], [Tenphong], [Dienthoai], [Tongsonhanvien], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (1, N'Nhân sự', N'0613674482', 1, N'Phòng này là nhân sự nè', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04600F759B7 AS DateTime))
INSERT [dbo].[PB_Phongban] ([Maphong], [Tenphong], [Dienthoai], [Tongsonhanvien], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (2, N'Kế toán', N'1321345', 2, N'Phòng tính tiền nè!a', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04600F8D897 AS DateTime))
INSERT [dbo].[PB_Phongban] ([Maphong], [Tenphong], [Dienthoai], [Tongsonhanvien], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (4, N'Tổng giám đốc', N'1324564546', 1, N'Phòng của Boss', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800867560 AS DateTime))
SET IDENTITY_INSERT [dbo].[PB_Phongban] OFF
INSERT [dbo].[PB_PhucapNhanvien] ([MaNV], [Maphucap], [Sotien], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000001', 1, 1000000, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04900CC7C01 AS DateTime))
INSERT [dbo].[PB_PhucapNhanvien] ([MaNV], [Maphucap], [Sotien], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000004', 1, 500000, N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', CAST(0x0000A05B016440CE AS DateTime))
INSERT [dbo].[PB_PhucapNhanvien] ([MaNV], [Maphucap], [Sotien], [CreatedByUser], [CreatedByDate]) VALUES (N'NV00000005', 3, 1500000, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04900D21B82 AS DateTime))
INSERT [dbo].[PB_SoLuong] ([Mabangluong], [MaNV], [Hesoluong], [Tonggiocongthucte], [Nghiphep], [BHXH], [BHYT], [BHTN], [Phicongdoan], [Tienthue], [Songuoiphuthuoc], [Sotienconlaichiuthue], [Tiendongthue], [Phicongtac], [Tongtamung], [Tongphucap], [Tongthuong], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000001', 1.58, 208, 0, 1, 1, 1, 0, 0, 2, 0, 0, 0, 0, 1000000, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_SoLuong] ([Mabangluong], [MaNV], [Hesoluong], [Tonggiocongthucte], [Nghiphep], [BHXH], [BHYT], [BHTN], [Phicongdoan], [Tienthue], [Songuoiphuthuoc], [Sotienconlaichiuthue], [Tiendongthue], [Phicongtac], [Tongtamung], [Tongphucap], [Tongthuong], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000002', 1.5, 190, 4, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_SoLuong] ([Mabangluong], [MaNV], [Hesoluong], [Tonggiocongthucte], [Nghiphep], [BHXH], [BHYT], [BHTN], [Phicongdoan], [Tienthue], [Songuoiphuthuoc], [Sotienconlaichiuthue], [Tiendongthue], [Phicongtac], [Tongtamung], [Tongphucap], [Tongthuong], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000003', 1.5, 200, 8, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_SoLuong] ([Mabangluong], [MaNV], [Hesoluong], [Tonggiocongthucte], [Nghiphep], [BHXH], [BHYT], [BHTN], [Phicongdoan], [Tienthue], [Songuoiphuthuoc], [Sotienconlaichiuthue], [Tiendongthue], [Phicongtac], [Tongtamung], [Tongphucap], [Tongthuong], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000004', 1.2, 200, 8, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_SoLuong] ([Mabangluong], [MaNV], [Hesoluong], [Tonggiocongthucte], [Nghiphep], [BHXH], [BHYT], [BHTN], [Phicongdoan], [Tienthue], [Songuoiphuthuoc], [Sotienconlaichiuthue], [Tiendongthue], [Phicongtac], [Tongtamung], [Tongphucap], [Tongthuong], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000005', 1.52, 208, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1500000, 1500000, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_SoLuong] ([Mabangluong], [MaNV], [Hesoluong], [Tonggiocongthucte], [Nghiphep], [BHXH], [BHYT], [BHTN], [Phicongdoan], [Tienthue], [Songuoiphuthuoc], [Sotienconlaichiuthue], [Tiendongthue], [Phicongtac], [Tongtamung], [Tongphucap], [Tongthuong], [CreatedByUser], [CreatedByDate]) VALUES (N'fba145e4-bbcf-41fd-b59d-c78cb155efe7', N'NV00000006', 1.52, 208, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A8743B AS DateTime))
INSERT [dbo].[PB_TamungNhanvien] ([Matamung], [MaNV], [LyDo], [Ngaytamung], [Sotien], [Nguoiky], [Chucvunguoiky], [Ngayky], [CreatedByUser], [CreatedByDate]) VALUES (N'36dcda91-3293-45cc-944b-6b9c846049b7', N'NV00000004', N'Lấy tiền mua quà cho con', CAST(0x0000A04A00000000 AS DateTime), 1500000, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04900000000 AS DateTime), N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04A00F94C3D AS DateTime))
INSERT [dbo].[PB_TamungNhanvien] ([Matamung], [MaNV], [LyDo], [Ngaytamung], [Sotien], [Nguoiky], [Chucvunguoiky], [Ngayky], [CreatedByUser], [CreatedByDate]) VALUES (N'ab82ff39-285c-400e-9fab-7e75769c561f', N'NV00000005', N'Lấy tiền bao gái :D', CAST(0x0000A04100000000 AS DateTime), 1500000, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04100000000 AS DateTime), N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A9BAAC AS DateTime))
INSERT [dbo].[PB_Thaydoibacluong] ([MaNV], [Ngayapdung], [MaNgach], [BacLuong], [Hesoluong], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000001', CAST(0x0000A04E009EE3E4 AS DateTime), 2, 2, 1.58, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'FASDF', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009EE3E9 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoibacluong] ([MaNV], [Ngayapdung], [MaNgach], [BacLuong], [Hesoluong], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000002', CAST(0x0000A04E00A86EAA AS DateTime), 2, 1, 1.5, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'sfsdf', N'asdfasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A86EAA AS DateTime), 1)
INSERT [dbo].[PB_Thaydoibacluong] ([MaNV], [Ngayapdung], [MaNgach], [BacLuong], [Hesoluong], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000003', CAST(0x0000A04E00A02327 AS DateTime), 2, 1, 1.5, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'SDFSAF', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A02327 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoibacluong] ([MaNV], [Ngayapdung], [MaNgach], [BacLuong], [Hesoluong], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000004', CAST(0x0000A04E009E9324 AS DateTime), 1, 2, 1.2, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'czczc', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009E9324 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoibacluong] ([MaNV], [Ngayapdung], [MaNgach], [BacLuong], [Hesoluong], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000005', CAST(0x0000A04E009F1C66 AS DateTime), 1, 1, 1.52, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'ADASD', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009F1C66 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoibacluong] ([MaNV], [Ngayapdung], [MaNgach], [BacLuong], [Hesoluong], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000006', CAST(0x0000A04E00A05F81 AS DateTime), 1, 1, 1.52, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'ASDFASDF', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E00A05F81 AS DateTime), 0)
INSERT [dbo].[PB_Thaydoibacluong] ([MaNV], [Ngayapdung], [MaNgach], [BacLuong], [Hesoluong], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000006', CAST(0x0000A04F00863D82 AS DateTime), 1, 2, 1.2, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'sdf', N'fasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00863D82 AS DateTime), 0)
INSERT [dbo].[PB_Thaydoibacluong] ([MaNV], [Ngayapdung], [MaNgach], [BacLuong], [Hesoluong], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000006', CAST(0x0000A04F00865351 AS DateTime), 1, 2, 1.2, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'gsdgdf', N'gdfsg', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00865351 AS DateTime), 0)
INSERT [dbo].[PB_Thaydoibacluong] ([MaNV], [Ngayapdung], [MaNgach], [BacLuong], [Hesoluong], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000006', CAST(0x0000A04F00876686 AS DateTime), 1, 1, 1.52, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'sadf', N'asdfasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00876686 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoichucvu] ([MaNV], [Machucvu], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000001', 1, CAST(0x0000A04800844E85 AS DateTime), N'<b>Hệ thống</b>', N'<b>Hệ thống</b>', CAST(0x0000A04800000000 AS DateTime), N'Khởi tạo lần đầu', N'Boss nè', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04800844E85 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoichucvu] ([MaNV], [Machucvu], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000002', 3, CAST(0x0000A048008643DD AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04800000000 AS DateTime), N'Mới gia nhập công ty', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A048008643DD AS DateTime), 1)
INSERT [dbo].[PB_Thaydoichucvu] ([MaNV], [Machucvu], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000003', 4, CAST(0x0000A0480085DF02 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04800000000 AS DateTime), N'Mới gia nhập công ty', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0480085DF02 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoichucvu] ([MaNV], [Machucvu], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000004', 6, CAST(0x0000A048008FD90E AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04800000000 AS DateTime), N'Mới mà', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A048008FD90E AS DateTime), 1)
INSERT [dbo].[PB_Thaydoichucvu] ([MaNV], [Machucvu], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000005', 3, CAST(0x0000A048008E4383 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04800000000 AS DateTime), N'Mới mà', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A048008E4383 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoichucvu] ([MaNV], [Machucvu], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000006', 5, CAST(0x0000A04F0084AB5B AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'asdfasdf', N'asdfsadf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F0084AB5B AS DateTime), 0)
INSERT [dbo].[PB_Thaydoichucvu] ([MaNV], [Machucvu], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000006', 6, CAST(0x0000A04F0084BBA2 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'asdfasd', N'asdfasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F0084BBA2 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoichucvu] ([MaNV], [Machucvu], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000007', 4, CAST(0x0000A04F008A4F32 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'asdfasdf', N'asdfsdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F008A4F32 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoicongviec] ([MaNV], [Macongviec], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000001', 4, CAST(0x0000A04E009EF6A9 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'SDFASDF', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009EF6A9 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoicongviec] ([MaNV], [Macongviec], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000005', 3, CAST(0x0000A04E009F2A47 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'ASDFSD', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009F2A47 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoicongviec] ([MaNV], [Macongviec], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000006', 1, CAST(0x0000A04F0084F17C AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'dsfa', N'asdfasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F0084F181 AS DateTime), 0)
INSERT [dbo].[PB_Thaydoicongviec] ([MaNV], [Macongviec], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000006', 4, CAST(0x0000A04F00850116 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'sdASD', N'asdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00850116 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoiphongban] ([MaNV], [Maphong], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000001', 4, CAST(0x0000A04F0091F711 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'sfasdf', N'asdfasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F0091F711 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoiphongban] ([MaNV], [Maphong], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000003', 1, CAST(0x0000A04F0092AEE7 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'hgh', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F0092AEE7 AS DateTime), 0)
INSERT [dbo].[PB_Thaydoiphongban] ([MaNV], [Maphong], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000003', 2, CAST(0x0000A04F00924020 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'sdfas', N'asdfasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00924020 AS DateTime), 0)
INSERT [dbo].[PB_Thaydoiphongban] ([MaNV], [Maphong], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000003', 2, CAST(0x0000A04F00930B6D AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04F00000000 AS DateTime), N'sdfasdf', N'asdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00930B6D AS DateTime), 1)
INSERT [dbo].[PB_Thaydoiphongban] ([MaNV], [Maphong], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000004', 1, CAST(0x0000A04E009D85AA AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'sdsdfasdf', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009D85AA AS DateTime), 0)
INSERT [dbo].[PB_Thaydoiphongban] ([MaNV], [Maphong], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000004', 1, CAST(0x0000A04E009DA122 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'sdafsdf', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009DA122 AS DateTime), 0)
INSERT [dbo].[PB_Thaydoiphongban] ([MaNV], [Maphong], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000004', 2, CAST(0x0000A04E009D92E3 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'sdfadfasdf', N'gfasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009D92E3 AS DateTime), 0)
INSERT [dbo].[PB_Thaydoiphongban] ([MaNV], [Maphong], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000004', 2, CAST(0x0000A04E009E099C AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'fsdf', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009E099C AS DateTime), 1)
INSERT [dbo].[PB_Thaydoiphongban] ([MaNV], [Maphong], [Ngayapdung], [Nguoiky], [Chucvunguoiky], [Ngayky], [LyDo], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'NV00000005', 1, CAST(0x0000A04E009F3C88 AS DateTime), N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04E00000000 AS DateTime), N'SDFASDF', N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04E009F3C88 AS DateTime), 1)
INSERT [dbo].[PB_Thaydoitongsongaychamcong] ([Masongay], [Ngayapdung], [Tongsongaychamcong], [Nguoiky], [Chucvunguoiky], [Ngayky], [GhiChu], [CreatedByUser], [CreatedByDate], [IsCurrent]) VALUES (N'60a4e6db-e8ed-4c92-a507-b6a2ad398ad7', CAST(0x0000A04D00D47E25 AS DateTime), 26, N'Nguyễn Phương Bắc', N'Tổng giám đốc', CAST(0x0000A04D00000000 AS DateTime), N'asdfasdf', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04D00D47E59 AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[PB_ToNhom] ON 

INSERT [dbo].[PB_ToNhom] ([MaToNhom], [Maphong], [TenToNhom], [Tongsonhanvien], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (1, 2, N'Tổ tính lương', 1, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A046010A8E98 AS DateTime))
INSERT [dbo].[PB_ToNhom] ([MaToNhom], [Maphong], [TenToNhom], [Tongsonhanvien], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (2, 2, N'Tổ phát tạm ứng', 0, N'Tổ chuyên cung cấp tạm ứng!s', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A046010DCC3E AS DateTime))
INSERT [dbo].[PB_ToNhom] ([MaToNhom], [Maphong], [TenToNhom], [Tongsonhanvien], [GhiChu], [CreatedByUser], [CreatedByDate]) VALUES (3, 1, N'Tổ chấm công', 1, N'', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A046010DE80A AS DateTime))
SET IDENTITY_INSERT [dbo].[PB_ToNhom] OFF
SET IDENTITY_INSERT [dbo].[SYS_Chucnang] ON 

INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (1, N'Hệ thống', N'Đăng nhập, Đăng xuất, Thay đổi mật khẩu')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (2, N'Quản lý tài khoản', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (3, N'Cập nhật thông tin tài khoản', N'Xem, Tạo, Cập nhật, Xóa, Reset mật khẩu')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (4, N'Trang chủ', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (5, N'Danh sách nhân viên', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (6, N'Cập nhật thông tin cá nhân nhân viên', N'Xem, Tạo, Cập nhật, Xóa')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (7, N'Chi tiết nhân viên', N'Xem, Cập nhật')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (8, N'Chuyển phòng nhân viên', N'Xem, Cập nhật')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (9, N'Thay đổi chức vụ nhân viên', N'Xem, Cập nhật')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (10, N'Thay đổi công việc nhân viên', N'Xem, Cập nhật')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (11, N'Thay đổi ngạch - bậc nhân viên', N'Xem, Cập nhật')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (12, N'Cập nhật phụ cấp nhân viên', N'Xem, Cập nhật, Xóa')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (13, N'Cập nhật người thân nhân viên', N'Xem, Cập nhật, Xóa')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (14, N'Danh sách đi công tác', N'Xem, Tạo')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (15, N'Danh sách khen thưởng', N'Xem, Tạo')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (16, N'Danh sách kỷ luật', N'Xem, Tạo')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (17, N'Danh sách tạm ứng', N'Xem, Tạo')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (18, N'Danh sách bảng chấm công', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (19, N'Cập nhật thông tin bảng chấm công', N'Tạo, Cập nhật (bảng chấm công nào)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (20, N'Cập nhật chấm công ngày', N'Cập nhật (bảng chấm công nào)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (21, N'Cập nhật chấm công tăng ca', N'Cập nhật (bảng chấm công nào)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (22, N'Danh sách bảng lương', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (23, N'Cập nhật thông tin bảng lương', N'Tạo, Cập nhật (bảng lương nào)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (24, N'Lương làm thêm', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (25, N'Cập nhật thông tin làm thêm', N'Tạo')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (26, N'Khấu trừ lương', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (27, N'Cập nhật thông tin khấu trừ lương', N'Tạo')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (28, N'Cập nhật thông tin phòng ban', N'Xem, Tạo, Cập nhật, Xóa (Tên phòng ban)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (29, N'Cập nhật thông tin tổ - nhóm', N'Xem, Tạo, Cập nhật, Xóa (Tên tổ - nhóm)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (30, N'Cập nhật thông tin chức vụ', N'Xem, Tạo, Cập nhật, Xóa (Tên chức vụ)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (31, N'Công thức tính lương', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (32, N'Cập nhật công thức tính lương', N'Tạo (Mã bảng công thức)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (33, N'Lương tối thiểu', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (34, N'Cập nhật lương tối thiểu', N'Tạo (Mã lương tối thiểu)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (35, N'Quy định số ngày chấm công', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (36, N'Cập nhật số ngày chấm công', N'Tạo (Mã QĐ số ngày chấm công)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (37, N'Giải trí', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (38, N'Nhật ký hệ thống', N'Xem, Xóa (Từ ngày nào đến ngày nào)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (39, N'Thông tin tài khoản', N'Xem, Cập nhật')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (40, N'Thay đổi mật khẩu', N'Cập nhật')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (41, N'Phân quyền', N'Xem, Cập nhật')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (42, N'Bảng lương ngày', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (43, N'Bảng lương tăng ca', N'Xem')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (44, N'Cập nhật bậc lương', N'Tạo, Cập nhật, Xóa (Tên bậc lương)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (45, N'Cập nhật ngạch lương', N'Tạo, Cập nhật, Xóa (Tên ngạch)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (46, N'Cập nhật bằng cấp', N'Tạo, Cập nhật, Xóa (Tên bằng cấp)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (47, N'Cập nhật chuyên môn', N'Tạo, Cập nhật, Xóa (Tên chuyên môn)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (48, N'Cập nhật công việc', N'Tạo, Cập nhật, Xóa (Tên công việc)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (49, N'Cập nhật dân tộc', N'Tạo, Cập nhật, Xóa (Tên dân tộc)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (50, N'Cập nhật ngôn ngữ', N'Tạo, Cập nhật, Xóa (Tên ngôn ngữ)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (51, N'Cập nhật phụ cấp', N'Tạo, Cập nhật, Xóa (Tên phụ cấp)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (52, N'Cập nhật quan hệ gia đình', N'Tạo, Cập nhật, Xóa (Tên quan hệ)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (53, N'Cập nhật quốc tịch', N'Tạo, Cập nhật, Xóa (Tên quốc tịch)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (54, N'Cập nhật tin học', N'Tạo, Cập nhật, Xóa (Tên tin học)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (55, N'Cập nhật tôn giáo', N'Tạo, Cập nhật, Xóa (Tên tôn giáo)')
INSERT [dbo].[SYS_Chucnang] ([FunctionID], [Name], [Description]) VALUES (56, N'Cập nhật trang chủ', N'Cập nhật')
SET IDENTITY_INSERT [dbo].[SYS_Chucnang] OFF
INSERT [dbo].[SYS_Hanhdong] ([ActivityID], [ActivityName]) VALUES (1, N'Đăng nhập')
INSERT [dbo].[SYS_Hanhdong] ([ActivityID], [ActivityName]) VALUES (2, N'Đăng xuất')
INSERT [dbo].[SYS_Hanhdong] ([ActivityID], [ActivityName]) VALUES (3, N'Thay đổi mật khẩu')
INSERT [dbo].[SYS_Hanhdong] ([ActivityID], [ActivityName]) VALUES (4, N'Reset mật khẩu')
INSERT [dbo].[SYS_Hanhdong] ([ActivityID], [ActivityName]) VALUES (5, N'Xem')
INSERT [dbo].[SYS_Hanhdong] ([ActivityID], [ActivityName]) VALUES (6, N'Tạo')
INSERT [dbo].[SYS_Hanhdong] ([ActivityID], [ActivityName]) VALUES (7, N'Cập nhật')
INSERT [dbo].[SYS_Hanhdong] ([ActivityID], [ActivityName]) VALUES (8, N'Xóa')
INSERT [dbo].[SYS_IndexPage] ([ID], [ContentOfIndex], [CreatedByUser], [CreatedByDate]) VALUES (1, N'<p style="text-align: center;">
	<img alt="ko thay" src="http://i1176.photobucket.com/albums/x324/phuongbac3674/Bacs%20album%20o%20Vung%20Tau/P1030043.jpg" style="width: 458px; height: 343px;" /></p>
<p style="text-align: center;">
	<span style="font-size:14px;">Đường đi đến c&ocirc;ng ty TNHH Changshen Vietnam</span></p>', N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05400DC7DF6 AS DateTime))
INSERT [dbo].[SYS_Nguoidung] ([ID], [Username], [Password], [IsRequireResetPass], [CodeResetPassForget], [Email], [Fullname], [NumberOfLogin], [LaterLogin], [IsLock], [IsDelete], [IsSuper], [CreatedByUser], [CreatedByDate], [GhiChu]) VALUES (N'baaa95a2-c3da-446a-acc8-1110190ae338', N'sakura', 0x0100F11E296C10B80C0653147C6730715D5891B9E0952D3E14FD, 0, N'8e269167-b580-4e84-91ad-0cbd5d7e2bc4', N'admin@gmail.com', N'Vũ Anh Đức', 17, CAST(0x0000A8470008858F AS DateTime), 0, 0, 1, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0510104900E AS DateTime), NULL)
INSERT [dbo].[SYS_Nguoidung] ([ID], [Username], [Password], [IsRequireResetPass], [CodeResetPassForget], [Email], [Fullname], [NumberOfLogin], [LaterLogin], [IsLock], [IsDelete], [IsSuper], [CreatedByUser], [CreatedByDate], [GhiChu]) VALUES (N'40738b3f-f44b-4fe9-9d5b-38e1be950378', N'nguyenthikimhang', 0x0100B026A4DE7C4937F8B467CB13CF6115734EDA2EE4495058D0, 0, N'13b0e644-0112-46e4-9b47-7f8b7e1df25b', N'luckystar200726@yahoo.com', N'Nguyễn Thị Kim Hằng', 31, CAST(0x0000A06000B2F3D7 AS DateTime), 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05201559B14 AS DateTime), N'a')
INSERT [dbo].[SYS_Nguoidung] ([ID], [Username], [Password], [IsRequireResetPass], [CodeResetPassForget], [Email], [Fullname], [NumberOfLogin], [LaterLogin], [IsLock], [IsDelete], [IsSuper], [CreatedByUser], [CreatedByDate], [GhiChu]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', N'phuongbac3674', 0x0100E9A050BFB4E270CF5239A71B365BFCC22B1E1121283B640D, 0, N'02e3c5ba-2158-4ed8-abad-2fc426c7a1dc', N'phuongbac3674@yahoo.com', N'Nguyễn Phương Bắc 3674', 1, CAST(0x0000A06001066B19 AS DateTime), 0, 0, 1, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A06001059598 AS DateTime), NULL)
INSERT [dbo].[SYS_Nguoidung] ([ID], [Username], [Password], [IsRequireResetPass], [CodeResetPassForget], [Email], [Fullname], [NumberOfLogin], [LaterLogin], [IsLock], [IsDelete], [IsSuper], [CreatedByUser], [CreatedByDate], [GhiChu]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', N'adminnguyenphuongbac', 0x01000453E32FE8792E244C37F47E2AC66DCAA345FD3015C0A531, 0, N'ce7d5d39-aff2-40bc-994e-9c7ba3481748', N'nguyenphuongbacmanagement@gmail.com', N'Nguyễn Phương Bắc', 226, CAST(0x0000A06001052301 AS DateTime), 0, 0, 1, N'-1', CAST(0x0000A04E00EC7C61 AS DateTime), NULL)
INSERT [dbo].[SYS_Nguoidung] ([ID], [Username], [Password], [IsRequireResetPass], [CodeResetPassForget], [Email], [Fullname], [NumberOfLogin], [LaterLogin], [IsLock], [IsDelete], [IsSuper], [CreatedByUser], [CreatedByDate], [GhiChu]) VALUES (N'c19797a9-04d3-4225-a34d-d0c1aa5f4d2a', N'vaylaminhchiatay', 0x010057A01C18C8241FDD94B17E1422279DED6DAC289C52929472, 0, N'59c5e0af-013c-4c84-9795-790ee24f5b97', N'vaylaminhchiatay@gmail.com', N'vaylaminhchiatay', 1, CAST(0x0000A052011292D6 AS DateTime), 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05100A2A971 AS DateTime), NULL)
INSERT [dbo].[SYS_Nguoidung] ([ID], [Username], [Password], [IsRequireResetPass], [CodeResetPassForget], [Email], [Fullname], [NumberOfLogin], [LaterLogin], [IsLock], [IsDelete], [IsSuper], [CreatedByUser], [CreatedByDate], [GhiChu]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', N'admin', 0x01004300B9F7752F442CFCD701F4D870390399BE3ACE09F58E7A, 0, N'3c879a00-c3d9-4135-88a5-75a6fec234bd', N'k5cnttnguyenphuongbac@gmail.com', N'Nguyễn Phương Bắc', 83, CAST(0x0000A847000C0E87 AS DateTime), 0, 0, 1, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6DE AS DateTime), NULL)
INSERT [dbo].[SYS_Nguoidung] ([ID], [Username], [Password], [IsRequireResetPass], [CodeResetPassForget], [Email], [Fullname], [NumberOfLogin], [LaterLogin], [IsLock], [IsDelete], [IsSuper], [CreatedByUser], [CreatedByDate], [GhiChu]) VALUES (N'c6734c7e-b37a-44bf-b535-d83f70e6448e', N'nguyenhoainam', 0x0100B61971890D85348EE295D26083D8A5A589BF72CD53335D75, 0, N'673858e3-368f-4834-ac1c-5c6ef1179aa3', N'nguyenhoainam@gmail.com', N'Nguyễn Hoài Nam', 34, CAST(0x0000A05D00C232F2 AS DateTime), 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A050007798F4 AS DateTime), N'')
INSERT [dbo].[SYS_Nguoidung] ([ID], [Username], [Password], [IsRequireResetPass], [CodeResetPassForget], [Email], [Fullname], [NumberOfLogin], [LaterLogin], [IsLock], [IsDelete], [IsSuper], [CreatedByUser], [CreatedByDate], [GhiChu]) VALUES (N'25b2ec2f-76f3-4d9d-a63d-d9e12abebbe5', N'nguyenthithuhien', 0x01000658C0522B15623651710194470DD5E769840C6F2B43710D, 0, N'2dc53b70-d8c7-4778-98d4-cba041c573b6', N'canhhong_ruclua@yahoo.com', N'Nguyễn Thị Thu Hiền', 0, CAST(0x0000A0520154EEAF AS DateTime), 0, 0, 0, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0520154EEAF AS DateTime), NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A846018B3513 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A846018B410B AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000046E4 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700004D6F AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700006F79 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700007701 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000243BF AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700024A56 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700024A5D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700024CE8 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470003333C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000338E8 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470003A553 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470003AF44 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470003AF47 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470003C904 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700044710 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470004864D AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700048858 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700054573 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700054582 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700054827 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700054D47 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700058352 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000587B0 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700067813 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700067CD0 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470006F0BE AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470006F7DE AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470006F7ED AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700083FDC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470008805C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700088593 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000957AE AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A84700096773 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470009956E AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000999BD AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470009AB12 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A8470009B369 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000A005B AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000A0908 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000A29C9 AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000A2F0A AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000A31EC AS DateTime), 15, 5, N'7693d470-b579-474d-9e2d-717e207c70aa')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000A368B AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000A3B16 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000A5623 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000A5C25 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000AAB64 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000AB096 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000AD25B AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000AD660 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000AF19A AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000AF522 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000AF618 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000B37B5 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000B3BDE AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000B748F AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000B8CC7 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000BF845 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000BF84F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000C0E88 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000C185B AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'admin', CAST(0x0000A847000C185F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052013939EE AS DateTime), 38, 8, N'Từ Apr 15 2012 12:00AM đến May 16 2012 12:00AM')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052013939F7 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201396B0A AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201396CB4 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201397119 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052013982F8 AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201398DCB AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201399179 AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520139B0E9 AS DateTime), 22, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520139B56A AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520139B92B AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520139BE18 AS DateTime), 22, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520139C37A AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520139CA4F AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520139D99E AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052013C84EE AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052013C89AC AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052013CCE06 AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052013D29CC AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052013D872E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052013DA4EB AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201404D69 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201405D4E AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201406E42 AS DateTime), 22, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201407245 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201407512 AS DateTime), 22, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201407737 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201407BCA AS DateTime), 22, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201407DC5 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052014085A4 AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520140D03D AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520140D8B3 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520140DDDD AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520140DFC4 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052014196E9 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520141AAAF AS DateTime), 1, 1, NULL)
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520141C65E AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520141F57C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201421A4E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201424E74 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201429746 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520142A5BD AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520142D0A4 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520142D964 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052014332E1 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052014346AB AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201437B5A AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520143C7A7 AS DateTime), 22, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201440A5F AS DateTime), 22, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201447041 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201447C78 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520144844E AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052014495A0 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520144A0D5 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520144A50B AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520144A8F6 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201453E2D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201454920 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052014550FB AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052014554E1 AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201455828 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520145676E AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520145760F AS DateTime), 19, 6, N'Tháng 4/2009')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201457799 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201457B55 AS DateTime), 18, 5, N'Năm 2009')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201458266 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201459068 AS DateTime), 19, 6, N'Tháng 11/2009')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201459205 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520145AEB6 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201463BF1 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052014646BA AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201466066 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146881D AS DateTime), 19, 6, N'Tháng 4/2010')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201468FB1 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146951D AS DateTime), 18, 5, N'Năm 2010')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201469686 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052014699AC AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201469BDA AS DateTime), 18, 5, N'Năm 2010')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201469E6F AS DateTime), 18, 5, N'Năm 2009')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146A0C2 AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146A2F0 AS DateTime), 18, 5, N'Năm 2010')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146C68D AS DateTime), 19, 6, N'Tháng 10/2010')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146CD33 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146CFB0 AS DateTime), 18, 5, N'Năm 2010')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146D55D AS DateTime), 18, 5, N'Năm 2009')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146D786 AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146EB6E AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520146ED0F AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052014702DE AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520147731C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520150F10C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520150FB9D AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520150FF59 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201510C59 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201510F26 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201512777 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520151278A AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201537D90 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201538935 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201539550 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201539DA4 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520153A0DD AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520153A36E AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520153A4E5 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520153A665 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520153A7F4 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520153AC2E AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520153B900 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520153BC5E AS DateTime), 3, 5, N'nguyenhoainam')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520153C222 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520153CF69 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520154EEB8 AS DateTime), 3, 6, N'nguyenthithuhien')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520154F24F AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520154F712 AS DateTime), 3, 5, N'nguyenthithuhien')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520154FA70 AS DateTime), 3, 7, N'Mở khóa tài khoản nguyenthithuhien')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520154FAB7 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201550137 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201550145 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052015578E5 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201557BF8 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201557DED AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201559B14 AS DateTime), 3, 6, N'nguyenthithuhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201559CCD AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201559E4D AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201559F91 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520155A4F3 AS DateTime), 3, 5, N'nguyenthithuhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520155ABC2 AS DateTime), 3, 7, N'nguyenthithuhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520155ABC7 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520155AE28 AS DateTime), 3, 5, N'nguyenthithuhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520155B16A AS DateTime), 3, 7, N'Mở khóa tài khoản nguyenthithuhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520155B179 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520155B409 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520155B8A2 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520157237E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201573902 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052015740AE AS DateTime), 5, 5, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201577967 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201578A94 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052015B0238 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201601CD8 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201602552 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052016028DB AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201602C84 AS DateTime), 6, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201604AAD AS DateTime), 6, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201607421 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201607730 AS DateTime), 7, 5, N'NV00000005')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520160C8FF AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520160E639 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520160E833 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520161195D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520161A60F AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520161AB85 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520161B495 AS DateTime), 3, 5, N'nguyenthithuhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520161BC17 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520161C4EA AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520161C4F8 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052016529C0 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201652C47 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201652E70 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520165346D AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201653882 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05201653C10 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0520165ADD3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052016E653D AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052016E73F6 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052016E77EB AS DateTime), 3, 5, N'nguyenhoainam')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052016E7C00 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052016E7DFF AS DateTime), 41, 5, N'nguyenhoainam')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052016E85B4 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A052016E85C2 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530087B5BC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530087BE16 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530087E6EA AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300884430 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300884A61 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300884E55 AS DateTime), 3, 5, N'nguyenhoainam')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008853A5 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008865C1 AS DateTime), 41, 5, N'nguyenhoainam')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300886E6F AS DateTime), 41, 7, N'nguyenhoainam')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300886E81 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300887218 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300887221 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008CF03F AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008CF674 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008CF7DD AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008D37EA AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008D5654 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008D5A8A AS DateTime), 7, 5, N'NV00000005')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008D98F1 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008E010A AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008E0BCE AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008E0ECF AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008E0F73 AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008E509D AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008E5455 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008E5874 AS DateTime), 7, 5, N'NV00000004')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008F32BB AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053008F3322 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530091DC6A AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530092AAC2 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530095339C AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053009537C4 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300953AA9 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300953BFF AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300953DA5 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530098B6F3 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530098C430 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053009A0552 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053009A0824 AS DateTime), 18, 5, N'Năm 2010')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053009A0A3A AS DateTime), 18, 5, N'Năm 2009')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053009A0B99 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053009B51A3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300A0B84E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300A0C659 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300A1232F AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300A30161 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300A39185 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300A3D4B8 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300A6D0FC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300AC6543 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300ACBF13 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300B3D3C4 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300B96576 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300C46F8C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300C4D27F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300C4D284 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300C4D593 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300CA83E4 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300CD57B9 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300CEB1EB AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300CEC77D AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300CFB9EC AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300CFC973 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300D049B7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300D05C2C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300D683D5 AS DateTime), 1, 2, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300D683E3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300D68A2F AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300DBF3A7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300DC4D7C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300DCDF74 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300DCEFF4 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E3535C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E58A46 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E5900A AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E5AA8E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E5B789 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E5CB00 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E5EE81 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E68C94 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E6A4D2 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E7A44F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E7B5D0 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E9A072 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E9B2D9 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E9C4C1 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E9D29E AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E9D43F AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300E9DAD2 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300EF6921 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F05FCF AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F06B4A AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F077F1 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F07A31 AS DateTime), 3, 5, N'nguyenphuongbac')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F07EB7 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F082C3 AS DateTime), 3, 5, N'nguyenhoainam')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F08989 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F08BC1 AS DateTime), 41, 5, N'nguyenphuongbac')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F08F73 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F09220 AS DateTime), 41, 5, N'nguyenhoainam')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F099F6 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F09E60 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F09E64 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F8EF37 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300F8FA4B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05300FE8451 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301074E43 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010750F4 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301075237 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301082A76 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010833B1 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301083662 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301083803 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301083996 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301083BE1 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010840DB AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010843B6 AS DateTime), 24, 5, N'NV00000005 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530108CA39 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530108CDE2 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530108D0C2 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530108D2F0 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301090888 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301095279 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010953AE AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301095520 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301095651 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301095A17 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301095E0B AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301096351 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301097AEB AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530109B7F3 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530109B8F9 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530109BA62 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010A2EDB AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010A3028 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010A3B74 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010A4008 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010A42B5 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010B233F AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010B646A AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010B67BB AS DateTime), 7, 5, N'NV00000005')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010BB334 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010BB5BB AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010BC173 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010C0384 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D4B83 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D5436 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D5C31 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D63C6 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D67E5 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D710C AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D73E8 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D753E AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D768F AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D78AF AS DateTime), 24, 5, N'NV00000001 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010D7EDF AS DateTime), 26, 5, N'NV00000001 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DD3F6 AS DateTime), 26, 5, N'NV00000001 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DD894 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DDB82 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DE251 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DE7E7 AS DateTime), 24, 5, N'NV00000006 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DEA52 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DED7D AS DateTime), 26, 5, N'NV00000006 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DF511 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DF618 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DF75B AS DateTime), 35, 5, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DF89A AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DFC07 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010DFF5C AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010E035A AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010E048B AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010FB575 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053010FDC38 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301100B35 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301100B39 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530110EA8E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530111B9C7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530111B9CC AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301142DA5 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301143AE2 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530114571A AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301145CFB AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301146050 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011461C2 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011462E9 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301146460 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011466BD AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530114B525 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530114B52E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011631C4 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301163909 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301163A8E AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301172BEC AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530117357C AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530117368C AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301173925 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301175F40 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301182D2B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011831DB AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301183A14 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301183EA8 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011841FD AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530118490A AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301184CF0 AS DateTime), 3, 5, N'nguyenthithuhien')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301188CAD AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530118A968 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530118BD59 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530118DFF4 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530118E77F AS DateTime), 3, 5, N'nguyenthithuhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530118E9F8 AS DateTime), 3, 8, N'nguyenthithuhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530118E9FD AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530118EC2A AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011903A9 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301198678 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119907C AS DateTime), 41, 5, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301199BA3 AS DateTime), 41, 7, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05301199BBA AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119ADBF AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119BA87 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119BBC1 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119D4A3 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119E47E AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119E5D0 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119E726 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119E987 AS DateTime), 41, 5, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119ED73 AS DateTime), 41, 7, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119ED78 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119F6EA AS DateTime), 41, 5, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0530119FC19 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011A0707 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011A1D3D AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011A35BD AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011A5E0A AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011A794E AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011A97E6 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011AA565 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011AAB12 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011AB65F AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011AB95F AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011ABD38 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A053011AD111 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540085DAA6 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540085E10A AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540085EFB0 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540085F30E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540085F318 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009BC513 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009BC790 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009BCC6A AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009BF3EE AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009BF638 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009BF764 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009BF97F AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009BFB4F AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009BFD94 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009C0710 AS DateTime), 24, 5, N'NV00000001 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009C0A45 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009C12B1 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009C1680 AS DateTime), 18, 5, N'Năm 2010')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009C1910 AS DateTime), 18, 5, N'Năm 2009')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009C1ABF AS DateTime), 18, 5, N'Năm 2008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009C1CA2 AS DateTime), 18, 5, N'Năm 2010')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009C232C AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054009FC22E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400AD3241 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400AD356C AS DateTime), 38, 5, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400AD5ED2 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400AD5ED7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400B3CFA2 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400BA3DDC AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400BAAD64 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400C07D82 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400C09774 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400C0D52D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400C10454 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400C235E0 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400C25775 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400C3B6E9 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400C3BC9F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DB53E1 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DB65EA AS DateTime), 56, 6, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DC1B93 AS DateTime), 56, 6, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DC7DFA AS DateTime), 56, 6, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DC90DF AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DC9C5F AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DE0799 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DE1494 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DE1A41 AS DateTime), 7, 5, N'NV00000007')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DE1EA7 AS DateTime), 6, 5, N'NV00000007')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DE24B6 AS DateTime), 6, 7, N'NV00000007')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DE25D4 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DE29C8 AS DateTime), 7, 5, N'NV00000007')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400DE3B9E AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400E15DEA AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400E2064C AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400E214E4 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400E7A1BC AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400E7CEBE AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400E7D584 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400EC51A4 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400ED402C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400ED659E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400EE0756 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400EE10E0 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400F1F9FD AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400F2CC44 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400F39F30 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400FE7595 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05400FEA982 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401034A9B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540103C9B7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105D3D7 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105D6A0 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105D89F AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105D8F3 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105DB21 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105DC15 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105DCFF AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105DFB5 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105E0CE AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105E33E AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105E76F AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105E8BC AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105E998 AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105EB14 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105ED13 AS DateTime), 7, 5, N'NV00000002')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105F254 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105F32C AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105F592 AS DateTime), 7, 5, N'NV00000006')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105FB02 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540105FD22 AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010614E6 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401061670 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401061C5F AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401062448 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401062887 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401062E89 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010633CF AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401067E1D AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401068F3C AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010781D4 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540107AACF AS DateTime), 19, 6, N'Tháng 5/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540107AC0D AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540107BBB5 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540107D81C AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540107E80A AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401080A47 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010811FD AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401081641 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401081DB5 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401083294 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401085D14 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401087BC9 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401088F3B AS DateTime), 20, 7, N'5/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010894D1 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540108B425 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540108BA9C AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540108BEB1 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540108C6B2 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401090085 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401090D5B AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401091B3C AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401092493 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540109395B AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540109616B AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010964AD AS DateTime), 42, 5, N'Tháng 4/2012')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401096722 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010967F9 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401097777 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05401097FBE AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540109C510 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010A29F0 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010A6FA5 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010A72CB AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010AE10B AS DateTime), 32, 6, N'932b3abe-30b0-4c59-8a95-1e4c56aeca0e')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010AE290 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010AFC0D AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010B0775 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010B0C04 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010B18E8 AS DateTime), 41, 5, N'nguyenphuongbac')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010B1E54 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010B22A6 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010B40CA AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010B7B58 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010B8464 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010B8968 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C1608 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C31A5 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C3F1A AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C44FB AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C4F91 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C56F6 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C5958 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C5A7F AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C5B52 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C6802 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C6AFA AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010C6CA4 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010CB64E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010CC7BD AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010CDA5C AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010CE635 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010CE883 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010CFA8C AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010CFFE5 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010D3017 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010D320D AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010D4DA9 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010DBE4A AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010DCCAE AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010DCD78 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010DCE75 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010DD1B7 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010DD269 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010E1506 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010E1AD9 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010E98A0 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010EA665 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010EA66E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010EA673 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010ECAE7 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010ED28A AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010ED7D0 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010EE26F AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010EE558 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010EE643 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010F3663 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010F5C33 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010F6C96 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010F731B AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010F779C AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010F7A93 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010F8667 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010F8906 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054010FE910 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540110ADBC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540110B200 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A054011136F4 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0540116C789 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500B76CE2 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500B772F6 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500B775FC AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500B81600 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500B818F7 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500B9276A AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500B9600C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500B9678E AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BEAB1A AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BEBFD8 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BECA0C AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BECEB7 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BEF8E7 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BEFDE6 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BEFF95 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BF0137 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BF02EB AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BF0AD4 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BF1345 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500BF1816 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500C04C4E AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500C054BF AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500C0567C AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500C059C4 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500C073B1 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500C60759 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EB2E52 AS DateTime), 1, 1, NULL)
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EB3C4F AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EB590A AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EB6B1D AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EC7DC0 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500ECAA6A AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500ECAF31 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500ED37E6 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500ED4F35 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500ED54AA AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EDCCBE AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EDEB44 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EDEDDE AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EEAFA1 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EF15B1 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05500EF82C0 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A057008F8CEB AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700953C26 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B3F661 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B5F563 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B606E0 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B614B3 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B6255D AS DateTime), 41, 5, N'nguyenphuongbac')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B62883 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B6493C AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B667CB AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B69CE9 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B74466 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700B97DC4 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700BB0E79 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700BC3692 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700BCCDF7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700BD4AC5 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700BD4EAB AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700BD5D64 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05700BD5DAF AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800897201 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A058008F0258 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0580090E3D2 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800917A42 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800923BF7 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800924E67 AS DateTime), 7, 5, N'NV00000006')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0580097E390 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800986FF7 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A058009873E7 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A058009CD487 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A058009E0118 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A058009E055C AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800A0DE60 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800A37326 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800A90609 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800E7F121 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800E7F45A AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800ED7E1E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800F3167F AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800F31951 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800F431B0 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800F46F32 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05800F9F174 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A058011899A5 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0580118B9B1 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0580118D756 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0580118D75F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900985804 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A059009888B4 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900988BA7 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A059009E1CB5 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900AF6AE3 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900AF6DBF AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900AF9E4E AS DateTime), 7, 5, N'NV00000005')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900AFA438 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900AFE4A3 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900B08EDA AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900B110F2 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900B112D0 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900B138CF AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900B163A8 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900B1BA0B AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900B1BFAA AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900B26316 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900B28198 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900B80585 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900DEBC94 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900E43E12 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900E5A73A AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900E5A8BA AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900EB333F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900ECBEA5 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900ECC091 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05900F23FEF AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A0086C064 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A0086C72A AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A0086CCB2 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008ABCBD AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008ABEDC AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008B4352 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008B835A AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008B861E AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008BA94A AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008BF1E9 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008C7D79 AS DateTime), 37, 5, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008E28AD AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008E42F8 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008E48AA AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008E4A39 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008E4C67 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008E4E74 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008EB967 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008EBE2E AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F329E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F60AC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F64B7 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F7029 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F73B2 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F751B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F761C AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F7707 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F77DE AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F78BF AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F797B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F7A36 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F7B7F AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F7D5D AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F80C9 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F8935 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F8AE5 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F8DFD AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008F9EC3 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A008FF742 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00906DFB AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00957DF7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A0096F876 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A009DE1F5 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A009DE684 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00A5870B AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00A993AD AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AC12A4 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AC154C AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AC1660 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AC235C AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AD768B AS DateTime), 16, 6, N'Vũ Quốc Đạt ngày 23/05/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AD79E5 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AD8057 AS DateTime), 16, 5, N'21c9ba57-cc21-47a1-bd25-34859843bdab')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AE5F9E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AE9159 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AE963D AS DateTime), 16, 5, N'21c9ba57-cc21-47a1-bd25-34859843bdab')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AEA37F AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AEA76A AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AEAABF AS DateTime), 16, 5, N'21c9ba57-cc21-47a1-bd25-34859843bdab')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AEADCE AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AEB339 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AED109 AS DateTime), 16, 5, N'21c9ba57-cc21-47a1-bd25-34859843bdab')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AED811 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AEF127 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AF1D0F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00AF207C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1C8AF AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1D297 AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1D3B0 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1D61B AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1D807 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1DA56 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1E12A AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1E463 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1E9CF AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1ECEB AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B1F477 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B20B84 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B2DCFD AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B2DE74 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B30407 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B3B509 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B79044 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B93616 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B97F63 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B98438 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B9A5EE AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B9A901 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00B9E78E AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00BA7937 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00BC7FBB AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00BE9D28 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00BE9E83 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00BEFFF1 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00BF1216 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C142DE AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C14808 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C14946 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C193F7 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C1BC2D AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C1CD75 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C1CDD8 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C2621F AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C26359 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C2F9C5 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A05A00C2F9CE AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0600105230A AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A06001052AF1 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A06001053293 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0600105422A AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A06001054905 AS DateTime), 5, 5, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A06001054C80 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A06001054E75 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A060010595E8 AS DateTime), 3, 6, N'phuongbac3674')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A060010597D5 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0600105AAC6 AS DateTime), 3, 5, N'phuongbac3674')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0600105ADBB AS DateTime), 3, 7, N'Mở khóa tài khoản phuongbac3674')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0600105ADEA AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0600105B4DB AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'adminnguyenphuongbac', CAST(0x0000A0600105B4DF AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016E8B5C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016E93D7 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016E9735 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016E9D37 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016EF3AD AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016EF66C AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016EF8D7 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016EFBCF AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016EFE4C AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016EFFE8 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016F037A AS DateTime), 24, 5, N'NV00000001 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016F136D AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016F1FA9 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016F2C91 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A052016F2C96 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05300887FC6 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530088B58D AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530088B97D AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530088BD0F AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A053008CD0E1 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A053008CECC5 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A053008F430C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05300F0A429 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05300F22D16 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05300F7BDE7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301100EAA AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301101157 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A053011012E0 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301101C12 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301101D0F AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301101E9D AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A053011022BC AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530110CC41 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530111BDA4 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530112D974 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530112F8E0 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530113221C AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530113249E AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301132597 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A053011326AB AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301132864 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A053011329BF AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301132F5E AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A053011343E9 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301135A08 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301135A0D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A053011425B8 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301142A92 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301142AA0 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530114B9D5 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530114E83B AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530114EDDA AS DateTime), 3, 5, N'vaylaminhchiatay')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0530114F1D3 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301162DC6 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05301162DCB AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400859524 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540085D6FD AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540085D70F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540085F99C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054008711E4 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400871221 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540088382D AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400888A23 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540088A601 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400917A3E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400936A4A AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400936D0A AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009384F8 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400938A19 AS DateTime), 41, 5, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009391AE AS DateTime), 41, 7, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009391B7 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009395B0 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400960DBB AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009610CA AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400961AF3 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540096200F AS DateTime), 41, 5, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400962501 AS DateTime), 41, 7, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540096250A AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009631B1 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400968E5D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400969CC6 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540096B2F7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540097BD41 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540097D9CD AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A0540097E125 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009A8FBC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009A92B3 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009A98C8 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009A9FB3 AS DateTime), 41, 5, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009AA451 AS DateTime), 41, 7, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009AA45A AS DateTime), 2, 5, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009AAD78 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009AB1D9 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009AB363 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009ABF9E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009ABFA7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009AC368 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009AC5B7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009BAB2A AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009BAE26 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009BAF52 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009BB305 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009BB419 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009BB512 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009BBE30 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009BC1F1 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009BC1F6 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009FDFF8 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009FE970 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009FEE20 AS DateTime), 41, 5, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009FF6B1 AS DateTime), 41, 7, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009FF6BB AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A054009FF92A AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400AC8AE5 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400AC90FA AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400AC9372 AS DateTime), 41, 5, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400AC973D AS DateTime), 41, 7, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400AC9741 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400AC9A84 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400AC9A88 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400ACE6C3 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400ACEC5D AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400ACEF9B AS DateTime), 41, 5, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400ACF608 AS DateTime), 41, 7, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400ACF611 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400ACF7E1 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400ACF9FC AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400C3C10E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400C3C51E AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400C3E529 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05400C4D7AF AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B012F72AD AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B012F768A AS DateTime), 16, 5, N'21c9ba57-cc21-47a1-bd25-34859843bdab')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B0130283A AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B01303027 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B0130302C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B01307408 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B013077A3 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B01307CCD AS DateTime), 41, 5, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B01308195 AS DateTime), 41, 7, N'nguyenthikimhang')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B0130819E AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B01308425 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B01308429 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05B0130C204 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05D00C1524B AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05D00C155A9 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05D00C20F34 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05D00C232F2 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05D00C236FE AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenhoainam', CAST(0x0000A05D00C38927 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00B459C2 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00B45B63 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00B9DA26 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00C214ED AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00C216CB AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00C254D9 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00C26D7A AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00C29C0A AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00C29CCF AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00C2C428 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05A00C2C4D1 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B015B3F65 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B015B50DD AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B015CBCF8 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B015CCD10 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B015CD9FE AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B015CDD1F AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B015CF790 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01610B48 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01611D43 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01612117 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01615F9F AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0161A3DD AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01620D42 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01623074 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01623C3F AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01627218 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01628EA0 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01629C31 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0162BD84 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016415C1 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01641C70 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01642771 AS DateTime), 14, 5, N'2')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01642A19 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01642C76 AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01642EA4 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01643053 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016434F9 AS DateTime), 7, 5, N'NV00000004')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016440FD AS DateTime), 12, 6, N'NV00000004|1|500000')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016442B5 AS DateTime), 7, 5, N'NV00000004')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01659731 AS DateTime), 1, 2, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0165E88C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0165F1E7 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01660897 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0166765C AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0166F42C AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0166FD54 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016707A8 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0167679A AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0167767D AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01677BCD AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01678609 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B01678B12 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0167B8BD AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B0169BA75 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016A4244 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016B3379 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016B370B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016BCCE5 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016BE899 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016C1152 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016C6AA9 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016C798C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016C91EB AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016C9379 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016CE5CC AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016DDA14 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05B016E2BC3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C00FF4D5F AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C00FF520A AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C00FF5FF4 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C00FF7012 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C00FF7147 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C00FF78BB AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C00FF79C6 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C00FF7AD1 AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C00FF7E14 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C00FF7FAB AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01005802 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0102C2D0 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0102C605 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01044BA6 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01049144 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01049698 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01091719 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01091F3A AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C010924D9 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0109277C AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C010A711C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C010B1D6E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C010B2045 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0113BE86 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0113D285 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0113D84F AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0114498F AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01144BCF AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C014CB50B AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C014CC294 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C014DFF00 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C014E0386 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01534B85 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0159AA6C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C016770E3 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C016776E0 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01727F9B AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C017A75D8 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C017A7BE8 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0182AF85 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0182C98F AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0182CF70 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01843EE0 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0184420F AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C01850B38 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0185D588 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0185D889 AS DateTime), 7, 5, N'NV00000005')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C0187B816 AS DateTime), 7, 5, N'NV00000005')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C018AE178 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C018AED43 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05C018AF0DE AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D0007B93A AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D0007C397 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D0007C6C2 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D000AE55F AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D000BC096 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A604F9 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A609DD AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A68EA7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A69F8D AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A6A19F AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A74BC3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A7861E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A78949 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A855D1 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A859D8 AS DateTime), 7, 5, N'NV00000005')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A89681 AS DateTime), 7, 5, N'NV00000005')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A9AA51 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A9DECC AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A9F66B AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00A9FD9D AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AA44FD AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AAF844 AS DateTime), 6, 6, N'NV00000008')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AAF86E AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AAFD3F AS DateTime), 7, 5, N'NV00000008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AB41EE AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AB77B0 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AB7C52 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AB9027 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00ABBF94 AS DateTime), 7, 5, N'NV00000008')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00ADE445 AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AE389C AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AE40DE AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AEC045 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AEC456 AS DateTime), 7, 5, N'NV00000002')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AED93F AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AEF8C7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AEF8CC AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AF0284 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AF379A AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AF395C AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AFD63E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00AFF18B AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00B03C66 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00B7D041 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00B827CC AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00B83504 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00B8430B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00B8498B AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00B84CBF AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00B87DAC AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00B87DB1 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BADA40 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BAE533 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BBBB6F AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BBBD73 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BC254E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BC2B75 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BCCA69 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BCD342 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BCE960 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BCF0A0 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BD1FFA AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00BD2A36 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00C0F7A3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00C0FD1D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00CAE804 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00D07831 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00D66908 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00D76204 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00D79011 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00D79464 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00D7946D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00D94ADB AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DB38A7 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DC5E9C AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DD1E78 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DD65B2 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DD8CA9 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DD97BD AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DDBF90 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DE0AAD AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DE1465 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DE497B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00DFC827 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00E031DC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00E035FA AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00E118B3 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00E11C0D AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00E2F0C8 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00E31AD7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00E35578 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00E36847 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00EC4EF3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00F681DE AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00F69027 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00F9F250 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00FA1AAC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00FA260F AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00FC5AC6 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00FC6B6B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00FC9157 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00FCB8B1 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00FD1A8A AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00FD279D AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00FD31BE AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D00FFD923 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D0100082D AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D010011B7 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D01001683 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D01005BDB AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D01007599 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D0100C536 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D0100CC64 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D01012079 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D010127FB AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D0101E643 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05D010726F4 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0098FB83 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009908EE AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0099121B AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E00996110 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E00996135 AS DateTime), 1, 2, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E00997681 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E00997CBB AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0099A9AA AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0099A9AE AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0099D259 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0099D4BF AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0099E9B2 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009A1DA9 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009A2A1D AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009A4235 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009A4BF8 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009A4DBE AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009A55E4 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009A69CB AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009A69D5 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009A7B80 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009A7D71 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009ACAB6 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E009ACAC0 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E00AD7E72 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E00AD8177 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E00AD8482 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E00AD8800 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E00ADA230 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E00B32B55 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E018130FA AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E018136A2 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0182C619 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0182D1C2 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0182DF46 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0182DF54 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05E0182E983 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F23E82 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F24A7B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F2505C AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F259EB AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F25B6B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F25F8F AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F2766D AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F27EEC AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F28204 AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F2AEB2 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F2DA0E AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F2DE77 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F2E0DD AS DateTime), 24, 5, N'NV00000001 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F2F141 AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F2FA69 AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F30094 AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F31171 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F31566 AS DateTime), 26, 5, N'NV00000001 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F31B88 AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F4B2D5 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F5B5A2 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F5BECF AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F7C4D0 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F82F66 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F83445 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F853D1 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F89D56 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F90F02 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F9D1EC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F9D460 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00F9D863 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FA177C AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FA5ACB AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FA8FEA AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FA9271 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FEC6B7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FEE209 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FEE591 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FF14C6 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FF3351 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FF366D AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A05F00FF70E9 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A060009DD15F AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A060009DD85A AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A060009E33E8 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A060009E33F2 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A060009EE0AD AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A060009EF222 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A060009EF556 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A060009EFAA7 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A060009F2FCF AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B16DE1 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B1753B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B17845 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B2094B AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B222FB AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B249AC AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B249B5 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B25C87 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B25C8C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B26FE1 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B273F8 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B27A74 AS DateTime), 2, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B27B96 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B39362 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000B39367 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000BB1D9F AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000BB2BD6 AS DateTime), 1, 2, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000CF0B94 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000CF107B AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000D43481 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000D43BA5 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000D43DA4 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000D43F6A AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000D440B1 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000D4426A AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000D44873 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000D46377 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000D467A5 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000D46A71 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DA50AC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DA56BE AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DA5860 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DA59F3 AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DA5B15 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DA5C83 AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DA5DE6 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DAAB97 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DAB421 AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DAB656 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DAB792 AS DateTime), 17, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DAC087 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DAC6AB AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DAC8AD AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DACCDF AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DAD2BF AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DAD7E3 AS DateTime), 38, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000DAF4A3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E0219B AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E02944 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E02C81 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E02C86 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E1DDE6 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E1E128 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E4B47E AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E4BB75 AS DateTime), 14, 5, N'1')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E4BEC9 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E4C0A8 AS DateTime), 14, 5, N'2')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E4CCA8 AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E4DE33 AS DateTime), 15, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A06000E56706 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A84700068B4F AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A84700069A11 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A8470006C503 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A8470006C50D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A84700088986 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A8470008C554 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenphuongbac', CAST(0x0000A8470008D8E2 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0530119C76B AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0530119D7A4 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0530119F890 AS DateTime), 7, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A053011A187F AS DateTime), 6, 5, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A053011A687A AS DateTime), 6, 7, N'NV00000003')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A053011A68CA AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A053011B412E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A053011B4133 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540093A07D AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540093C6E3 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540093DF92 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540095F5F7 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540096BC81 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540097A671 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540097EEA3 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400981DFD AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400983390 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540098436B AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400984C47 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400984EE1 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009867FC AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009872E1 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400987592 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540098776B AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400987965 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540098A176 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540098A366 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540098A4D4 AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540098A702 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009A7C0D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009AD9E0 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009B73FA AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009B9B24 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009B9ECE AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009BA032 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009BA1DD AS DateTime), 35, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009BA354 AS DateTime), 33, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009BA435 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009BA6EF AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054009BA6F4 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A00118 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A02892 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A03DF6 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A04904 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A049EF AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A05683 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A05B59 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A0628B AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A06485 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A0676F AS DateTime), 18, 5, N'Năm 2012')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A16F4E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A189D1 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A18CDC AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A5EC20 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A60053 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A60ABE AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A60B7E AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A66854 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A66AA2 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A66C73 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A66E14 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A6703D AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A672C4 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A675D7 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A67A0D AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A6800F AS DateTime), 24, 5, N'NV00000001 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A68F3D AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A6A27B AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A6A46C AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A6A5BE AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A6B150 AS DateTime), 24, 5, N'NV00000003 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400A7791E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC492E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC57C6 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC5B5D AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC5DF2 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC60AC AS DateTime), 24, 5, N'NV00000001 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC694C AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC6CF5 AS DateTime), 26, 5, N'NV00000005 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC8115 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC86DE AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC86E3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC9E40 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AC9FDD AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACA742 AS DateTime), 3, 7, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACA9AD AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACB772 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACB882 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACBBE0 AS DateTime), 24, 5, N'NV00000005 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACC0C9 AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACC435 AS DateTime), 26, 5, N'NV00000006 tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACC8E5 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACCA37 AS DateTime), 43, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACCDE0 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACDC0D AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACE24F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACE254 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400ACFE0D AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AD01DC AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AD2B1D AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AD2EDE AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AD2EE3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AD6273 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AD70AD AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400AE23B2 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400EFAAF1 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400EFBC31 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400EFC520 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400EFC826 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400EFDC58 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400EFE4B2 AS DateTime), 14, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400EFE66F AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400EFEBAB AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400EFF9B2 AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400EFFC3E AS DateTime), 42, 5, N'Tháng 4/2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05400F5A34E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540103E290 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540103EF20 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A0540106066F AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05401060898 AS DateTime), 7, 5, N'NV00000001')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05401060B40 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05401060D2C AS DateTime), 7, 5, N'NV00000005')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05401061011 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054010B6D0B AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054010B74DD AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A054010B74F0 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B012F3D0B AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B012F5854 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B012F5858 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B012F5CF1 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B012F60F4 AS DateTime), 5, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B012F6258 AS DateTime), 16, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B012F67ED AS DateTime), 16, 5, N'21c9ba57-cc21-47a1-bd25-34859843bdab')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B012F6E8A AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B012F6E8E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B0130345E AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B01303759 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B013048BA AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B013048BF AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B0130891B AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05B0130C217 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05C01642FB4 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05C016435CC AS DateTime), 22, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05C01656571 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05C0172E9E1 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05C0172ED23 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05C01799874 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05D00C11941 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05D00C11C01 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05D00C3A665 AS DateTime), 1, 2, N'')
GO
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05E01819734 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05E0181A081 AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A05E01822A88 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A06000B2F3D7 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A06000B30805 AS DateTime), 37, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthikimhang', CAST(0x0000A06000B389E9 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A0520161CE62 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A05201627F2C AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A0520162A87F AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A0520163340F AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A05201634FFC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A05201635753 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A05201639D20 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A0520163B7DC AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A0520163FF4E AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A05201644606 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A05201647750 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A05201648D82 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A0520165C616 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'nguyenthithuhang', CAST(0x0000A0520168BFD3 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'phuongbac3674', CAST(0x0000A06001066B19 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'phuongbac3674', CAST(0x0000A060010670AA AS DateTime), 18, 5, N'Năm 2012')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'phuongbac3674', CAST(0x0000A06001067601 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A84601885668 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A846018977EB AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A8460189860A AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A8460189BD52 AS DateTime), 31, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A8460189D0B8 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A846018A5D99 AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A846018A8E00 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A846018A9C6B AS DateTime), 3, 5, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A846018AA781 AS DateTime), 1, 3, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A846018AB02A AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A846018AB02D AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A846018AE735 AS DateTime), 1, 1, NULL)
INSERT [dbo].[SYS_Nhatkyhethong] ([Username], [Thoigian], [Chucnang], [Hanhdong], [Doituong]) VALUES (N'vuanhduc', CAST(0x0000A846018B0A37 AS DateTime), 1, 2, N'')
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'40738b3f-f44b-4fe9-9d5b-38e1be950378', 6, N'c6734c7e-b37a-44bf-b535-d83f70e6448e', CAST(0x0000A05B01308182 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'40738b3f-f44b-4fe9-9d5b-38e1be950378', 7, N'c6734c7e-b37a-44bf-b535-d83f70e6448e', CAST(0x0000A05B01308191 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'40738b3f-f44b-4fe9-9d5b-38e1be950378', 8, N'c6734c7e-b37a-44bf-b535-d83f70e6448e', CAST(0x0000A05B01308191 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'40738b3f-f44b-4fe9-9d5b-38e1be950378', 11, N'c6734c7e-b37a-44bf-b535-d83f70e6448e', CAST(0x0000A05B01308191 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'40738b3f-f44b-4fe9-9d5b-38e1be950378', 12, N'c6734c7e-b37a-44bf-b535-d83f70e6448e', CAST(0x0000A05B01308195 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'40738b3f-f44b-4fe9-9d5b-38e1be950378', 13, N'c6734c7e-b37a-44bf-b535-d83f70e6448e', CAST(0x0000A05B01308195 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 1, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 2, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 3, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 4, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 6, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 7, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 9, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 10, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 11, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 12, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'97eb5995-633a-4d77-abeb-8d92412f2b2d', 13, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A060010595E8 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 1, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FDD AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 2, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FDD AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 3, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FDD AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 4, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FDD AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FDD AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 6, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FDD AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 7, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FE1 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FE1 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 9, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FE1 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 10, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FE1 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 11, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A04F00F89FE1 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 12, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05100A2A968 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', 13, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05101048F20 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'c19797a9-04d3-4225-a34d-d0c1aa5f4d2a', 2, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05201128313 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 1, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 2, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 3, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 4, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 6, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 7, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 9, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 10, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 11, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A0500076E6FF AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 12, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05100A2A968 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'0bd95cf1-fd60-4547-9367-d52b349fa6c0', 13, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05101048F20 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'c6734c7e-b37a-44bf-b535-d83f70e6448e', 2, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05300886E66 AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'c6734c7e-b37a-44bf-b535-d83f70e6448e', 3, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05300886E6B AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'c6734c7e-b37a-44bf-b535-d83f70e6448e', 4, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05300886E6B AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'c6734c7e-b37a-44bf-b535-d83f70e6448e', 5, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05300886E6B AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'c6734c7e-b37a-44bf-b535-d83f70e6448e', 8, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05300886E6F AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'c6734c7e-b37a-44bf-b535-d83f70e6448e', 9, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05300886E6F AS DateTime))
INSERT [dbo].[SYS_PhanQuyen] ([UserID], [RollID], [CreatedByUser], [CreatedByDate]) VALUES (N'c6734c7e-b37a-44bf-b535-d83f70e6448e', 10, N'56c862e4-2681-4b7d-a0d2-a6fb4f4257f8', CAST(0x0000A05300886E6F AS DateTime))
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (1, N'Nhật ký hệ thống', N'Quản lý nhật ký hệ thống (Chỉ có Super Account mới có quyền này)')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (2, N'Quản trị hệ thống', N'')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (3, N'Cài đặt', N'Cài đặt công thức tính lương, Lương tối thiểu, QĐ số ngày chấm công')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (4, N'Quản lý nhân sự', N'Các vấn đề liên quan đến nhân sự')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (5, N'Chấm công', N'Chấm công cho nhân viên')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (6, N'Hoàn thành chấm công', N'Hoàn thành chấm công')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (7, N'Tính lương', N'Tính lương nhân viên')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (8, N'Hoàn thành tính lương', N'Hoàn thành tính lương')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (9, N'Cơ cấu - tổ chức', N'Thay đổi cơ cấu tổ chức trong công ty (Phòng ban, tổ, chức vụ)')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (10, N'Bảng tham số', N'Thay đổi các bảng tham số')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (11, N'Giải trí', N'Xử dụng dịch vụ thư giãn - giải trí của website')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (12, N'Reset mật khẩu', N'Chỉ thực hiện khi có yêu cầu trực tiếp từ chủ tài khoản')
INSERT [dbo].[SYS_Quyen] ([ID], [Rollname], [Description]) VALUES (13, N'Trang chủ', N'Cập nhật thông tin đưa lên trang chủ')
ALTER TABLE [dbo].[DIC_Bangcap] ADD  CONSTRAINT [DF_DIC_Bangcap_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DIC_Cauhinhcongthuc] ADD  CONSTRAINT [DF_PB_Baohiem_IsActive]  DEFAULT ((0)) FOR [IsCurrent]
GO
ALTER TABLE [dbo].[DIC_Chucvu] ADD  CONSTRAINT [DF_Chucvu_Captren]  DEFAULT ((0)) FOR [Captren]
GO
ALTER TABLE [dbo].[DIC_Chucvu] ADD  CONSTRAINT [DF_DIC_Chucvu_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DIC_Chuyenmon] ADD  CONSTRAINT [DF_DIC_Chuyenmon_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DIC_Congviec] ADD  CONSTRAINT [DF_DIC_Congviec_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DIC_Dantoc] ADD  CONSTRAINT [DF_DIC_Dantoc_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DIC_Ngonngu] ADD  CONSTRAINT [DF_DIC_Ngonngu_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DIC_Quanhegiadinh] ADD  CONSTRAINT [DF_DIC_Quanhegiadinh_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DIC_Quoctich] ADD  CONSTRAINT [DF_DIC_Quoctich_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DIC_Tinhoc] ADD  CONSTRAINT [DF_DIC_Tinhoc_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DIC_Tongiao] ADD  CONSTRAINT [DF_DIC_Tongiao_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PB_ChamcongNhanvien] ADD  CONSTRAINT [DF_Chamcong_SNCong]  DEFAULT ((0)) FOR [Sogiocong]
GO
ALTER TABLE [dbo].[PB_ChamcongNhanvien] ADD  CONSTRAINT [DF_Chamcong_SNPhep]  DEFAULT ((0)) FOR [Sogionghiphep]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_Namkinhnghiem]  DEFAULT ((0)) FOR [Namkinhnghiem]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_Duocnghipheptrongnam]  DEFAULT ((0)) FOR [Duocnghipheptrongnam]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T1]  DEFAULT ((0)) FOR [T1]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T2]  DEFAULT ((0)) FOR [T2]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T3]  DEFAULT ((0)) FOR [T3]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T4]  DEFAULT ((0)) FOR [T4]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T5]  DEFAULT ((0)) FOR [T5]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T6]  DEFAULT ((0)) FOR [T6]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T7]  DEFAULT ((0)) FOR [T7]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T8]  DEFAULT ((0)) FOR [T8]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T9]  DEFAULT ((0)) FOR [T9]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T10]  DEFAULT ((0)) FOR [T10]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T11]  DEFAULT ((0)) FOR [T11]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] ADD  CONSTRAINT [DF_PB_Chamnghiphep_T12]  DEFAULT ((0)) FOR [T12]
GO
ALTER TABLE [dbo].[PB_Chamtangca] ADD  CONSTRAINT [DF_Chamtangca_TCthuong]  DEFAULT ((0)) FOR [TCthuong]
GO
ALTER TABLE [dbo].[PB_Chamtangca] ADD  CONSTRAINT [DF_Chamtangca_TCchunhat]  DEFAULT ((0)) FOR [TCchunhat]
GO
ALTER TABLE [dbo].[PB_Chamtangca] ADD  CONSTRAINT [DF_Chamtangca_TCnghile]  DEFAULT ((0)) FOR [TCnghile]
GO
ALTER TABLE [dbo].[PB_Danhgianhanvien] ADD  CONSTRAINT [DF_PB_Danhgianhanvien_Diem]  DEFAULT ((0)) FOR [Diem]
GO
ALTER TABLE [dbo].[PB_Danhsachbangluong] ADD  CONSTRAINT [DF_PB_Danhsachbangluong_IsLock]  DEFAULT ((0)) FOR [IsLock]
GO
ALTER TABLE [dbo].[PB_Danhsachbangluong] ADD  CONSTRAINT [DF_PB_Danhsachbangluong_IsFinish]  DEFAULT ((0)) FOR [IsFinish]
GO
ALTER TABLE [dbo].[PB_Danhsachchamcong] ADD  CONSTRAINT [DF_PB_Danhsachchamcong_IsLock]  DEFAULT ((0)) FOR [IsLock]
GO
ALTER TABLE [dbo].[PB_Danhsachchamcong] ADD  CONSTRAINT [DF_PB_Danhsachchamcong_IsFinish]  DEFAULT ((0)) FOR [IsFinish]
GO
ALTER TABLE [dbo].[PB_Dicongtac] ADD  CONSTRAINT [DF_PB_Dicongtac_Tiendicongtac]  DEFAULT ((0)) FOR [Tiendicongtac]
GO
ALTER TABLE [dbo].[PB_KhenthuongNhanvien] ADD  CONSTRAINT [DF_PB_KhenthuongNhanvien_Sotien]  DEFAULT ((0)) FOR [Sotien]
GO
ALTER TABLE [dbo].[PB_Luongtangca] ADD  CONSTRAINT [DF_PB_Luongtangca_LuongGio]  DEFAULT ((0)) FOR [LuongGio]
GO
ALTER TABLE [dbo].[PB_Luongtangca] ADD  CONSTRAINT [DF_PB_Luongtangca_Sotangcathuong]  DEFAULT ((0)) FOR [Sotangcathuong]
GO
ALTER TABLE [dbo].[PB_Luongtangca] ADD  CONSTRAINT [DF_PB_Luongtangca_Sotangcachunhat]  DEFAULT ((0)) FOR [Sotangcachunhat]
GO
ALTER TABLE [dbo].[PB_Luongtangca] ADD  CONSTRAINT [DF_PB_Luongtangca_Sotangcale]  DEFAULT ((0)) FOR [Sotangcale]
GO
ALTER TABLE [dbo].[PB_Luongtoithieu] ADD  CONSTRAINT [DF_Luongtoithieu_IsActive]  DEFAULT ((0)) FOR [IsCurrent]
GO
ALTER TABLE [dbo].[PB_Nguoithannhanvien] ADD  CONSTRAINT [DF_Nguoithannhanvien_Phuthuoc]  DEFAULT ((0)) FOR [Phuthuoc]
GO
ALTER TABLE [dbo].[PB_Nhanvien] ADD  CONSTRAINT [DF_Nhanvien_Nu]  DEFAULT ((0)) FOR [Nu]
GO
ALTER TABLE [dbo].[PB_Nhanvien] ADD  CONSTRAINT [DF_Nhanvien_Honnhan]  DEFAULT ((0)) FOR [Honnhan]
GO
ALTER TABLE [dbo].[PB_Nhanvien] ADD  CONSTRAINT [DF_Nhanvien_Nghiviec]  DEFAULT ((0)) FOR [Tinhtrang]
GO
ALTER TABLE [dbo].[PB_Nhanvien] ADD  CONSTRAINT [DF_PB_Nhanvien_BHXH]  DEFAULT ((1)) FOR [BHXH]
GO
ALTER TABLE [dbo].[PB_Nhanvien] ADD  CONSTRAINT [DF_PB_Nhanvien_BHYT]  DEFAULT ((1)) FOR [BHYT]
GO
ALTER TABLE [dbo].[PB_Nhanvien] ADD  CONSTRAINT [DF_PB_Nhanvien_BHTN]  DEFAULT ((1)) FOR [BHTN]
GO
ALTER TABLE [dbo].[PB_Nhanvien] ADD  CONSTRAINT [DF_PB_Nhanvien_Phicongdoan]  DEFAULT ((0)) FOR [Phicongdoan]
GO
ALTER TABLE [dbo].[PB_Phongban] ADD  CONSTRAINT [DF_Phongban_Tongsonhanvien]  DEFAULT ((0)) FOR [Tongsonhanvien]
GO
ALTER TABLE [dbo].[PB_PhucapNhanvien] ADD  CONSTRAINT [DF_PB_PhucapNhanvien_Sotien]  DEFAULT ((0)) FOR [Sotien]
GO
ALTER TABLE [dbo].[PB_SoLuong] ADD  CONSTRAINT [DF_Luongthucte_luongcoban]  DEFAULT ((0)) FOR [Hesoluong]
GO
ALTER TABLE [dbo].[PB_SoLuong] ADD  CONSTRAINT [DF_Soluong_Tonggiocong]  DEFAULT ((0)) FOR [Tonggiocongthucte]
GO
ALTER TABLE [dbo].[PB_SoLuong] ADD  CONSTRAINT [DF_Luongthucte_SNC]  DEFAULT ((0)) FOR [Nghiphep]
GO
ALTER TABLE [dbo].[PB_SoLuong] ADD  CONSTRAINT [DF_Luongthucte_BHXH]  DEFAULT ((0)) FOR [BHXH]
GO
ALTER TABLE [dbo].[PB_SoLuong] ADD  CONSTRAINT [DF_Luongthucte_BHYT]  DEFAULT ((0)) FOR [BHYT]
GO
ALTER TABLE [dbo].[PB_SoLuong] ADD  CONSTRAINT [DF_Luongthucte_BHTN]  DEFAULT ((0)) FOR [BHTN]
GO
ALTER TABLE [dbo].[PB_SoLuong] ADD  CONSTRAINT [DF_Soluong_Songuoiphuthuoc]  DEFAULT ((0)) FOR [Songuoiphuthuoc]
GO
ALTER TABLE [dbo].[PB_SoLuong] ADD  CONSTRAINT [DF_Luongthucte_TU]  DEFAULT ((0)) FOR [Tongtamung]
GO
ALTER TABLE [dbo].[PB_SoLuong] ADD  CONSTRAINT [DF_Soluong_Tongtrocap]  DEFAULT ((0)) FOR [Tongphucap]
GO
ALTER TABLE [dbo].[PB_Thaydoitongsongaychamcong] ADD  CONSTRAINT [DF_Thaydoisongaychamcong_Tongsongaychamcong]  DEFAULT ((26)) FOR [Tongsongaychamcong]
GO
ALTER TABLE [dbo].[PB_ToNhom] ADD  CONSTRAINT [DF_ToNhom_Tongsonhanvien]  DEFAULT ((0)) FOR [Tongsonhanvien]
GO
ALTER TABLE [dbo].[SYS_Nguoidung] ADD  CONSTRAINT [DF_Nguoidung_ResetPass]  DEFAULT (newid()) FOR [CodeResetPassForget]
GO
ALTER TABLE [dbo].[SYS_Nguoidung] ADD  CONSTRAINT [DF_Nguoidung_NumberOfLogin]  DEFAULT ((0)) FOR [NumberOfLogin]
GO
ALTER TABLE [dbo].[SYS_Nguoidung] ADD  CONSTRAINT [DF_SYS_Nguoidung_IsLock]  DEFAULT ((0)) FOR [IsLock]
GO
ALTER TABLE [dbo].[DIC_BacLuong]  WITH CHECK ADD  CONSTRAINT [FK_BacLuong_NgachLuong] FOREIGN KEY([MaNgach])
REFERENCES [dbo].[DIC_NgachLuong] ([MaNgach])
GO
ALTER TABLE [dbo].[DIC_BacLuong] CHECK CONSTRAINT [FK_BacLuong_NgachLuong]
GO
ALTER TABLE [dbo].[PB_ChamcongNhanvien]  WITH CHECK ADD  CONSTRAINT [FK_PB_ChamcongNhanvien_PB_Danhsachchamcong] FOREIGN KEY([Mabangchamcong])
REFERENCES [dbo].[PB_Danhsachchamcong] ([Mabangchamcong])
GO
ALTER TABLE [dbo].[PB_ChamcongNhanvien] CHECK CONSTRAINT [FK_PB_ChamcongNhanvien_PB_Danhsachchamcong]
GO
ALTER TABLE [dbo].[PB_Chamnghiphep]  WITH CHECK ADD  CONSTRAINT [FK_PB_Chamnghiphep_PB_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_Chamnghiphep] CHECK CONSTRAINT [FK_PB_Chamnghiphep_PB_Nhanvien]
GO
ALTER TABLE [dbo].[PB_Chamtangca]  WITH CHECK ADD  CONSTRAINT [FK_PB_Chamtangca_PB_Danhsachchamcong] FOREIGN KEY([Mabangchamcong])
REFERENCES [dbo].[PB_Danhsachchamcong] ([Mabangchamcong])
GO
ALTER TABLE [dbo].[PB_Chamtangca] CHECK CONSTRAINT [FK_PB_Chamtangca_PB_Danhsachchamcong]
GO
ALTER TABLE [dbo].[PB_Danhgianhanvien]  WITH CHECK ADD  CONSTRAINT [FK_PB_Danhgianhanvien_PB_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_Danhgianhanvien] CHECK CONSTRAINT [FK_PB_Danhgianhanvien_PB_Nhanvien]
GO
ALTER TABLE [dbo].[PB_Dicongtac]  WITH CHECK ADD  CONSTRAINT [FK_PB_Dicongtac_PB_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_Dicongtac] CHECK CONSTRAINT [FK_PB_Dicongtac_PB_Nhanvien]
GO
ALTER TABLE [dbo].[PB_KhautruNhanvien]  WITH CHECK ADD  CONSTRAINT [FK_PB_KhautruNhanvien_PB_Danhsachbangluong] FOREIGN KEY([Mabangluong])
REFERENCES [dbo].[PB_Danhsachbangluong] ([Mabangluong])
GO
ALTER TABLE [dbo].[PB_KhautruNhanvien] CHECK CONSTRAINT [FK_PB_KhautruNhanvien_PB_Danhsachbangluong]
GO
ALTER TABLE [dbo].[PB_KhenthuongNhanvien]  WITH CHECK ADD  CONSTRAINT [FK_PB_KhenthuongNhanvien_PB_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_KhenthuongNhanvien] CHECK CONSTRAINT [FK_PB_KhenthuongNhanvien_PB_Nhanvien]
GO
ALTER TABLE [dbo].[PB_KyluatNhanvien]  WITH CHECK ADD  CONSTRAINT [FK_PB_KyluatNhanvien_PB_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_KyluatNhanvien] CHECK CONSTRAINT [FK_PB_KyluatNhanvien_PB_Nhanvien]
GO
ALTER TABLE [dbo].[PB_Luonglamthem]  WITH CHECK ADD  CONSTRAINT [FK_PB_Luonglamthem_PB_Danhsachbangluong] FOREIGN KEY([Mabangluong])
REFERENCES [dbo].[PB_Danhsachbangluong] ([Mabangluong])
GO
ALTER TABLE [dbo].[PB_Luonglamthem] CHECK CONSTRAINT [FK_PB_Luonglamthem_PB_Danhsachbangluong]
GO
ALTER TABLE [dbo].[PB_Luongtangca]  WITH CHECK ADD  CONSTRAINT [FK_PB_Luongtangca_PB_Danhsachbangluong] FOREIGN KEY([Mabangluong])
REFERENCES [dbo].[PB_Danhsachbangluong] ([Mabangluong])
GO
ALTER TABLE [dbo].[PB_Luongtangca] CHECK CONSTRAINT [FK_PB_Luongtangca_PB_Danhsachbangluong]
GO
ALTER TABLE [dbo].[PB_Nguoithannhanvien]  WITH CHECK ADD  CONSTRAINT [FK_Nguoithannhanvien_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_Nguoithannhanvien] CHECK CONSTRAINT [FK_Nguoithannhanvien_Nhanvien]
GO
ALTER TABLE [dbo].[PB_Nguoithannhanvien]  WITH CHECK ADD  CONSTRAINT [FK_Nguoithannhanvien_Quanhegiadinh] FOREIGN KEY([Quanhe])
REFERENCES [dbo].[DIC_Quanhegiadinh] ([Maquanhe])
GO
ALTER TABLE [dbo].[PB_Nguoithannhanvien] CHECK CONSTRAINT [FK_Nguoithannhanvien_Quanhegiadinh]
GO
ALTER TABLE [dbo].[PB_Nhanvien]  WITH CHECK ADD  CONSTRAINT [FK_Nhanvien_Bangcap] FOREIGN KEY([Mabangcap])
REFERENCES [dbo].[DIC_Bangcap] ([Mabang])
GO
ALTER TABLE [dbo].[PB_Nhanvien] CHECK CONSTRAINT [FK_Nhanvien_Bangcap]
GO
ALTER TABLE [dbo].[PB_Nhanvien]  WITH CHECK ADD  CONSTRAINT [FK_Nhanvien_Chuyenmon] FOREIGN KEY([Machuyenmon])
REFERENCES [dbo].[DIC_Chuyenmon] ([Machuyenmon])
GO
ALTER TABLE [dbo].[PB_Nhanvien] CHECK CONSTRAINT [FK_Nhanvien_Chuyenmon]
GO
ALTER TABLE [dbo].[PB_Nhanvien]  WITH CHECK ADD  CONSTRAINT [FK_Nhanvien_Dantoc] FOREIGN KEY([Madantoc])
REFERENCES [dbo].[DIC_Dantoc] ([Madantoc])
GO
ALTER TABLE [dbo].[PB_Nhanvien] CHECK CONSTRAINT [FK_Nhanvien_Dantoc]
GO
ALTER TABLE [dbo].[PB_Nhanvien]  WITH CHECK ADD  CONSTRAINT [FK_Nhanvien_Quoctich] FOREIGN KEY([Maquoctich])
REFERENCES [dbo].[DIC_Quoctich] ([Maquoctich])
GO
ALTER TABLE [dbo].[PB_Nhanvien] CHECK CONSTRAINT [FK_Nhanvien_Quoctich]
GO
ALTER TABLE [dbo].[PB_Nhanvien]  WITH CHECK ADD  CONSTRAINT [FK_Nhanvien_Tinhoc] FOREIGN KEY([Matinhoc])
REFERENCES [dbo].[DIC_Tinhoc] ([MaTH])
GO
ALTER TABLE [dbo].[PB_Nhanvien] CHECK CONSTRAINT [FK_Nhanvien_Tinhoc]
GO
ALTER TABLE [dbo].[PB_Nhanvien]  WITH CHECK ADD  CONSTRAINT [FK_Nhanvien_Tongiao] FOREIGN KEY([Matongiao])
REFERENCES [dbo].[DIC_Tongiao] ([MaTG])
GO
ALTER TABLE [dbo].[PB_Nhanvien] CHECK CONSTRAINT [FK_Nhanvien_Tongiao]
GO
ALTER TABLE [dbo].[PB_Nhanvien]  WITH CHECK ADD  CONSTRAINT [FK_Nhanvien_ToNhom] FOREIGN KEY([MaToNhom])
REFERENCES [dbo].[PB_ToNhom] ([MaToNhom])
GO
ALTER TABLE [dbo].[PB_Nhanvien] CHECK CONSTRAINT [FK_Nhanvien_ToNhom]
GO
ALTER TABLE [dbo].[PB_Nhanvien]  WITH CHECK ADD  CONSTRAINT [FK_PB_Nhanvien_DIC_Ngonngu] FOREIGN KEY([Mangonngu])
REFERENCES [dbo].[DIC_Ngonngu] ([Mangonngu])
GO
ALTER TABLE [dbo].[PB_Nhanvien] CHECK CONSTRAINT [FK_PB_Nhanvien_DIC_Ngonngu]
GO
ALTER TABLE [dbo].[PB_PhucapNhanvien]  WITH CHECK ADD  CONSTRAINT [FK_PB_PhucapNhanvien_DIC_Phucap] FOREIGN KEY([Maphucap])
REFERENCES [dbo].[DIC_Phucap] ([Maphucap])
GO
ALTER TABLE [dbo].[PB_PhucapNhanvien] CHECK CONSTRAINT [FK_PB_PhucapNhanvien_DIC_Phucap]
GO
ALTER TABLE [dbo].[PB_PhucapNhanvien]  WITH CHECK ADD  CONSTRAINT [FK_PB_PhucapNhanvien_PB_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_PhucapNhanvien] CHECK CONSTRAINT [FK_PB_PhucapNhanvien_PB_Nhanvien]
GO
ALTER TABLE [dbo].[PB_SoLuong]  WITH CHECK ADD  CONSTRAINT [FK_Soluong_PB_Danhsachbangluong] FOREIGN KEY([Mabangluong])
REFERENCES [dbo].[PB_Danhsachbangluong] ([Mabangluong])
GO
ALTER TABLE [dbo].[PB_SoLuong] CHECK CONSTRAINT [FK_Soluong_PB_Danhsachbangluong]
GO
ALTER TABLE [dbo].[PB_Tainanlaodong]  WITH CHECK ADD  CONSTRAINT [FK_PB_Tainanlaodong_PB_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_Tainanlaodong] CHECK CONSTRAINT [FK_PB_Tainanlaodong_PB_Nhanvien]
GO
ALTER TABLE [dbo].[PB_TamungNhanvien]  WITH CHECK ADD  CONSTRAINT [FK_PB_TamungNhanvien_PB_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_TamungNhanvien] CHECK CONSTRAINT [FK_PB_TamungNhanvien_PB_Nhanvien]
GO
ALTER TABLE [dbo].[PB_Thaydoibacluong]  WITH CHECK ADD  CONSTRAINT [FK_Thaydoibacluong_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_Thaydoibacluong] CHECK CONSTRAINT [FK_Thaydoibacluong_Nhanvien]
GO
ALTER TABLE [dbo].[PB_Thaydoichucvu]  WITH CHECK ADD  CONSTRAINT [FK_Thangchuc_Chucvu] FOREIGN KEY([Machucvu])
REFERENCES [dbo].[DIC_Chucvu] ([Machucvu])
GO
ALTER TABLE [dbo].[PB_Thaydoichucvu] CHECK CONSTRAINT [FK_Thangchuc_Chucvu]
GO
ALTER TABLE [dbo].[PB_Thaydoichucvu]  WITH CHECK ADD  CONSTRAINT [FK_Thangchuc_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_Thaydoichucvu] CHECK CONSTRAINT [FK_Thangchuc_Nhanvien]
GO
ALTER TABLE [dbo].[PB_Thaydoicongviec]  WITH CHECK ADD  CONSTRAINT [FK_Thaydoicongviec_Congviec] FOREIGN KEY([Macongviec])
REFERENCES [dbo].[DIC_Congviec] ([Macongviec])
GO
ALTER TABLE [dbo].[PB_Thaydoicongviec] CHECK CONSTRAINT [FK_Thaydoicongviec_Congviec]
GO
ALTER TABLE [dbo].[PB_Thaydoicongviec]  WITH CHECK ADD  CONSTRAINT [FK_Thaydoicongviec_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_Thaydoicongviec] CHECK CONSTRAINT [FK_Thaydoicongviec_Nhanvien]
GO
ALTER TABLE [dbo].[PB_Thaydoiphongban]  WITH CHECK ADD  CONSTRAINT [FK_Congviec_Nhanvien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[PB_Nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[PB_Thaydoiphongban] CHECK CONSTRAINT [FK_Congviec_Nhanvien]
GO
ALTER TABLE [dbo].[PB_Thaydoiphongban]  WITH CHECK ADD  CONSTRAINT [FK_Congviec_Phongban] FOREIGN KEY([Maphong])
REFERENCES [dbo].[PB_Phongban] ([Maphong])
GO
ALTER TABLE [dbo].[PB_Thaydoiphongban] CHECK CONSTRAINT [FK_Congviec_Phongban]
GO
ALTER TABLE [dbo].[SYS_Nhatkyhethong]  WITH CHECK ADD  CONSTRAINT [FK_SYS_Nhatkyhethong_SYS_Chucnang] FOREIGN KEY([Hanhdong])
REFERENCES [dbo].[SYS_Chucnang] ([FunctionID])
GO
ALTER TABLE [dbo].[SYS_Nhatkyhethong] CHECK CONSTRAINT [FK_SYS_Nhatkyhethong_SYS_Chucnang]
GO
ALTER TABLE [dbo].[SYS_Nhatkyhethong]  WITH CHECK ADD  CONSTRAINT [FK_SYS_Nhatkyhethong_SYS_Hanhdong1] FOREIGN KEY([Hanhdong])
REFERENCES [dbo].[SYS_Hanhdong] ([ActivityID])
GO
ALTER TABLE [dbo].[SYS_Nhatkyhethong] CHECK CONSTRAINT [FK_SYS_Nhatkyhethong_SYS_Hanhdong1]
GO
ALTER TABLE [dbo].[SYS_PhanQuyen]  WITH CHECK ADD  CONSTRAINT [FK_SYS_PhanQuyen_SYS_Nguoidung] FOREIGN KEY([UserID])
REFERENCES [dbo].[SYS_Nguoidung] ([ID])
GO
ALTER TABLE [dbo].[SYS_PhanQuyen] CHECK CONSTRAINT [FK_SYS_PhanQuyen_SYS_Nguoidung]
GO
ALTER TABLE [dbo].[SYS_PhanQuyen]  WITH CHECK ADD  CONSTRAINT [FK_SYS_PhanQuyen_SYS_Quyen] FOREIGN KEY([RollID])
REFERENCES [dbo].[SYS_Quyen] ([ID])
GO
ALTER TABLE [dbo].[SYS_PhanQuyen] CHECK CONSTRAINT [FK_SYS_PhanQuyen_SYS_Quyen]
GO
/****** Object:  Statistic [_WA_Sys_00000002_31EC6D26]     ******/
CREATE STATISTICS [_WA_Sys_00000002_31EC6D26] ON [dbo].[DIC_BacLuong]([Bac]) WITH STATS_STREAM = 0x0100000001000000000000000000000032BCFA2C00000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000FF3C61013FA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_31EC6D26]     ******/
CREATE STATISTICS [_WA_Sys_00000003_31EC6D26] ON [dbo].[DIC_BacLuong]([Tenbac]) WITH STATS_STREAM = 0x0100000001000000000000000000000011CBA397000000000B02000000000000CB01000000000000E7030000E7000000640000000000000008D00034000000000700000031C364013FA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000020410000803F0000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004200AD1E630020003100FF0100000000000000010000000100000028000000280000000000000000000000050000004200AD1E630020003100020000004000000000010500000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_31EC6D26]     ******/
CREATE STATISTICS [_WA_Sys_00000004_31EC6D26] ON [dbo].[DIC_BacLuong]([Heso]) WITH STATS_STREAM = 0x0100000001000000000000000000000005FE665C00000000BF010000000000007F010000000000003E03B1F53E00000008003500000000000000000000000000070000003AC364013FA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F0000000000000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_31EC6D26]     ******/
CREATE STATISTICS [_WA_Sys_00000005_31EC6D26] ON [dbo].[DIC_BacLuong]([GhiChu]) WITH STATS_STREAM = 0x01000000010000000000000000000000345FAC17000000001702000000000000D701000000000000E7020000E7000000C80000000000000008D00034FE070000070000003AC364013FA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000002F0000000000000073000000000000000800000000000000300010000000803F000000000000803F0400000100270061007300640066006100730064006600FF01000000000000000100000001000000280000002800000000000000000000000800000061007300640066006100730064006600020000004000000000010800000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_31EC6D26]     ******/
CREATE STATISTICS [_WA_Sys_00000006_31EC6D26] ON [dbo].[DIC_BacLuong]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000323616F500000000C7010000000000008701000000000000240386DD2400000010000000000000000000000001000000070000003AC364013FA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_31EC6D26]     ******/
CREATE STATISTICS [_WA_Sys_00000007_31EC6D26] ON [dbo].[DIC_BacLuong]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000B5AF146500000000BF010000000000007F010000000000003D0313003D000000080017030000000000000000010000000700000049C364013FA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803FF1CF57013FA00000040000
GO
/****** Object:  Statistic [PK_BacLuong]     ******/
UPDATE STATISTICS [dbo].[DIC_BacLuong]([PK_BacLuong]) WITH STATS_STREAM = 0x010000000200000000000000000000000EED59A400000000D3010000000000007B01000000000000380300003800000004000A00000000000000000000000000380300413800000004000A0000000000000000000000000007000000932F60013FA0000001000000000000000100000000000000000000000000803F0000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000200000014000000000000410000803F00000000000080400000804000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F02000000040000, ROWCOUNT = 6, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_3B40CD36]     ******/
CREATE STATISTICS [_WA_Sys_00000002_3B40CD36] ON [dbo].[DIC_Bangcap]([Tenbang]) WITH STATS_STREAM = 0x010000000100000000000000000000007E18C977000000000702000000000000C701000000000000E7030000E7000000640000000000000008D0003400000000070000002BA9EA0037A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000000410000803F0000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000270000000000000063000000000000000800000000000000300010000000803F000000000000803F04000001001F005400480043005300FF0100000000000000010000000100000028000000280000000000000000000000040000005400480043005300020000004000000000010400000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_3B40CD36]     ******/
CREATE STATISTICS [_WA_Sys_00000003_3B40CD36] ON [dbo].[DIC_Bangcap]([GhiChu]) WITH STATS_STREAM = 0x01000000010000000000000000000000AA8E9081000000000702000000000000C701000000000000E702FFFFE7000000C80000000000000008D0003400000000070000002BA9EA0037A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000000410000803F0000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000270000000000000063000000000000000800000000000000300010000000803F000000000000803F04000001001F005400480043005300FF0100000000000000010000000100000028000000280000000000000000000000040000005400480043005300020000004000000000010400000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_3B40CD36]     ******/
CREATE STATISTICS [_WA_Sys_00000004_3B40CD36] ON [dbo].[DIC_Bangcap]([CreatedByUser]) WITH STATS_STREAM = 0x0100000001000000000000000000000020FBDD3000000000C701000000000000870100000000000024030ADE2400000010000000000000000000000001000000070000002BA9EA0037A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_3B40CD36]     ******/
CREATE STATISTICS [_WA_Sys_00000005_3B40CD36] ON [dbo].[DIC_Bangcap]([CreatedByDate]) WITH STATS_STREAM = 0x010000000100000000000000000000007B590A4100000000BF010000000000007F010000000000003D03B1F53D00000008001703000000000000000000000000070000002BA9EA0037A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F6F5AEA0037A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_3B40CD36]     ******/
CREATE STATISTICS [_WA_Sys_00000006_3B40CD36] ON [dbo].[DIC_Bangcap]([IsActive]) WITH STATS_STREAM = 0x01000000010000000000000000000000E24DA96E0000000094010000000000005401000000000000680200006800000001000100000000000000000001000000070000002BA9EA0037A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000011000000000000000000803F0000803F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
GO
/****** Object:  Statistic [PK_Bangcap_1]     ******/
UPDATE STATISTICS [dbo].[DIC_Bangcap]([PK_Bangcap_1]) WITH STATS_STREAM = 0x01000000010000000000000000000000220BB37A00000000BB010000000000007B01000000000000380300003800000004000A00000000000000000000000000070000002BA9EA0037A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 3, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000002_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([Ngayapdung]) WITH STATS_STREAM = 0x010000000100000000000000000000002642C4AA00000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000000100000007000000A4DE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F9A9C270049A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000003_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([IsCurrent]) WITH STATS_STREAM = 0x01000000010000000000000000000000C56D6DEF00000000B801000000000000780100000000000068030000680000000100010000000000000000000100000007000000A4DE330049A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000004_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([BHXH]) WITH STATS_STREAM = 0x0100000001000000000000000000000050AFD15300000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000100000007000000A4DE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000000000F83F040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000005_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([BHYT]) WITH STATS_STREAM = 0x010000000100000000000000000000000592EB0300000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000100000007000000A9DE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F333333333333F33F040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000006_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([BHTN]) WITH STATS_STREAM = 0x01000000010000000000000000000000EFD94A6C00000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000100000007000000A9DE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F9A9999999999F93F040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000007_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([BHXHMAX]) WITH STATS_STREAM = 0x01000000010000000000000000000000E7BB1C0E00000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000100000007000000A9DE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F00E1F505040000
GO
/****** Object:  Statistic [_WA_Sys_00000008_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000008_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([Phicongdoan]) WITH STATS_STREAM = 0x0100000001000000000000000000000034097C1100000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000100000007000000A9DE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000000000E03F040000
GO
/****** Object:  Statistic [_WA_Sys_00000009_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000009_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([PhicongdoanMax]) WITH STATS_STREAM = 0x01000000010000000000000000000000E538DC0900000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000100000007000000A9DE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803FE0930400040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_0000000A_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([TinhThueTNCN]) WITH STATS_STREAM = 0x01000000010000000000000000000000416699D800000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000100000007000000A9DE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F404B4C00040000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_0000000B_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([Chinguoiphuthuoc]) WITH STATS_STREAM = 0x0100000001000000000000000000000076CA360800000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000100000007000000A9DE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F804F1200040000
GO
/****** Object:  Statistic [_WA_Sys_0000000C_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_0000000C_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([Tangcathuong]) WITH STATS_STREAM = 0x0100000001000000000000000000000077D5EC4100000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000100000007000000A9DE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000000000F83F040000
GO
/****** Object:  Statistic [_WA_Sys_0000000D_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_0000000D_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([Tangchunhat]) WITH STATS_STREAM = 0x01000000010000000000000000000000341DD30900000000BF010000000000007F010000000000003E037BDD3E0000000800350000000000000000000000000007000000AEDE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F0000000000000040040000
GO
/****** Object:  Statistic [_WA_Sys_0000000E_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_0000000E_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([Tangnghile]) WITH STATS_STREAM = 0x01000000010000000000000000000000F556A33900000000BF010000000000007F010000000000003E037BDD3E0000000800350000000000000000000000000007000000AEDE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F0000000000000840040000
GO
/****** Object:  Statistic [_WA_Sys_0000000F_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_0000000F_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([Nguoiky]) WITH STATS_STREAM = 0x01000000010000000000000000000000B2A391AC000000003B02000000000000FB01000000000000E7030000E7000000C80000000000000008D000340000000007000000AEDE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000008420000803F0000000000000842000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000410000000000000097000000000000000800000000000000300010000000803F000000000000803F040000010039004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300FF0100000000000000010000000100000028000000280000000000000000000000110000004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300020000004000000000011100000000
GO
/****** Object:  Statistic [_WA_Sys_00000010_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000010_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([Chucvunguoiky]) WITH STATS_STREAM = 0x01000000010000000000000000000000C74B6711000000002B02000000000000EB01000000000000E7030000E7000000640000000000000008D000340000000007000000AEDE330049A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000D0410000803F000000000000D041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000390000000000000087000000000000000800000000000000300010000000803F000000000000803F040000010031005400D51E6E006700200067006900E1006D0020001101D11E6300FF01000000000000000100000001000000280000002800000000000000000000000D0000005400D51E6E006700200067006900E1006D0020001101D11E6300020000004000000000010D00000000
GO
/****** Object:  Statistic [_WA_Sys_00000011_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000011_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([Ngayky]) WITH STATS_STREAM = 0x01000000010000000000000000000000AC3EF25F00000000BF010000000000007F010000000000003D0382DD3D0000000800170300000000000000000000000007000000AEDE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F0000000049A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000012_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000012_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([Mota]) WITH STATS_STREAM = 0x010000000100000000000000000000005AA264F000000000AF020000000000006F020000000000006303000063000000FFFF00000000000008D000340000000007000000BCDE330049A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000B8420000803F000000000000B8420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000007B000000000000000B010000000000000800000000000000300010000000803F000000000000803F040000010073004C00B001DD1E6900200076006900BF1E7400200071007500E10020006100680021000D000A004E006700B001DD1E6900200073006100750020007600E0006F00200076006900BF1E740020006C00A11E690020006E00680061002100FF01000000000000000100000001000000280000002800000000000000000000002E0000004C00B001DD1E6900200076006900BF1E7400200071007500E10020006100680021000D000A004E006700B001DD1E6900200073006100750020007600E0006F00200076006900BF1E740020006C00A11E690020006E00680061002100020000004000000000012E00000000
GO
/****** Object:  Statistic [_WA_Sys_00000013_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000013_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([CreatedByUser]) WITH STATS_STREAM = 0x010000000100000000000000000000002BC9123000000000C70100000000000087010000000000002403B1F5240000001000000000000000000000000000000007000000BCDE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000014_0880433F]     ******/
CREATE STATISTICS [_WA_Sys_00000014_0880433F] ON [dbo].[DIC_Cauhinhcongthuc]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000D5CEFEB700000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000002400000007000000BCDE330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803FAD9C270049A00000040000
GO
/****** Object:  Statistic [PK_Baohiem]     ******/
UPDATE STATISTICS [dbo].[DIC_Cauhinhcongthuc]([PK_Baohiem]) WITH STATS_STREAM = 0x01000000010000000000000000000000D5C22B7500000000C701000000000000870100000000000024030000240000001000000000000000000000000000000007000000E99C270049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803F00000000000000000000000000000000040000, ROWCOUNT = 2, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_3F115E1A]     ******/
CREATE STATISTICS [_WA_Sys_00000002_3F115E1A] ON [dbo].[DIC_Chucvu]([Tenchucvu]) WITH STATS_STREAM = 0x0100000001000000000000000000000094E4DAA3000000002B02000000000000EB01000000000000E7030000E7000000640000000000000008D00034240000000700000062D0B6003BA0000002000000000000000200000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000D04100000040000000000000D0410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000003900000000000000870000000000000008000000000000003000100000000040000000000000803F040000010031005400D51E6E006700200067006900E1006D0020001101D11E6300FF01000000000000000200000001000000280000002800000000000000000000000D0000005400D51E6E006700200067006900E1006D0020001101D11E6300020000004000000000020D00000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_3F115E1A]     ******/
CREATE STATISTICS [_WA_Sys_00000003_3F115E1A] ON [dbo].[DIC_Chucvu]([Captren]) WITH STATS_STREAM = 0x010000000100000000000000000000009A54FA2F00000000BB010000000000007B01000000000000380300003800000004000A00000000000000000000000000070000006BD0B6003BA0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000004000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F0000000000000008000000000000001000140000000040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_3F115E1A]     ******/
CREATE STATISTICS [_WA_Sys_00000004_3F115E1A] ON [dbo].[DIC_Chucvu]([GhiChu]) WITH STATS_STREAM = 0x0100000001000000000000000000000051059F060000000043020000000000000302000000000000E7020000E7000000C80000000000000008D0003400000000070000006BD0B6003BA0000002000000000000000200000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000184200000040000000000000184200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000045000000000000009F0000000000000008000000000000003000100000000040000000000000803F04000001003D0042006F007300730020006300E71E610020006300F4006E00670020007400790020001101F300FF01000000000000000200000001000000280000002800000000000000000000001300000042006F007300730020006300E71E610020006300F4006E00670020007400790020001101F300020000004000000000021300000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_3F115E1A]     ******/
CREATE STATISTICS [_WA_Sys_00000005_3F115E1A] ON [dbo].[DIC_Chucvu]([CreatedByUser]) WITH STATS_STREAM = 0x010000000100000000000000000000004998080200000000C701000000000000870100000000000024030000240000001000000000000000000000007F000000070000006BD0B6003BA0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000004000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B0000000000000008000000000000001000200000000040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_3F115E1A]     ******/
CREATE STATISTICS [_WA_Sys_00000006_3F115E1A] ON [dbo].[DIC_Chucvu]([CreatedByDate]) WITH STATS_STREAM = 0x010000000100000000000000000000009C2F703C00000000E201000000000000A2010000000000003D0300003D00000008001703000000000000000000000000070000006BD0B6003BA0000002000000000000000200000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000002000000010000001800000000000041000000400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000460000000000000010000000000000002B00000000000000100018000000803F000000000000803F29C5B3003BA00000040000100018000000803F000000000000803FFAE0B3003BA00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_3F115E1A]     ******/
CREATE STATISTICS [_WA_Sys_00000007_3F115E1A] ON [dbo].[DIC_Chucvu]([IsActive]) WITH STATS_STREAM = 0x010000000100000000000000000000008CA455AD00000000940100000000000054010000000000006802B1F56800000001000100000000000000000001000000070000006BD0B6003BA0000002000000000000000200000000000000000000000000803F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000001100000000000000000000400000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
GO
/****** Object:  Statistic [PK_Chucvu]     ******/
UPDATE STATISTICS [dbo].[DIC_Chucvu]([PK_Chucvu]) WITH STATS_STREAM = 0x01000000010000000000000000000000989E17EC00000000DA010000000000009A01000000000000380300003800000004000A000000000000000000000000000700000054D0B6003BA0000002000000000000000200000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000014000000000080400000004000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003E0000000000000010000000000000002700000000000000100014000000803F000000000000803F01000000040000100014000000803F000000000000803F02000000040000, ROWCOUNT = 6, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_498EEC8D]     ******/
CREATE STATISTICS [_WA_Sys_00000002_498EEC8D] ON [dbo].[DIC_Chuyenmon]([Tenchuyenmon]) WITH STATS_STREAM = 0x010000000100000000000000000000007ADDF53F0000000077020000000000003702000000000000E7030000E7000000640000000000000008D0003400000000070000003D36690151A0000002000000000000000200000000000000000000000000003F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000200000001000000100000000000B84100000040000000000000B8410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000006C00000000000000D30000000000000010000000000000004D00000000000000300010000000803F000000000000803F04000001003D004300F4006E00670020006E0067006800C71E200074006800F4006E0067002000740069006E00300010000000803F000000000000803F04000001001F007400650073006500FF0100000000000000020000000200000028000000280000000000000000000000170000004300F4006E00670020006E0067006800C71E200074006800F4006E0067002000740069006E0074006500730065000300000040000000008113000000010413000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_498EEC8D]     ******/
CREATE STATISTICS [_WA_Sys_00000003_498EEC8D] ON [dbo].[DIC_Chuyenmon]([GhiChu]) WITH STATS_STREAM = 0x01000000010000000000000000000000A0CDA74600000000EE01000000000000AE01000000000000E7020000E7000000C80000000000000008D0003400000000070000004136690151A0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000001B000000000000004A0000000000000008000000000000001000100000000040000000000000803F040000FF01000000000000000200000001000000280000002800000000000000000000000000000001000000020000000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_498EEC8D]     ******/
CREATE STATISTICS [_WA_Sys_00000004_498EEC8D] ON [dbo].[DIC_Chuyenmon]([CreatedByUser]) WITH STATS_STREAM = 0x010000000100000000000000000000006F85B88D00000000C70100000000000087010000000000002403B1F52400000010000000000000000000000000000000070000005D36690151A0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000004000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B0000000000000008000000000000001000200000000040000000000000803FE462C85681267D4BA0D2A6FB4F4257F8040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_498EEC8D]     ******/
CREATE STATISTICS [_WA_Sys_00000005_498EEC8D] ON [dbo].[DIC_Chuyenmon]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000B6478CF000000000E201000000000000A2010000000000003D0300003D00000008001703000000000000000000000000070000006236690151A0000002000000000000000200000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000002000000010000001800000000000041000000400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000460000000000000010000000000000002B00000000000000100018000000803F000000000000803F2C005B0138A00000040000100018000000803F000000000000803FE61C690151A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_498EEC8D]     ******/
CREATE STATISTICS [_WA_Sys_00000006_498EEC8D] ON [dbo].[DIC_Chuyenmon]([IsActive]) WITH STATS_STREAM = 0x01000000010000000000000000000000407C9EAE00000000B8010000000000007801000000000000680200006800000001000100000000000000000001000000070000001A86F00044A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F01040000
GO
/****** Object:  Statistic [PK_Chuyenmon_1]     ******/
UPDATE STATISTICS [dbo].[DIC_Chuyenmon]([PK_Chuyenmon_1]) WITH STATS_STREAM = 0x0100000001000000000000000000000046A97CA000000000BB010000000000007B01000000000000380300003800000004000A000000000000000000000000000700000024045B0138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 1, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_793DFFAF]     ******/
CREATE STATISTICS [_WA_Sys_00000002_793DFFAF] ON [dbo].[DIC_Congviec]([Tencongviec]) WITH STATS_STREAM = 0x01000000010000000000000000000000D055ADE4000000002302000000000000E301000000000000E7030000E7000000640000000000000008D000340100000007000000DAB3590138A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000B0410000803F000000000000B04100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000035000000000000007F000000000000000800000000000000300010000000803F000000000000803F04000001002D004C00AF1E700020007200AF1E700020006D00E1007900FF01000000000000000100000001000000280000002800000000000000000000000B0000004C00AF1E700020007200AF1E700020006D00E1007900020000004000000000010B00000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_793DFFAF]     ******/
CREATE STATISTICS [_WA_Sys_00000003_793DFFAF] ON [dbo].[DIC_Congviec]([GhiChu]) WITH STATS_STREAM = 0x010000000100000000000000000000008967F3E000000000EE01000000000000AE01000000000000E7020A02E7000000C80000000000000008D000340100000007000000DAB3590138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000000000000803F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000001B000000000000004A000000000000000800000000000000100010000000803F000000000000803F040000FF01000000000000000100000001000000280000002800000000000000000000000000000001000000010000000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_793DFFAF]     ******/
CREATE STATISTICS [_WA_Sys_00000004_793DFFAF] ON [dbo].[DIC_Congviec]([CreatedByUser]) WITH STATS_STREAM = 0x0100000001000000000000000000000025A7FEFB00000000C70100000000000087010000000000002403B1F5240000001000000000000000000000000000000007000000DFB3590138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_793DFFAF]     ******/
CREATE STATISTICS [_WA_Sys_00000005_793DFFAF] ON [dbo].[DIC_Congviec]([CreatedByDate]) WITH STATS_STREAM = 0x0100000001000000000000000000000059A1A51D00000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000002400000007000000DFB3590138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F63AF590138A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_793DFFAF]     ******/
CREATE STATISTICS [_WA_Sys_00000006_793DFFAF] ON [dbo].[DIC_Congviec]([IsActive]) WITH STATS_STREAM = 0x01000000010000000000000000000000D25B3C8800000000B801000000000000780100000000000068020000680000000100010000000000000000002400000007000000E3B3590138A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F00040000
GO
/****** Object:  Statistic [PK_Congviec_1]     ******/
UPDATE STATISTICS [dbo].[DIC_Congviec]([PK_Congviec_1]) WITH STATS_STREAM = 0x010000000100000000000000000000003CA81B9C00000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000E4B1590138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 4, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000006_46B27FE2]     ******/
CREATE STATISTICS [_WA_Sys_00000006_46B27FE2] ON [dbo].[DIC_Dantoc]([IsActive]) WITH STATS_STREAM = 0x01000000010000000000000000000000D1FEFE3C00000000B801000000000000780100000000000068021300680000000100010000000000000000000100000007000000F485F00044A0000003000000000000000300000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F00004040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C0000000000000008000000000000001000110000004040000000000000803F01040000
GO
/****** Object:  Statistic [PK_Dantoc]     ******/
UPDATE STATISTICS [dbo].[DIC_Dantoc]([PK_Dantoc]) WITH STATS_STREAM = 0x0100000001000000000000000000000014B4CD5800000000DA010000000000009A01000000000000380300003800000004000A0000000000000000000008000007000000F4C0490047A00000030000000000000003000000000000000000803FABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000014000000000080400000404000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003E0000000000000010000000000000002700000000000000100014000000803F000000000000803F01000000040000100014000000803F0000803F0000803F03000000040000, ROWCOUNT = 4, PAGECOUNT = 1
GO
/****** Object:  Statistic [PK_NgachLuong]     ******/
UPDATE STATISTICS [dbo].[DIC_NgachLuong]([PK_NgachLuong]) WITH STATS_STREAM = 0x01000000010000000000000000000000127FE00200000000F901000000000000B901000000000000380300003800000004000A0000000000000000000000000007000000382DFA003FA00000040000000000000004000000000000000000803F0000803E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000014000000000080400000804000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000005D0000000000000018000000000000002F000000000000004600000000000000100014000000803F000000000000803F01000000040000100014000000803F0000803F0000803F03000000040000100014000000803F000000000000803F04000000040000, ROWCOUNT = 4, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000006_43D61337]     ******/
CREATE STATISTICS [_WA_Sys_00000006_43D61337] ON [dbo].[DIC_Ngonngu]([IsActive]) WITH STATS_STREAM = 0x01000000010000000000000000000000018F8E7100000000B80100000000000078010000000000006802FFFF6800000001000100000000000000000000000000070000001086F00044A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F01040000
GO
/****** Object:  Statistic [PK_Ngonngu]     ******/
UPDATE STATISTICS [dbo].[DIC_Ngonngu]([PK_Ngonngu]) WITH STATS_STREAM = 0x01000000010000000000000000000000DFE6A1FF00000000BB010000000000007B01000000000000380300003800000004000A00000000000000000000000000070000002A0F5D0138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 1, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_0EA330E9]     ******/
CREATE STATISTICS [_WA_Sys_00000002_0EA330E9] ON [dbo].[DIC_Phucap]([Tenphucap]) WITH STATS_STREAM = 0x010000000100000000000000000000006C50EDD7000000000F02000000000000CF01000000000000E7030000E7000000640000000000000008D00034380000000700000002D7580138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000040410000803F00000000000040410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000002B000000000000006B000000000000000800000000000000300010000000803F000000000000803F040000010023001001690020006C00A11E6900FF0100000000000000010000000100000028000000280000000000000000000000060000001001690020006C00A11E6900020000004000000000010600000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_0EA330E9]     ******/
CREATE STATISTICS [_WA_Sys_00000003_0EA330E9] ON [dbo].[DIC_Phucap]([Tienlonnhat]) WITH STATS_STREAM = 0x01000000010000000000000000000000AFC118CF00000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000010000000700000010D7580138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F14E20100040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_0EA330E9]     ******/
CREATE STATISTICS [_WA_Sys_00000004_0EA330E9] ON [dbo].[DIC_Phucap]([GhiChu]) WITH STATS_STREAM = 0x0100000001000000000000000000000071A145280000000067020000000000002702000000000000E7020000E7000000C80000000000000008D00034010000000700000010D7580138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000060420000803F00000000000060420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000005700000000000000C3000000000000000800000000000000300010000000803F000000000000803F04000001004F0050006800E51E20006300A51E700020001101690020006C00A11E69002000630068006F0020006E006800E2006E00200076006900EA006E00FF01000000000000000100000001000000280000002800000000000000000000001C00000050006800E51E20006300A51E700020001101690020006C00A11E69002000630068006F0020006E006800E2006E00200076006900EA006E00020000004000000000011C00000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_0EA330E9]     ******/
CREATE STATISTICS [_WA_Sys_00000005_0EA330E9] ON [dbo].[DIC_Phucap]([CreatedByUser]) WITH STATS_STREAM = 0x0100000001000000000000000000000096DBB0E700000000C70100000000000087010000000000002403FFFF24000000100000000000000000000000000000000700000010D7580138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_0EA330E9]     ******/
CREATE STATISTICS [_WA_Sys_00000006_0EA330E9] ON [dbo].[DIC_Phucap]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000937D9E3900000000BF010000000000007F010000000000003D0300003D000000080017030000000000000000240000000700000010D7580138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F2DC5580138A00000040000
GO
/****** Object:  Statistic [PK_DIC_Phucap]     ******/
UPDATE STATISTICS [dbo].[DIC_Phucap]([PK_DIC_Phucap]) WITH STATS_STREAM = 0x01000000010000000000000000000000BA105B2500000000BB010000000000007B01000000000000380300003800000004000A000000000000000000000000000700000033CB580138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 3, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_531856C7]     ******/
CREATE STATISTICS [_WA_Sys_00000002_531856C7] ON [dbo].[DIC_Quanhegiadinh]([Tenquanhe]) WITH STATS_STREAM = 0x010000000100000000000000000000001E3F94D8000000003B02000000000000FB01000000000000E7030000E7000000640000000000000008D000340000000007000000E5ED5D0138A0000002000000000000000200000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000010000000000000410000004000000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000004E00000000000000970000000000000010000000000000002B00000000000000300010000000803F000000000000803F04000001001B004200D11E300010000000803F000000000000803F040000010023001001690020006C00A11E6900FF0100000000000000020000000200000028000000280000000000000000000000080000004200D11E1001690020006C00A11E69000300000040000000008102000000010602000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_531856C7]     ******/
CREATE STATISTICS [_WA_Sys_00000003_531856C7] ON [dbo].[DIC_Quanhegiadinh]([GhiChu]) WITH STATS_STREAM = 0x01000000010000000000000000000000A56562F1000000007B020000000000003B02000000000000E7020000E7000000C80000000000000008D000340000000007000000E5ED5D0138A0000002000000000000000200000000000000000000000000003F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000200000001000000100000000000C04100000040000000000000C0410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000006E00000000000000D70000000000000010000000000000002F00000000000000300010000000803F000000000000803F04000001001F006100730064006600300010000000803F000000000000803F04000001003F0043006800610020006300E71E610020006E006800E2006E00200076006900EA006E0020003A002900FF010000000000000002000000020000002800000028000000000000000000000018000000610073006400660043006800610020006300E71E610020006E006800E2006E00200076006900EA006E0020003A0029000300000040000000008104000000011404000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_531856C7]     ******/
CREATE STATISTICS [_WA_Sys_00000004_531856C7] ON [dbo].[DIC_Quanhegiadinh]([CreatedByUser]) WITH STATS_STREAM = 0x0100000001000000000000000000000039DE968C00000000C701000000000000870100000000000024030C0224000000100000000000000000000000FFFFFFFF07000000E5ED5D0138A0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000004000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B0000000000000008000000000000001000200000000040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_531856C7]     ******/
CREATE STATISTICS [_WA_Sys_00000005_531856C7] ON [dbo].[DIC_Quanhegiadinh]([CreatedByDate]) WITH STATS_STREAM = 0x0100000001000000000000000000000099EFB7CF00000000E201000000000000A2010000000000003D0300003D0000000800170300000000000000000000000007000000E5ED5D0138A0000002000000000000000200000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000002000000010000001800000000000041000000400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000460000000000000010000000000000002B00000000000000100018000000803F000000000000803FE9C85D0138A00000040000100018000000803F000000000000803FD8E85D0138A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_531856C7]     ******/
CREATE STATISTICS [_WA_Sys_00000006_531856C7] ON [dbo].[DIC_Quanhegiadinh]([IsActive]) WITH STATS_STREAM = 0x01000000010000000000000000000000D3AC847000000000B801000000000000780100000000000068020000680000000100010000000000000000000100000007000000E5ED5D0138A0000002000000000000000200000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F00000040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C0000000000000008000000000000001000110000000040000000000000803F01040000
GO
/****** Object:  Statistic [PK_Quanhegiadinh]     ******/
UPDATE STATISTICS [dbo].[DIC_Quanhegiadinh]([PK_Quanhegiadinh]) WITH STATS_STREAM = 0x01000000010000000000000000000000FDA0044600000000BB010000000000007B01000000000000380300003800000004000A000000000000000000000000000700000092CC5D0138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 3, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_173876EA]     ******/
CREATE STATISTICS [_WA_Sys_00000002_173876EA] ON [dbo].[DIC_Quoctich]([Tenquoctich]) WITH STATS_STREAM = 0x010000000100000000000000000000002583DB79000000007B020000000000003B02000000000000E7030000E7000000640000000000000008D000340000000007000000F4435E0138A000000300000000000000030000000000000000000000ABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000010000000000020410000404000000000000020410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000007B00000000000000D700000000000000180000000000000035000000000000005400000000000000300010000000803F000000000000803F04000001001D004C00E0006F00300010000000803F000000000000803F04000001001F007400650073007400300010000000803F000000000000803F0400000100270056006900C71E740020004E0061006D00FF01000000000000000300000003000000280000002800000000000000000000000F0000004C00E0006F00740065007300740056006900C71E740020004E0061006D0004000000400000000081030000008104030000010807000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_173876EA]     ******/
CREATE STATISTICS [_WA_Sys_00000003_173876EA] ON [dbo].[DIC_Quoctich]([GhiChu]) WITH STATS_STREAM = 0x01000000010000000000000000000000BCCA7CFB00000000EE01000000000000AE01000000000000E7020000E7000000C80000000000000008D000340000000007000000F4435E0138A0000003000000000000000300000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000000000000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000001B000000000000004A0000000000000008000000000000001000100000004040000000000000803F040000FF01000000000000000300000001000000280000002800000000000000000000000000000001000000030000000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_173876EA]     ******/
CREATE STATISTICS [_WA_Sys_00000004_173876EA] ON [dbo].[DIC_Quoctich]([CreatedByUser]) WITH STATS_STREAM = 0x0100000001000000000000000000000048FFFB9F00000000C70100000000000087010000000000002403B1F5240000001000000000000000000000000000000007000000F4435E0138A0000003000000000000000300000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000404000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B0000000000000008000000000000001000200000004040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_173876EA]     ******/
CREATE STATISTICS [_WA_Sys_00000005_173876EA] ON [dbo].[DIC_Quoctich]([CreatedByDate]) WITH STATS_STREAM = 0x010000000100000000000000000000009ED02DB3000000000502000000000000C5010000000000003D0300003D0000000800170300000000000000000000000007000000FE435E0138A000000300000000000000030000000000000000000000ABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000018000000000000410000404000000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000006900000000000000180000000000000033000000000000004E00000000000000100018000000803F000000000000803FA81B5E0138A00000040000100018000000803F000000000000803F0F295E0138A00000040000100018000000803F000000000000803FB83E5E0138A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_173876EA]     ******/
CREATE STATISTICS [_WA_Sys_00000006_173876EA] ON [dbo].[DIC_Quoctich]([IsActive]) WITH STATS_STREAM = 0x01000000010000000000000000000000BC397B9400000000B80100000000000078010000000000006802B1F5680000000100010000000000000000002400000007000000FE435E0138A0000003000000000000000300000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F00004040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C0000000000000008000000000000001000110000004040000000000000803F01040000
GO
/****** Object:  Statistic [PK_Quoctich]     ******/
UPDATE STATISTICS [dbo].[DIC_Quoctich]([PK_Quoctich]) WITH STATS_STREAM = 0x01000000010000000000000000000000149B207900000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000C91E5E0138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 2, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000006_5AB9788F]     ******/
CREATE STATISTICS [_WA_Sys_00000006_5AB9788F] ON [dbo].[DIC_Tinhoc]([IsActive]) WITH STATS_STREAM = 0x01000000010000000000000000000000A83A2F9D00000000B8010000000000007801000000000000680213006800000001000100000000000000000001000000070000001E86F00044A0000002000000000000000200000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F00000040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C0000000000000008000000000000001000110000000040000000000000803F01040000
GO
/****** Object:  Statistic [PK_Tinhoc]     ******/
UPDATE STATISTICS [dbo].[DIC_Tinhoc]([PK_Tinhoc]) WITH STATS_STREAM = 0x01000000010000000000000000000000BA38D6F500000000BB010000000000007B01000000000000380300003800000004000A000000000000000000000000000700000074575E0138A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 2, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_57DD0BE4]     ******/
CREATE STATISTICS [_WA_Sys_00000002_57DD0BE4] ON [dbo].[DIC_Tongiao]([TenTG]) WITH STATS_STREAM = 0x01000000010000000000000000000000334E402200000000B2020000000000007202000000000000E7030000E7000000640000000000000008D00034000000000700000017D65E0138A000000300000000000000030000000000000000000000ABAAAA3E0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000300000001000000100000005555954100004040000000005555954100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000095000000000000000E01000000000000180000000000000041000000000000006A00000000000000300010000000803F000000000000803F0400000100290050006800AD1E7400200067006900E1006F00300010000000803F000000000000803F04000001002900740061007300640066006100730064006600300010000000803F000000000000803F04000001002B00540068006900EA006E00200043006800FA006100FF01000000000000000300000003000000280000002800000000000000000000001B00000050006800AD1E7400200067006900E1006F0074006100730064006600610073006400660068006900EA006E00200043006800FA0061000500000040000000008109000000400109000081080A0000010912000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_57DD0BE4]     ******/
CREATE STATISTICS [_WA_Sys_00000003_57DD0BE4] ON [dbo].[DIC_Tongiao]([GhiChu]) WITH STATS_STREAM = 0x01000000010000000000000000000000459569D8000000003202000000000000F201000000000000E7020000E7000000C80000000000000008D000347F0000000700000017D65E0138A0000003000000000000000300000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000010000000ABAAAA400000404000000000ABAAAA400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000004A000000000000008E00000000000000100000000000000023000000000000001000100000000040000000000000803F040000300010000000803F000000000000803F0400000100270061007300640066006100730064006600FF01000000000000000300000002000000280000002800000000000000000000000800000061007300640066006100730064006600020000004200000000010800000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_57DD0BE4]     ******/
CREATE STATISTICS [_WA_Sys_00000004_57DD0BE4] ON [dbo].[DIC_Tongiao]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000EC73CE5700000000C7010000000000008701000000000000240300002400000010000000000000000000000000000000070000001CD65E0138A0000003000000000000000300000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000404000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B0000000000000008000000000000001000200000004040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_57DD0BE4]     ******/
CREATE STATISTICS [_WA_Sys_00000005_57DD0BE4] ON [dbo].[DIC_Tongiao]([CreatedByDate]) WITH STATS_STREAM = 0x010000000100000000000000000000002C891A44000000000502000000000000C5010000000000003D0300003D00000008001703000000000000000000000000070000001CD65E0138A000000300000000000000030000000000000000000000ABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000018000000000000410000404000000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000006900000000000000180000000000000033000000000000004E00000000000000100018000000803F000000000000803F85B55E0138A00000040000100018000000803F000000000000803FD2C65E0138A00000040000100018000000803F000000000000803FABCF5E0138A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_57DD0BE4]     ******/
CREATE STATISTICS [_WA_Sys_00000006_57DD0BE4] ON [dbo].[DIC_Tongiao]([IsActive]) WITH STATS_STREAM = 0x01000000010000000000000000000000DA0CE47A00000000B80100000000000078010000000000006802B1F568000000010001000000000000000000240000000700000021D65E0138A0000003000000000000000300000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F00004040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C0000000000000008000000000000001000110000004040000000000000803F01040000
GO
/****** Object:  Statistic [PK_Tongiao]     ******/
UPDATE STATISTICS [dbo].[DIC_Tongiao]([PK_Tongiao]) WITH STATS_STREAM = 0x01000000010000000000000000000000FF831D0100000000DA010000000000009A01000000000000380300003800000004000A0000000000000000000000000007000000C7D25E0138A00000030000000000000003000000000000000000803FABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000014000000000080400000404000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003E0000000000000010000000000000002700000000000000100014000000803F000000000000803F01000000040000100014000000803F0000803F0000803F03000000040000, ROWCOUNT = 3, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_4C8B54C9]     ******/
CREATE STATISTICS [_WA_Sys_00000002_4C8B54C9] ON [dbo].[PB_ChamcongNhanvien]([MaNV]) WITH STATS_STREAM = 0x01000000010000000000000000000000E13337BC00000000A9020000000000006902000000000000A7030000A70000000A0000000000000008D000340000000007000000A13954014BA00000060000000000000006000000000000000000803FABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000010000000000020410000C0400000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000A40000000000000005010000000000002000000000000000410000000000000062000000000000008300000000000000300010000000803F000000000000803F040000010021004E563030303030303031300010000000803F0000803F0000803F040000010021004E563030303030303033300010000000803F0000803F0000803F040000010021004E563030303030303035300010000000803F000000000000803F040000010021004E563030303030303036FF01000000000000000600000006000000280000002800000000000000000000000F0000004E56303030303030303132333435360800000040000000004009000000810109000081010A000081010B000081010C000081010D000001010E000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_4C8B54C9]     ******/
CREATE STATISTICS [_WA_Sys_00000003_4C8B54C9] ON [dbo].[PB_ChamcongNhanvien]([Sogiocong]) WITH STATS_STREAM = 0x01000000010000000000000000000000DBEEE25D00000000BB010000000000007B01000000000000380300003800000004000A00000000000000000001000000070000006E62A0004CA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_4C8B54C9]     ******/
CREATE STATISTICS [_WA_Sys_00000004_4C8B54C9] ON [dbo].[PB_ChamcongNhanvien]([Sogionghiphep]) WITH STATS_STREAM = 0x01000000010000000000000000000000EFE497E000000000BB010000000000007B01000000000000380300003800000004000A00000000000000000001000000070000007C62A0004CA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_4C8B54C9]     ******/
CREATE STATISTICS [_WA_Sys_00000005_4C8B54C9] ON [dbo].[PB_ChamcongNhanvien]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000073557EF00000000C7010000000000008701000000000000240300002400000010000000000000000000000006000000070000007C62A0004CA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000C04000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000C040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_4C8B54C9]     ******/
CREATE STATISTICS [_WA_Sys_00000006_4C8B54C9] ON [dbo].[PB_ChamcongNhanvien]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000930CD6C100000000BF010000000000007F010000000000003D0300003D00000008001703000000000000000024000000070000007C62A0004CA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000C040000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000C040000000000000803F80D90A014BA00000040000
GO
/****** Object:  Statistic [PK_Chamcong_1]     ******/
UPDATE STATISTICS [dbo].[PB_ChamcongNhanvien]([PK_Chamcong_1]) WITH STATS_STREAM = 0x010000000200000000000000000000002BF7B28400000000DF0100000000000087010000000000002403C0402400000010000000000000000000000000000000A7030000A70000000A0000000000000008D000340000000007000000983954014BA0000006000000000000000600000000000000000000000000803FABAA2A3E00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000002000000200000000000D0410000C04000000000000080410000204100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000C040000000000000803FE59B35AE3987394F966D1DC0B2730BE8040000, ROWCOUNT = 55, PAGECOUNT = 1
GO
/****** Object:  Statistic [PK_PB_Chamnghiphep]     ******/
UPDATE STATISTICS [dbo].[PB_Chamnghiphep]([PK_PB_Chamnghiphep]) WITH STATS_STREAM = 0x01000000010000000000000000000000DD3305160000000040000000000000000000000000000000A7030000A70000000A0000000000000008D0003400000000, ROWCOUNT = 0, PAGECOUNT = 0
GO
/****** Object:  Statistic [_WA_Sys_00000002_515009E6]     ******/
CREATE STATISTICS [_WA_Sys_00000002_515009E6] ON [dbo].[PB_Chamtangca]([MaNV]) WITH STATS_STREAM = 0x0100000001000000000000000000000011D551E200000000A9020000000000006902000000000000A7030000A70000000A0000000000000008D0003400000000070000001EF6AA004CA00000060000000000000006000000000000000000803FABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000010000000000020410000C0400000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000A40000000000000005010000000000002000000000000000410000000000000062000000000000008300000000000000300010000000803F000000000000803F040000010021004E563030303030303031300010000000803F0000803F0000803F040000010021004E563030303030303033300010000000803F0000803F0000803F040000010021004E563030303030303035300010000000803F000000000000803F040000010021004E563030303030303036FF01000000000000000600000006000000280000002800000000000000000000000F0000004E56303030303030303132333435360800000040000000004009000000810109000081010A000081010B000081010C000081010D000001010E000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_515009E6]     ******/
CREATE STATISTICS [_WA_Sys_00000003_515009E6] ON [dbo].[PB_Chamtangca]([TCthuong]) WITH STATS_STREAM = 0x01000000010000000000000000000000802644A200000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000010000000700000075B4B0004CA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_515009E6]     ******/
CREATE STATISTICS [_WA_Sys_00000004_515009E6] ON [dbo].[PB_Chamtangca]([TCchunhat]) WITH STATS_STREAM = 0x01000000010000000000000000000000E3FB779900000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000010000000700000079B4B0004CA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_515009E6]     ******/
CREATE STATISTICS [_WA_Sys_00000005_515009E6] ON [dbo].[PB_Chamtangca]([TCnghile]) WITH STATS_STREAM = 0x01000000010000000000000000000000E3FB779900000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000010000000700000079B4B0004CA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_515009E6]     ******/
CREATE STATISTICS [_WA_Sys_00000006_515009E6] ON [dbo].[PB_Chamtangca]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000E68C19E100000000C70100000000000087010000000000002403000024000000100000000000000000000000060000000700000079B4B0004CA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000C04000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000C040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_515009E6]     ******/
CREATE STATISTICS [_WA_Sys_00000007_515009E6] ON [dbo].[PB_Chamtangca]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000D032D11D00000000BF010000000000007F010000000000003D0300003D000000080017030000000000000000240000000700000079B4B0004CA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000C040000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000C040000000000000803F80D90A014BA00000040000
GO
/****** Object:  Statistic [PK_Chamtangca_1]     ******/
UPDATE STATISTICS [dbo].[PB_Chamtangca]([PK_Chamtangca_1]) WITH STATS_STREAM = 0x01000000020000000000000000000000411DE8C900000000DF0100000000000087010000000000002403C0402400000010000000000000000000000000000000A7030000A70000000A0000000000000008D0003400000000070000001EF6AA004CA0000006000000000000000600000000000000000000000000803FABAA2A3E00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000002000000200000000000D0410000C04000000000000080410000204100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000C040000000000000803FE59B35AE3987394F966D1DC0B2730BE8040000, ROWCOUNT = 55, PAGECOUNT = 1
GO
/****** Object:  Statistic [PK_PB_Danhgianhanvien]     ******/
UPDATE STATISTICS [dbo].[PB_Danhgianhanvien]([PK_PB_Danhgianhanvien]) WITH STATS_STREAM = 0x010000000100000000000000000000007DE0E9F90000000040000000000000000000000000000000240300002400000010000000000000000000000000000000, ROWCOUNT = 0, PAGECOUNT = 0
GO
/****** Object:  Statistic [_WA_Sys_00000002_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000002_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Thang]) WITH STATS_STREAM = 0x010000000100000000000000000000001AD5274600000000BB010000000000007B010000000000003803B1F53800000004000A0000000000000000000100000007000000CB7447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F04000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000003_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Nam]) WITH STATS_STREAM = 0x010000000100000000000000000000003F9BF31A00000000BB010000000000007B010000000000003803B1F53800000004000A0000000000000000000100000007000000240D46014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803FDC070000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000004_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Nguoiky]) WITH STATS_STREAM = 0x01000000010000000000000000000000EA4DC31000000000CB010000000000008B01000000000000E7020000E7000000500000000000000008D000340100000007000000D57447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000010000000000000000000803F0000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000002F00000000000000FF01000000010000000100000001000000280000002800000000000000000000000000000001000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000005_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Chucvunguoiky]) WITH STATS_STREAM = 0x010000000100000000000000000000004C4DC43600000000CB010000000000008B01000000000000E7020000E7000000640000000000000008D000340100000007000000DE7447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000010000000000000000000803F0000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000002F00000000000000FF01000000010000000100000001000000280000002800000000000000000000000000000001000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000006_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Ngayky]) WITH STATS_STREAM = 0x0100000001000000000000000000000096B49E3800000000940100000000000054010000000000003D02B1F53D0000000800170300000000000000000100000007000000DE7447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000018000000000000000000803F0000803F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_00000007_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000007_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Luongtoithieu]) WITH STATS_STREAM = 0x01000000010000000000000000000000AACE24FC00000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000DE7447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F200B2000040000
GO
/****** Object:  Statistic [_WA_Sys_00000008_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000008_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Tongsogioquydinh]) WITH STATS_STREAM = 0x010000000100000000000000000000000898629C00000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000F17447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803FD0000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000009_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000009_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Tienbatdautinhthue]) WITH STATS_STREAM = 0x01000000010000000000000000000000D3A1368B00000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000F17447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F404B4C00040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_0000000A_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Tienmoinguoiphuthuoc]) WITH STATS_STREAM = 0x0100000001000000000000000000000008F4B53000000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000FF7447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F804F1200040000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_0000000B_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Hesothuong]) WITH STATS_STREAM = 0x0100000001000000000000000000000054B955DC00000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000000000007000000FF7447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000000000F83F040000
GO
/****** Object:  Statistic [_WA_Sys_0000000C_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_0000000C_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Hesochunhat]) WITH STATS_STREAM = 0x0100000001000000000000000000000002124D9700000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000000000007000000FF7447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F0000000000000040040000
GO
/****** Object:  Statistic [_WA_Sys_0000000D_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_0000000D_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Hesonghile]) WITH STATS_STREAM = 0x01000000010000000000000000000000C3593DA700000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000000000007000000FF7447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F0000000000000840040000
GO
/****** Object:  Statistic [_WA_Sys_0000000E_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_0000000E_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([BHXH]) WITH STATS_STREAM = 0x0100000001000000000000000000000054B955DC00000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000000000007000000FF7447014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000000000F83F040000
GO
/****** Object:  Statistic [_WA_Sys_0000000F_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_0000000F_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([BHYT]) WITH STATS_STREAM = 0x0100000001000000000000000000000051B83EE200000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000000000007000000047547014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F333333333333F33F040000
GO
/****** Object:  Statistic [_WA_Sys_00000010_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000010_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([BHTN]) WITH STATS_STREAM = 0x01000000010000000000000000000000BBF39F8D00000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000000000007000000047547014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F9A9999999999F93F040000
GO
/****** Object:  Statistic [_WA_Sys_00000011_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000011_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([BHXHMAX]) WITH STATS_STREAM = 0x010000000100000000000000000000008A5200DC00000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000047547014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F00E1F505040000
GO
/****** Object:  Statistic [_WA_Sys_00000012_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000012_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([Phicongdoan]) WITH STATS_STREAM = 0x0100000001000000000000000000000031770ABA00000000BF010000000000007F010000000000003E0300003E00000008003500000000000000000000000000070000000D7547014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000000000E03F040000
GO
/****** Object:  Statistic [_WA_Sys_00000013_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000013_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([PhicongdoanMax]) WITH STATS_STREAM = 0x0100000001000000000000000000000092547A8500000000BB010000000000007B01000000000000380300003800000004000A00000000000000000000000000070000000D7547014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803FE0930400040000
GO
/****** Object:  Statistic [_WA_Sys_00000014_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000014_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([IsLock]) WITH STATS_STREAM = 0x0100000001000000000000000000000017D5450C00000000B801000000000000780100000000000068030000680000000100010000000000000000000000000007000000127547014DA0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F00040000
GO
/****** Object:  Statistic [_WA_Sys_00000015_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000015_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([IsFinish]) WITH STATS_STREAM = 0x01000000010000000000000000000000A8B5DF7700000000B801000000000000780100000000000068030000680000000100010000000000000000000000000007000000CB7447014DA0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F00040000
GO
/****** Object:  Statistic [_WA_Sys_00000016_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000016_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000B85275AD00000000C701000000000000870100000000000024030000240000001000000000000000000000000100000007000000127547014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000017_058EC7FB]     ******/
CREATE STATISTICS [_WA_Sys_00000017_058EC7FB] ON [dbo].[PB_Danhsachbangluong]([CreatedByDate]) WITH STATS_STREAM = 0x0100000001000000000000000000000075A5181700000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000002400000007000000127547014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F038145014DA00000040000
GO
/****** Object:  Statistic [PK_PB_Danhsachbangluong]     ******/
UPDATE STATISTICS [dbo].[PB_Danhsachbangluong]([PK_PB_Danhsachbangluong]) WITH STATS_STREAM = 0x0100000001000000000000000000000043136BC200000000C701000000000000870100000000000024030000240000001000000000000000000000000000000007000000435246014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803F59343EB632BC9F41964E48FE449D24C5040000, ROWCOUNT = 1, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_5CC1BC92]     ******/
CREATE STATISTICS [_WA_Sys_00000002_5CC1BC92] ON [dbo].[PB_Danhsachchamcong]([Thang]) WITH STATS_STREAM = 0x010000000100000000000000000000001D89C04400000000BB010000000000007B01000000000000380300003800000004000A000000000000000000000000000700000033D30C014BA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F04000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_5CC1BC92]     ******/
CREATE STATISTICS [_WA_Sys_00000003_5CC1BC92] ON [dbo].[PB_Danhsachchamcong]([Nam]) WITH STATS_STREAM = 0x01000000010000000000000000000000381607D200000000BB010000000000007B01000000000000380300003800000004000A00000000000000000000000000070000002ED30C014BA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803FDC070000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_5CC1BC92]     ******/
CREATE STATISTICS [_WA_Sys_00000004_5CC1BC92] ON [dbo].[PB_Danhsachchamcong]([Nguoiky]) WITH STATS_STREAM = 0x010000000100000000000000000000007292102800000000CB010000000000008B01000000000000E7020000E7000000500000000000000008D00034010000000700000054D30C014BA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000010000000000000000000803F0000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000002F00000000000000FF01000000010000000100000001000000280000002800000000000000000000000000000001000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_5CC1BC92]     ******/
CREATE STATISTICS [_WA_Sys_00000005_5CC1BC92] ON [dbo].[PB_Danhsachchamcong]([Chucvunguoiky]) WITH STATS_STREAM = 0x010000000100000000000000000000000CFC15E700000000CB010000000000008B01000000000000E7020000E7000000640000000000000008D0003401000000070000005DD30C014BA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000010000000000000000000803F0000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000002F00000000000000FF01000000010000000100000001000000280000002800000000000000000000000000000001000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_5CC1BC92]     ******/
CREATE STATISTICS [_WA_Sys_00000006_5CC1BC92] ON [dbo].[PB_Danhsachchamcong]([Ngayky]) WITH STATS_STREAM = 0x0100000001000000000000000000000094ED652500000000940100000000000054010000000000003D02B1F53D00000008001703000000000000000001000000070000005DD30C014BA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000018000000000000000000803F0000803F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_00000007_5CC1BC92]     ******/
CREATE STATISTICS [_WA_Sys_00000007_5CC1BC92] ON [dbo].[PB_Danhsachchamcong]([IsLock]) WITH STATS_STREAM = 0x010000000100000000000000000000008BAC24CD00000000B80100000000000078010000000000006803000068000000010001000000000000000000000000000700000062D30C014BA0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F00040000
GO
/****** Object:  Statistic [_WA_Sys_00000008_5CC1BC92]     ******/
CREATE STATISTICS [_WA_Sys_00000008_5CC1BC92] ON [dbo].[PB_Danhsachchamcong]([IsFinish]) WITH STATS_STREAM = 0x01000000010000000000000000000000DD8E4AC900000000B80100000000000078010000000000006803000068000000010001000000000000000000000000000700000067D30C014BA0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F00040000
GO
/****** Object:  Statistic [_WA_Sys_00000009_5CC1BC92]     ******/
CREATE STATISTICS [_WA_Sys_00000009_5CC1BC92] ON [dbo].[PB_Danhsachchamcong]([CreatedByUser]) WITH STATS_STREAM = 0x010000000100000000000000000000002D2E42C900000000C70100000000000087010000000000002403000024000000100000000000000000000000010000000700000067D30C014BA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_5CC1BC92]     ******/
CREATE STATISTICS [_WA_Sys_0000000A_5CC1BC92] ON [dbo].[PB_Danhsachchamcong]([CreatedByDate]) WITH STATS_STREAM = 0x010000000100000000000000000000005FDE27B000000000BF010000000000007F010000000000003D0382DD3D000000080017030000000000000000000000000700000070D30C014BA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F80D90A014BA00000040000
GO
/****** Object:  Statistic [PK_PB_Danhsachchamcong]     ******/
UPDATE STATISTICS [dbo].[PB_Danhsachchamcong]([PK_PB_Danhsachchamcong]) WITH STATS_STREAM = 0x0100000001000000000000000000000099A9418600000000C7010000000000008701000000000000240300002400000010000000000000000000000000000000070000000FE60A014BA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FE59B35AE3987394F966D1DC0B2730BE8040000, ROWCOUNT = 8, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_7775B2CE]     ******/
CREATE STATISTICS [_WA_Sys_00000002_7775B2CE] ON [dbo].[PB_Dicongtac]([MaNV]) WITH STATS_STREAM = 0x0100000001000000000000000000000071687628000000000B02000000000000CB01000000000000A7030000A70000000A0000000000000008D0003400000000070000005832B5004AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000020410000803F0000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303034FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303034020000004000000000010A00000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_7775B2CE]     ******/
CREATE STATISTICS [_WA_Sys_00000006_7775B2CE] ON [dbo].[PB_Dicongtac]([Tungay]) WITH STATS_STREAM = 0x01000000010000000000000000000000744B286D00000000BF010000000000007F010000000000003D03B1F53D00000008001703000000000000000000000000070000005832B5004AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000004AA00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_7775B2CE]     ******/
CREATE STATISTICS [_WA_Sys_00000007_7775B2CE] ON [dbo].[PB_Dicongtac]([Denngay]) WITH STATS_STREAM = 0x010000000100000000000000000000004E7EF80E00000000BF010000000000007F010000000000003D03B1F53D00000008001703000000000000000000000000070000005832B5004AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000004CA00000040000
GO
/****** Object:  Statistic [PK_PB_Dicongtac]     ******/
UPDATE STATISTICS [dbo].[PB_Dicongtac]([PK_PB_Dicongtac]) WITH STATS_STREAM = 0x01000000010000000000000000000000115EE12600000000BB010000000000007B01000000000000380300003800000004000A00000000000000000000000000070000005EEDBE004AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 3, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_39788055]     ******/
CREATE STATISTICS [_WA_Sys_00000002_39788055] ON [dbo].[PB_KhautruNhanvien]([MaNV]) WITH STATS_STREAM = 0x01000000010000000000000000000000694D76A8000000000B02000000000000CB01000000000000A7030000A70000000A0000000000000008D000340000000007000000770C7F014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000020410000803F0000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303031FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303031020000004000000000010A00000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_39788055]     ******/
CREATE STATISTICS [_WA_Sys_00000003_39788055] ON [dbo].[PB_KhautruNhanvien]([Makhautru]) WITH STATS_STREAM = 0x010000000100000000000000000000006A59F4E400000000BB010000000000007B010000000000003803B1F53800000004000A0000000000000000000100000007000000735A9C004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_39788055]     ******/
CREATE STATISTICS [_WA_Sys_00000004_39788055] ON [dbo].[PB_KhautruNhanvien]([Tenkhautru]) WITH STATS_STREAM = 0x01000000010000000000000000000000B58D8848000000001702000000000000D701000000000000E7030000E7000000640000000000000008D000340000000007000000735A9C004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000002F0000000000000073000000000000000800000000000000300010000000803F000000000000803F0400000100270054006900C11E6E0020006200A11E6300FF01000000000000000100000001000000280000002800000000000000000000000800000054006900C11E6E0020006200A11E6300020000004000000000010800000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_39788055]     ******/
CREATE STATISTICS [_WA_Sys_00000005_39788055] ON [dbo].[PB_KhautruNhanvien]([Sotien]) WITH STATS_STREAM = 0x010000000100000000000000000000008A00784000000000BB010000000000007B01000000000000380313003800000004000A0000000000000000000100000007000000735A9C004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F60E31600040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_39788055]     ******/
CREATE STATISTICS [_WA_Sys_00000006_39788055] ON [dbo].[PB_KhautruNhanvien]([CreatedByUser]) WITH STATS_STREAM = 0x0100000001000000000000000000000041BAA59500000000C701000000000000870100000000000024030000240000001000000000000000000000000100000007000000735A9C004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_39788055]     ******/
CREATE STATISTICS [_WA_Sys_00000007_39788055] ON [dbo].[PB_KhautruNhanvien]([CreatedByDate]) WITH STATS_STREAM = 0x0100000001000000000000000000000063DFE5DC00000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000002400000007000000735A9C004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803FD9067F014DA00000040000
GO
/****** Object:  Statistic [PK_PB_KhautruNhanvien]     ******/
UPDATE STATISTICS [dbo].[PB_KhautruNhanvien]([PK_PB_KhautruNhanvien]) WITH STATS_STREAM = 0x01000000030000000000000000000000C084446500000000F70100000000000087010000000000002403000024000000100000000000000000000000B7C62D32A7036100A70000000A0000000000000008D00034D001A007380300003800000004000A0000000000000000006100670007000000770C7F014DA0000001000000000000000100000000000000000000000000803F0000803F0000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000003000000200000000000F0410000803F00000000000080410000204100008040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FB80BB6F085EA7F40A86DDD6032728B8B040000, ROWCOUNT = 0, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_40257DE4]     ******/
CREATE STATISTICS [_WA_Sys_00000002_40257DE4] ON [dbo].[PB_KhenthuongNhanvien]([MaNV]) WITH STATS_STREAM = 0x01000000010000000000000000000000EC77C2ED000000000B02000000000000CB01000000000000A703B1F5A70000000A0000000000000008D00034A700000007000000CD91F0004AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000020410000803F0000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303031FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303031020000004000000000010A00000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_40257DE4]     ******/
CREATE STATISTICS [_WA_Sys_00000003_40257DE4] ON [dbo].[PB_KhenthuongNhanvien]([Ngaykhenthuong]) WITH STATS_STREAM = 0x010000000100000000000000000000003CD7AF3300000000BF010000000000007F010000000000003D03B1F53D0000000800170300000000000000000000000007000000CD91F0004AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000004AA00000040000
GO
/****** Object:  Statistic [PK_PB_KhenthuongNhanvien]     ******/
UPDATE STATISTICS [dbo].[PB_KhenthuongNhanvien]([PK_PB_KhenthuongNhanvien]) WITH STATS_STREAM = 0x01000000010000000000000000000000A76C3C0800000000C7010000000000008701000000000000240300002400000010000000000000000000000000000000070000009DD1F0004AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803F70D4937679B54D479E2D717E207C70AA040000, ROWCOUNT = 1, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_66D536B1]     ******/
CREATE STATISTICS [_WA_Sys_00000002_66D536B1] ON [dbo].[PB_KyluatNhanvien]([MaNV]) WITH STATS_STREAM = 0x01000000010000000000000000000000457CB637000000000B02000000000000CB01000000000000A7030000A70000000A0000000000000008D000340100000007000000E079AD005AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000020410000803F0000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303035FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303035020000004000000000010A00000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_66D536B1]     ******/
CREATE STATISTICS [_WA_Sys_00000005_66D536B1] ON [dbo].[PB_KyluatNhanvien]([Ngaykyluat]) WITH STATS_STREAM = 0x0100000001000000000000000000000063CFAA5400000000BF010000000000007F010000000000003D03B1F53D0000000800170300000000000000007F00000007000000E079AD005AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000005AA00000040000
GO
/****** Object:  Statistic [PK_PB_KyluatNhanvien]     ******/
UPDATE STATISTICS [dbo].[PB_KyluatNhanvien]([PK_PB_KyluatNhanvien]) WITH STATS_STREAM = 0x010000000100000000000000000000007CBDCF7200000000C7010000000000008701000000000000240300002400000010000000000000000000000000000000070000004D80AD005AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803F57BAC92121CCA147BD2534859843BDAB040000, ROWCOUNT = 1, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_75F77EB0]     ******/
CREATE STATISTICS [_WA_Sys_00000002_75F77EB0] ON [dbo].[PB_Luonglamthem]([MaNV]) WITH STATS_STREAM = 0x010000000100000000000000000000003116BBDB000000000B02000000000000CB01000000000000A703B1F5A70000000A0000000000000008D000340000000007000000E7D87E014DA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000020410000803F0000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303031FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303031020000004000000000010A00000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_75F77EB0]     ******/
CREATE STATISTICS [_WA_Sys_00000003_75F77EB0] ON [dbo].[PB_Luonglamthem]([Maluonglamthem]) WITH STATS_STREAM = 0x0100000001000000000000000000000043BC968800000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000000000000700000050499C004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_75F77EB0]     ******/
CREATE STATISTICS [_WA_Sys_00000004_75F77EB0] ON [dbo].[PB_Luonglamthem]([Tenluonglamthem]) WITH STATS_STREAM = 0x010000000100000000000000000000004B03129F000000001302000000000000D301000000000000E7030000E7000000FE0100000000000008D00034000000000700000055499C004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000060410000803F00000000000060410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000002D000000000000006F000000000000000800000000000000300010000000803F000000000000803F0400000100250010016900200063006800A1016900FF01000000000000000100000001000000280000002800000000000000000000000700000010016900200063006800A1016900020000004000000000010700000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_75F77EB0]     ******/
CREATE STATISTICS [_WA_Sys_00000005_75F77EB0] ON [dbo].[PB_Luonglamthem]([Sotien]) WITH STATS_STREAM = 0x0100000001000000000000000000000064C72E7400000000BB010000000000007B01000000000000380313003800000004000A000000000000000000010000000700000055499C004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F60E31600040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_75F77EB0]     ******/
CREATE STATISTICS [_WA_Sys_00000006_75F77EB0] ON [dbo].[PB_Luonglamthem]([CreatedByUser]) WITH STATS_STREAM = 0x010000000100000000000000000000009534447B00000000C70100000000000087010000000000002403000024000000100000000000000000000000010000000700000055499C004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_75F77EB0]     ******/
CREATE STATISTICS [_WA_Sys_00000007_75F77EB0] ON [dbo].[PB_Luonglamthem]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000EECA394C00000000BF010000000000007F010000000000003D0300003D000000080017030000000000000000240000000700000055499C004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F200A7E014DA00000040000
GO
/****** Object:  Statistic [PK_PB_Luonglamthem]     ******/
UPDATE STATISTICS [dbo].[PB_Luonglamthem]([PK_PB_Luonglamthem]) WITH STATS_STREAM = 0x01000000030000000000000000000000635AAA2F00000000F70100000000000087010000000000002403000024000000100000000000000000000000B7C62D32A7036100A70000000A0000000000000008D00034D001B007380300003800000004000A0000000000000000006100670007000000E7D87E014DA0000001000000000000000100000000000000000000000000803F0000803F0000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000003000000200000000000F0410000803F00000000000080410000204100008040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FB80BB6F085EA7F40A86DDD6032728B8B040000, ROWCOUNT = 0, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_6A1BB7B0]     ******/
CREATE STATISTICS [_WA_Sys_00000002_6A1BB7B0] ON [dbo].[PB_Luongtangca]([MaNV]) WITH STATS_STREAM = 0x01000000010000000000000000000000399A405700000000A9020000000000006902000000000000A7030000A70000000A0000000000000008D000340000000007000000DF409C004EA00000060000000000000006000000000000000000803FABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000010000000000020410000C0400000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000A40000000000000005010000000000002000000000000000410000000000000062000000000000008300000000000000300010000000803F000000000000803F040000010021004E563030303030303031300010000000803F0000803F0000803F040000010021004E563030303030303033300010000000803F0000803F0000803F040000010021004E563030303030303035300010000000803F000000000000803F040000010021004E563030303030303036FF01000000000000000600000006000000280000002800000000000000000000000F0000004E56303030303030303132333435360800000040000000004009000000810109000081010A000081010B000081010C000081010D000001010E000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_6A1BB7B0]     ******/
CREATE STATISTICS [_WA_Sys_00000003_6A1BB7B0] ON [dbo].[PB_Luongtangca]([LuongGio]) WITH STATS_STREAM = 0x01000000010000000000000000000000C5DD5B3F000000003702000000000000F701000000000000380300003800000004000A0000000000000000000000000007000000E4409C004EA00000060000000000000006000000000000000000803FABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000050000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000009B0000000000000028000000000000003F0000000000000056000000000000006D000000000000008400000000000000100014000000803F000000000000803F532F0000040000100014000000803F000000000000803F283B0000040000100014000000803F000000000000803FF23B0000040000100014000000803F000000000000803F4F3E0000040000100014000000803F0000803F0000803FFD460000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_6A1BB7B0]     ******/
CREATE STATISTICS [_WA_Sys_00000004_6A1BB7B0] ON [dbo].[PB_Luongtangca]([Sotangcathuong]) WITH STATS_STREAM = 0x01000000010000000000000000000000AA7C72FA00000000DA010000000000009A01000000000000380313003800000004000A0000000000000000000100000007000000E4409C004EA0000006000000000000000600000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003E0000000000000010000000000000002700000000000000100014000000803F000000000000803F2D000000040000100014000000A040000000000000803F32000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_6A1BB7B0]     ******/
CREATE STATISTICS [_WA_Sys_00000005_6A1BB7B0] ON [dbo].[PB_Luongtangca]([Sotangcachunhat]) WITH STATS_STREAM = 0x01000000010000000000000000000000A3260E5700000000DA010000000000009A01000000000000380313003800000004000A0000000000000000000100000007000000E4409C004EA0000006000000000000000600000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003E0000000000000010000000000000002700000000000000100014000000803F000000000000803F07000000040000100014000000A040000000000000803F08000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_6A1BB7B0]     ******/
CREATE STATISTICS [_WA_Sys_00000006_6A1BB7B0] ON [dbo].[PB_Luongtangca]([Sotangcale]) WITH STATS_STREAM = 0x01000000010000000000000000000000BD53A98000000000DA010000000000009A01000000000000380313003800000004000A0000000000000000000100000007000000E4409C004EA0000006000000000000000600000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003E0000000000000010000000000000002700000000000000100014000000A040000000000000803F08000000040000100014000000803F000000000000803F09000000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_6A1BB7B0]     ******/
CREATE STATISTICS [_WA_Sys_0000000A_6A1BB7B0] ON [dbo].[PB_Luongtangca]([CreatedByUser]) WITH STATS_STREAM = 0x010000000100000000000000000000001BB6EFE400000000C701000000000000870100000000000024030000240000001000000000000000000000003800000007000000E4409C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000C04000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000C040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_6A1BB7B0]     ******/
CREATE STATISTICS [_WA_Sys_0000000B_6A1BB7B0] ON [dbo].[PB_Luongtangca]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000CB6BAB9900000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000002400000007000000E4409C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000C040000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000C040000000000000803F36D759014DA00000040000
GO
/****** Object:  Statistic [PK_PB_Luongtangca]     ******/
UPDATE STATISTICS [dbo].[PB_Luongtangca]([PK_PB_Luongtangca]) WITH STATS_STREAM = 0x01000000020000000000000000000000477E823B00000000DF0100000000000087010000000000002403C0402400000010000000000000000000000000000000A7030000A70000000A0000000000000008D000340000000007000000B7335B014DA0000006000000000000000600000000000000000000000000803FABAA2A3E00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000002000000200000000000D0410000C04000000000000080410000204100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000C040000000000000803FB80BB6F085EA7F40A86DDD6032728B8B040000, ROWCOUNT = 6, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_284DF453]     ******/
CREATE STATISTICS [_WA_Sys_00000002_284DF453] ON [dbo].[PB_Luongtoithieu]([Ngayapdung]) WITH STATS_STREAM = 0x01000000010000000000000000000000B608C0A400000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000000000000007000000C1D4330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F1421280049A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_284DF453]     ******/
CREATE STATISTICS [_WA_Sys_00000003_284DF453] ON [dbo].[PB_Luongtoithieu]([IsCurrent]) WITH STATS_STREAM = 0x01000000010000000000000000000000D70B5DC500000000B8010000000000007801000000000000680300006800000001000100000000000000000000000000070000008C3A280049A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_284DF453]     ******/
CREATE STATISTICS [_WA_Sys_00000004_284DF453] ON [dbo].[PB_Luongtoithieu]([Sotien]) WITH STATS_STREAM = 0x010000000100000000000000000000002AB4B56100000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000C1D4330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F80841E00040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_284DF453]     ******/
CREATE STATISTICS [_WA_Sys_00000005_284DF453] ON [dbo].[PB_Luongtoithieu]([Nguoiky]) WITH STATS_STREAM = 0x0100000001000000000000000000000082CBD2DE000000003B02000000000000FB01000000000000E7030000E7000000500000000000000008D000340000000007000000C1D4330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000008420000803F0000000000000842000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000410000000000000097000000000000000800000000000000300010000000803F000000000000803F040000010039004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300FF0100000000000000010000000100000028000000280000000000000000000000110000004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300020000004000000000011100000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_284DF453]     ******/
CREATE STATISTICS [_WA_Sys_00000006_284DF453] ON [dbo].[PB_Luongtoithieu]([Chucvunguoiky]) WITH STATS_STREAM = 0x010000000100000000000000000000003371F3A5000000002B02000000000000EB01000000000000E7030000E7000000640000000000000008D00034E700000007000000C1D4330049A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000D0410000803F000000000000D041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000390000000000000087000000000000000800000000000000300010000000803F000000000000803F040000010031005400D51E6E006700200067006900E1006D0020001101D11E6300FF01000000000000000100000001000000280000002800000000000000000000000D0000005400D51E6E006700200067006900E1006D0020001101D11E6300020000004000000000010D00000000
GO
/****** Object:  Statistic [_WA_Sys_00000007_284DF453]     ******/
CREATE STATISTICS [_WA_Sys_00000007_284DF453] ON [dbo].[PB_Luongtoithieu]([Ngayky]) WITH STATS_STREAM = 0x010000000100000000000000000000005AC617AC00000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000000000000007000000C6D4330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F0000000049A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000008_284DF453]     ******/
CREATE STATISTICS [_WA_Sys_00000008_284DF453] ON [dbo].[PB_Luongtoithieu]([Mota]) WITH STATS_STREAM = 0x010000000100000000000000000000004F9E3474000000009F020000000000005F02000000000000E7030000E7000000E80300000000000008D000340000000007000000C6D4330049A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000A8420000803F000000000000A8420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000007300000000000000FB000000000000000800000000000000300010000000803F000000000000803F04000001006B004C00B001DD1E6900200076006900BF1E7400200071007500E10020006100680021000D000A004E006700B001DD1E6900200073006100750020007600E0006F00200076006900BF1E740020006E00680061002100FF01000000000000000100000001000000280000002800000000000000000000002A0000004C00B001DD1E6900200076006900BF1E7400200071007500E10020006100680021000D000A004E006700B001DD1E6900200073006100750020007600E0006F00200076006900BF1E740020006E00680061002100020000004000000000012A00000000
GO
/****** Object:  Statistic [_WA_Sys_00000009_284DF453]     ******/
CREATE STATISTICS [_WA_Sys_00000009_284DF453] ON [dbo].[PB_Luongtoithieu]([GhiChu]) WITH STATS_STREAM = 0x0100000001000000000000000000000059BE39BA00000000CB010000000000008B01000000000000E7020000E7000000C80000000000000008D000340100000007000000C6D4330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000010000000000000000000803F0000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000002F00000000000000FF01000000010000000100000001000000280000002800000000000000000000000000000001000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_284DF453]     ******/
CREATE STATISTICS [_WA_Sys_0000000A_284DF453] ON [dbo].[PB_Luongtoithieu]([CreatedByUser]) WITH STATS_STREAM = 0x010000000100000000000000000000000B2F8F2500000000C701000000000000870100000000000024030000240000001000000000000000000000000100000007000000C6D4330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_284DF453]     ******/
CREATE STATISTICS [_WA_Sys_0000000B_284DF453] ON [dbo].[PB_Luongtoithieu]([CreatedByDate]) WITH STATS_STREAM = 0x010000000100000000000000000000000857B4F100000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000002400000007000000C6D4330049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803FD237280049A00000040000
GO
/****** Object:  Statistic [PK_Luongtoithieu]     ******/
UPDATE STATISTICS [dbo].[PB_Luongtoithieu]([PK_Luongtoithieu]) WITH STATS_STREAM = 0x010000000100000000000000000000002AD6725600000000C701000000000000870100000000000024030000240000001000000000000000000000000000000007000000D637280049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803F00000000000000000000000000000000040000, ROWCOUNT = 1, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_324172E1]     ******/
CREATE STATISTICS [_WA_Sys_00000002_324172E1] ON [dbo].[PB_Nguoithannhanvien]([MaNV]) WITH STATS_STREAM = 0x0100000001000000000000000000000077C353B4000000000B02000000000000CB01000000000000A7030000A70000000A0000000000000008D0003424000000070000006CD0F90049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000020410000803F0000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303031FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303031020000004000000000010A00000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_324172E1]     ******/
CREATE STATISTICS [_WA_Sys_00000004_324172E1] ON [dbo].[PB_Nguoithannhanvien]([Quanhe]) WITH STATS_STREAM = 0x01000000010000000000000000000000D795476C00000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000010000000700000075D0F90049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F03000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000008_324172E1]     ******/
CREATE STATISTICS [_WA_Sys_00000008_324172E1] ON [dbo].[PB_Nguoithannhanvien]([Phuthuoc]) WITH STATS_STREAM = 0x010000000100000000000000000000009E9D7F5800000000D401000000000000940100000000000068030000680000000100010000000000000000000000000007000000A07883014AA0000004000000000000000400000000000000000000000000003F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000200000001000000110000000000803F00008040000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000380000000000000010000000000000002400000000000000100011000000803F000000000000803F000400001000110000004040000000000000803F01040000
GO
/****** Object:  Statistic [PK_Nguoithannhanvien]     ******/
UPDATE STATISTICS [dbo].[PB_Nguoithannhanvien]([PK_Nguoithannhanvien]) WITH STATS_STREAM = 0x0100000001000000000000000000000007CD13CC00000000F201000000000000B20100000000000024030000240000001000000000000000000000000000000007000000B4CCFB0049A0000002000000000000000200000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000002000000010000002000000000008041000000400000000000008041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000560000000000000010000000000000003300000000000000100020000000803F000000000000803F992B74B44AEFC440A1851011C0B4E03C040000100020000000803F000000000000803F49208C69BB49D441850F44F27A67DE92040000, ROWCOUNT = 4, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_789EE131] ON [dbo].[PB_Nhanvien]([HoNV]) WITH STATS_STREAM = 0x01000000010000000000000000000000D194FF9400000000AF030000000000006F03000000000000E7030000E70000003C0000000000000008D0003400000000070000002B59E90048A000000600000000000000060000000000000000000000ABAA2A3E0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000600000001000000100000000000C8410000C040000000000000C84100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000050010000000000000B02000000000000300000000000000069000000000000009A00000000000000CD0000000000000000010000000000002B01000000000000300010000000803F000000000000803F040000010039004E00670075007900C51E6E00200048006F00E0006E006700200051007500D11E6300300010000000803F000000000000803F040000010031004E00670075007900C51E6E00200050006800B001A1016E006700300010000000803F000000000000803F040000010033004E00670075007900C51E6E00200054006800CB1E20004B0069006D00300010000000803F000000000000803F040000010033004E00670075007900C51E6E00200054006800CB1E2000540068007500300010000000803F000000000000803F04000001002B0054007200A71E6E0020005400680061006E006800300010000000803F000000000000803F0400000100250056006901200051007500D11E6300FF0100000000000000060000000600000028000000280000000000000000000000320000004E00670075007900C51E6E00200048006F00E0006E006700200051007500D11E630050006800B001A1016E00670054006800CB1E20004B0069006D0054006800750054007200A71E6E0020005400680061006E00680056006901200051007500D11E6300090000004000000000C007000000810A0700008106110000400417000081031B000001031E0000810A21000001072B000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_789EE131] ON [dbo].[PB_Nhanvien]([TenNV]) WITH STATS_STREAM = 0x010000000100000000000000000000006C55049A00000000BB020000000000007B02000000000000E7030000E7000000140000000000000008D0003401000000070000003059E90048A00000060000000000000006000000000000000000803FABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000010000000ABAAEA400000C04000000000ABAAEA400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000009A00000000000000170100000000000020000000000000003D000000000000005C000000000000007B00000000000000300010000000803F000000000000803F04000001001D004200AF1E6300300010000000803F000000400000803F04000001001F0048006900C11E6E00300010000000803F000000000000803F04000001001F0054006800E1006900300010000000803F000000000000803F04000001001F0054006800E71E7900FF0100000000000000060000000600000028000000280000000000000000000000130000004200AF1E63001001A11E74004800B11E6E0067006900C11E6E0054006800E1006900E71E790009000000400000000081030000008103030000C001060000810307000001030A000040020D000081020F0000010211000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_789EE131] ON [dbo].[PB_Nhanvien]([Bidanh]) WITH STATS_STREAM = 0x01000000010000000000000000000000FFF2444600000000A3020000000000006302000000000000E7020000E7000000500000000000000008D00034E7000000070000003E59E90048A00000060000000000000006000000000000000000803F0000803E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000010000000ABAA2A410000C04000000000ABAA2A410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000008100000000000000FF0000000000000018000000000000002B0000000000000052000000000000001000100000004040000000000000803F040000300010000000803F0000803F0000803F0400000100270048006900C11E6E0020006D00E1007400300010000000803F000000000000803F04000001002F0054006800E71E790020004400B91E700020004700E1006900FF0100000000000000060000000400000028000000280000000000000000000000200000001001A11E740020001101B91E70002000740072006100690048006900C11E6E0020006D00E100740054006800E71E790020004400B91E700020004700E1006900040000004300000000810C00000081080C0000010C14000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_789EE131] ON [dbo].[PB_Nhanvien]([Nu]) WITH STATS_STREAM = 0x01000000010000000000000000000000EBF2EE3200000000D4010000000000009401000000000000680300006800000001000100000000000000000001000000070000003E59E90048A0000006000000000000000600000000000000000000000000003F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000200000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003800000000000000100000000000000024000000000000001000110000008040000000000000803F000400001000110000000040000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000006_789EE131] ON [dbo].[PB_Nhanvien]([Hinhanh]) WITH STATS_STREAM = 0x010000000100000000000000000000006FBA8758000000003003000000000000F002000000000000E7020000E7000000FE0100000000000008D0003400000000070000003E59E90048A00000060000000000000006000000000000000000803FABAA2A3E0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000400000001000000100000000000E0410000C040000000000000E041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000EC000000000000008C01000000000000200000000000000053000000000000008600000000000000B900000000000000300010000000803F000000000000803F040000010033004E005600300030003000300030003000300031002E006A0070006700300010000000803F0000803F0000803F040000010033004E005600300030003000300030003000300033002E004A0050004700300010000000803F0000803F0000803F040000010033004E005600300030003000300030003000300035002E004A0050004700300010000000803F000000000000803F040000010033004E005600300030003000300030003000300036002E004A0050004700FF0100000000000000060000000600000028000000280000000000000000000000270000004E005600300030003000300030003000300031002E006A007000670032002E004A005000470033002E004A005000470034002E004A005000470035002E004A005000470036002E004A00500047000800000040000000004009000000810509000081050E00008105130000810518000081051D0000010522000000
GO
/****** Object:  Statistic [_WA_Sys_00000007_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000007_789EE131] ON [dbo].[PB_Nhanvien]([Ngaysinh]) WITH STATS_STREAM = 0x0100000001000000000000000000000084730723000000006E020000000000002E020000000000003D03B1F53D00000008001703000000000000000000000000070000004359E90048A000000600000000000000060000000000000000000000ABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000060000000100000018000000000000410000C0400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000D20000000000000030000000000000004B00000000000000660000000000000081000000000000009C00000000000000B700000000000000100018000000803F000000000000803F0000000040820000040000100018000000803F000000000000803F0000000047820000040000100018000000803F000000000000803F0000000077820000040000100018000000803F000000000000803F0000000079820000040000100018000000803F000000000000803F00000000EE820000040000100018000000803F000000000000803F000000003E830000040000
GO
/****** Object:  Statistic [_WA_Sys_00000008_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000008_789EE131] ON [dbo].[PB_Nhanvien]([Noisinh]) WITH STATS_STREAM = 0x010000000100000000000000000000005296E729000000005F020000000000001F02000000000000E7030000E7000000640000000000000008D000343D000000070000004C59E90048A0000006000000000000000600000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000010000000ABAA82410000C04000000000ABAA82410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000006000000000000000BB0000000000000010000000000000003700000000000000300010000000A040000000000000803F040000010027001001D31E6E00670020004E0061006900300010000000803F000000000000803F040000010029004800A31E690020004400B001A1016E006700FF0100000000000000060000000200000028000000280000000000000000000000110000001001D31E6E00670020004E00610069004800A31E690020004400B001A1016E0067000300000040000000008508000000010908000000
GO
/****** Object:  Statistic [_WA_Sys_00000009_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000009_789EE131] ON [dbo].[PB_Nhanvien]([Honnhan]) WITH STATS_STREAM = 0x0100000001000000000000000000000086E7717800000000B80100000000000078010000000000006803FFFF6800000001000100000000000000000000000000070000004C59E90048A0000006000000000000000600000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000C040000000000000803F00040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000A_789EE131] ON [dbo].[PB_Nhanvien]([Diachi]) WITH STATS_STREAM = 0x0100000001000000000000000000000024951A01000000003F04000000000000FF03000000000000E703B1F5E7000000C80000000000000008D0003400000000070000004C59E90048A0000006000000000000000600000000000000000000000000803E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000010000000ABAA56420000C04000000000ABAA564200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000072010000000000009B020000000000002000000000000000B900000000000000F6000000000000001D01000000000000300010000000803F000000000000803F0400000100990034003100350020002D002000A41E700020005400E2006E0020004200AF1E630020002D0020005800E30020004200EC006E00680020004D0069006E00680020002D002000480075007900C71E6E00200054007200A31E6E006700200042006F006D0020002D0020005400C91E6E00680020001001D31E6E00670020004E00610069003000100000004040000000000000803F04000001003D0042006900EA006E0020004800F200610020002D0020001001D31E6E00670020004E0061006900300010000000803F000000000000803F040000010027001001D31E6E00670020004E0061006900300010000000803F000000000000803F040000010055004C006F006E00670020004200EC006E00680020002D00200042006900EA006E0020004800F200610020002D0020001001D31E6E00670020004E0061006900FF01000000000000000600000004000000280000002800000000000000000000007300000034003100350020002D002000A41E700020005400E2006E0020004200AF1E630020002D0020005800E30020004200EC006E00680020004D0069006E00680020002D002000480075007900C71E6E00200054007200A31E6E006700200042006F006D0020002D0020005400C91E6E00680020001001D31E6E00670020004E006100690042006900EA006E0020004800F200610020002D0020001001D31E6E00670020004E00610069004C006F006E00670020004200EC006E00680020002D00200042006900EA006E0020004800F200610020002D0020001001D31E6E00670020004E0061006900050000004000000000814100000083134100008108390000011F54000000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000B_789EE131] ON [dbo].[PB_Nhanvien]([Tamtru]) WITH STATS_STREAM = 0x01000000010000000000000000000000186EF52C0000000062020000000000002202000000000000E702006EE7000000C80000000000000008D0003400200048070000004C59E90048A0000006000000000000000600000000000000000000000000003F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000200000001000000100000005555D5400000C040000000005555D5400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000006200000000000000BE0000000000000010000000000000002300000000000000100010000000A040000000000000803F040000300010000000803F000000000000803F04000001003F004C006F006E00670020004200EC006E00680020002D0020001001D31E6E00670020004E0061006900FF0100000000000000060000000200000028000000280000000000000000000000140000004C006F006E00670020004200EC006E00680020002D0020001001D31E6E00670020004E0061006900020000004500000000011400000000
GO
/****** Object:  Statistic [_WA_Sys_0000000C_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000C_789EE131] ON [dbo].[PB_Nhanvien]([Dienthoaididong]) WITH STATS_STREAM = 0x01000000010000000000000000000000FCC72712000000003402000000000000F401000000000000A7020034A7000000140000000000000008D0003401000000070000004C59E90048A00000060000000000000006000000000000000000803FABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000010000000555555400000C040000000005555554000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000043000000000000009000000000000000100000000000000023000000000000001000100000008040000000000000803F040000300010000000803F0000803F0000803F04000001002000333231363334363435FF0100000000000000060000000300000028000000280000000000000000000000140000003031323138383736343938333231363334363435030000004400000000810B00000001090B000000
GO
/****** Object:  Statistic [_WA_Sys_0000000D_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000D_789EE131] ON [dbo].[PB_Nhanvien]([Dienthoainha]) WITH STATS_STREAM = 0x01000000010000000000000000000000EF9D3A23000000002602000000000000E601000000000000A7020000A7000000140000000000000008D00034A7000000070000005159E90048A0000006000000000000000600000000000000000000000000003F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000200000001000000100000005555D53F0000C040000000005555D53F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000004400000000000000820000000000000010000000000000002300000000000000100010000000A040000000000000803F040000300010000000803F000000000000803F0400000100210030363133363734343832FF01000000000000000600000002000000280000002800000000000000000000000A00000030363133363734343832020000004500000000010A00000000
GO
/****** Object:  Statistic [_WA_Sys_0000000E_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000E_789EE131] ON [dbo].[PB_Nhanvien]([Email]) WITH STATS_STREAM = 0x01000000010000000000000000000000F6E68287000000006D020000000000002D02000000000000A7020000A7000000320000000000000008D0003400000000070000005159E90048A00000060000000000000006000000000000000000803FABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000010000000ABAA12410000C04000000000ABAA12410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000005900000000000000C900000000000000100000000000000023000000000000001000100000008040000000000000803F040000300010000000803F0000803F0000803F040000010036006B35636E74746E677579656E7068756F6E6762616340676D61696C2E636F6DFF01000000000000000600000003000000280000002800000000000000000000003700000063616E68686F6E677275636C7561407961686F6F2E636F6D6B35636E74746E677579656E7068756F6E6762616340676D61696C2E636F6D0300000044000000008118000000011F18000000
GO
/****** Object:  Statistic [_WA_Sys_0000000F_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000F_789EE131] ON [dbo].[PB_Nhanvien]([SoCMNN]) WITH STATS_STREAM = 0x0100000001000000000000000000000029C927CB00000000A0020000000000006002000000000000AF030000AF000000090000000000000008D0003400000000070000005559E90048A0000006000000000000000600000000000000000000000000803E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000019000000000010410000C04000000000000010410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000009000000000000000FC0000000000000020000000000000003C00000000000000580000000000000074000000000000001000190000000040000000000000803F3131333234363534340400001000190000000040000000000000803F313233343536373839040000100019000000803F000000000000803F313332313335343635040000100019000000803F000000000000803F313332343635343635040000FF01000000000000000600000004000000280000002800000000000000000000001F0000003131333234363534343233343536373839333231333534363534363534363507000000400000000040010000008208010000820809000040021100008106130000010619000000
GO
/****** Object:  Statistic [_WA_Sys_00000010_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000010_789EE131] ON [dbo].[PB_Nhanvien]([Ngaycap]) WITH STATS_STREAM = 0x01000000010000000000000000000000938DB670000000002802000000000000E8010000000000003D0300003D00000008001703000000000000000000000000070000005559E90048A0000006000000000000000600000000000000000000000000803E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000018000000000000410000C04000000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000008C0000000000000020000000000000003B0000000000000056000000000000007100000000000000100018000000803F000000000000803F00000000749D0000040000100018000000803F000000000000803F0000000030A000000400001000180000004040000000000000803F0000000044A00000040000100018000000803F000000000000803F0000000045A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000011_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000011_789EE131] ON [dbo].[PB_Nhanvien]([Noicap]) WITH STATS_STREAM = 0x01000000010000000000000000000000D20EB735000000005F020000000000001F02000000000000E7030000E7000000640000000000000008D0003400000000070000005A59E90048A0000006000000000000000600000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000010000000ABAA82410000C04000000000ABAA82410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000006000000000000000BB0000000000000010000000000000003700000000000000300010000000A040000000000000803F040000010027001001D31E6E00670020004E0061006900300010000000803F000000000000803F040000010029004800A31E690020004400B001A1016E006700FF0100000000000000060000000200000028000000280000000000000000000000110000001001D31E6E00670020004E00610069004800A31E690020004400B001A1016E0067000300000040000000008508000000010908000000
GO
/****** Object:  Statistic [_WA_Sys_00000012_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000012_789EE131] ON [dbo].[PB_Nhanvien]([Ngayvaolam]) WITH STATS_STREAM = 0x0100000001000000000000000000000035F4FC02000000006E020000000000002E020000000000003D0300343D00000008001703000000000000000006000000070000005A59E90048A000000600000000000000060000000000000000000000ABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000060000000100000018000000000000410000C0400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000D20000000000000030000000000000004B00000000000000660000000000000081000000000000009C00000000000000B700000000000000100018000000803F000000000000803F5F8E190144A00000040000100018000000803F000000000000803F6BCFF20045A00000040000100018000000803F000000000000803F9ACD080145A00000040000100018000000803F000000000000803F36448C0048A00000040000100018000000803F000000000000803FEDE28D0048A00000040000100018000000803F000000000000803F6FE2CC0048A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000013_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000013_789EE131] ON [dbo].[PB_Nhanvien]([Suckhoe]) WITH STATS_STREAM = 0x01000000010000000000000000000000F8C7F3E9000000004E030000000000000E03000000000000E7030000E7000000640000000000000008D0003400000000070000005A59E90048A000000600000000000000060000000000000000000000CDCC4C3E00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000005000000010000001000000055559D410000C0400000000055559D41000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000FD00000000000000AA01000000000000280000000000000053000000000000007E00000000000000AF00000000000000D4000000000000003000100000000040000000000000803F04000001002B004300F11E630020006B00F31E20007400D11E7400300010000000803F000000000000803F04000001002B004700A71E7900200071007500E100200011016900300010000000803F000000000000803F040000010031004700A51E7900200071007500E100200011016900200061006800300010000000803F000000000000803F0400000100250054006F0020006B006800CF1E6500300010000000803F000000000000803F040000010029005600650072007900200047006F006F006400FF0100000000000000060000000500000028000000280000000000000000000000300000004300F11E630020006B00F31E20007400D11E74004700A71E7900200071007500E100200011016900A51E7900200071007500E10020001101690020006100680054006F0020006B006800CF1E65005600650072007900200047006F006F006400070000004000000000820A000000C0010A0000810C14000001090B00008107200000010927000000
GO
/****** Object:  Statistic [_WA_Sys_00000014_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000014_789EE131] ON [dbo].[PB_Nhanvien]([Chieucao]) WITH STATS_STREAM = 0x01000000010000000000000000000000EC9C1538000000002802000000000000E801000000000000300340003000000001000300000000000000000000000109070000005A59E90048A000000600000000000000060000000000000000000000CDCC4C3E0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000000500000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000008C0000000000000028000000000000003C00000000000000500000000000000064000000000000007800000000000000100011000000803F000000000000803F9C040000100011000000803F000000000000803F9E0400001000110000000040000000000000803FA0040000100011000000803F000000000000803FA3040000100011000000803F000000000000803FA8040000
GO
/****** Object:  Statistic [_WA_Sys_00000015_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000015_789EE131] ON [dbo].[PB_Nhanvien]([Cannang]) WITH STATS_STREAM = 0x01000000010000000000000000000000EAA0CC7A0000000044020000000000000402000000000000300300003000000001000300000000000000000000000000070000005A59E90048A000000600000000000000060000000000000000000000ABAA2A3E0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000600000001000000110000000000803F0000C040000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000A8000000000000003000000000000000440000000000000058000000000000006C0000000000000080000000000000009400000000000000100011000000803F000000000000803F2A040000100011000000803F000000000000803F2B040000100011000000803F000000000000803F32040000100011000000803F000000000000803F36040000100011000000803F000000000000803F38040000100011000000803F000000000000803F41040000
GO
/****** Object:  Statistic [_WA_Sys_00000016_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000016_789EE131] ON [dbo].[PB_Nhanvien]([Tinhtrang]) WITH STATS_STREAM = 0x01000000010000000000000000000000050B3A4600000000B801000000000000780100000000000030030000300000000100030000000000000000000000000007000000AA6BDB0048A0000006000000000000000600000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000C040000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_00000017_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000017_789EE131] ON [dbo].[PB_Nhanvien]([Maquoctich]) WITH STATS_STREAM = 0x01000000010000000000000000000000680746AE00000000DA010000000000009A01000000000000380300003800000004000A000000000000000000000000000700000058E3D80048A0000006000000000000000600000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003E0000000000000010000000000000002700000000000000100014000000A040000000000000803F01000000040000100014000000803F000000000000803F02000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000018_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000018_789EE131] ON [dbo].[PB_Nhanvien]([Madantoc]) WITH STATS_STREAM = 0x01000000010000000000000000000000C4B1F19B000000001802000000000000D801000000000000380300003800000004000A00000000000000000000000000070000005DE3D80048A0000006000000000000000600000000000000000000000000803E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000007C00000000000000200000000000000037000000000000004E0000000000000065000000000000001000140000000040000000000000803F01000000040000100014000000803F000000000000803F020000000400001000140000000040000000000000803F03000000040000100014000000803F000000000000803F04000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000019_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000019_789EE131] ON [dbo].[PB_Nhanvien]([Matongiao]) WITH STATS_STREAM = 0x010000000100000000000000000000004DEF354E00000000F901000000000000B9010000000000003803B1F53800000004000A000000000000000000000000000700000061E3D80048A000000600000000000000060000000000000000000000ABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000005D0000000000000018000000000000002F0000000000000046000000000000001000140000000040000000000000803F010000000400001000140000004040000000000000803F02000000040000100014000000803F000000000000803F04000000040000
GO
/****** Object:  Statistic [_WA_Sys_0000001A_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000001A_789EE131] ON [dbo].[PB_Nhanvien]([Mabangcap]) WITH STATS_STREAM = 0x01000000010000000000000000000000148CE05C00000000BB010000000000007B0100000000000038030A023800000004000A000000000000000000010000000700000058E3D80048A0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F06000000040000
GO
/****** Object:  Statistic [_WA_Sys_0000001B_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000001B_789EE131] ON [dbo].[PB_Nhanvien]([Mangonngu]) WITH STATS_STREAM = 0x0100000001000000000000000000000010A8CB7A00000000BB010000000000007B0100000000000038020A023800000004000A00000000000000000001000000070000005DE3D80048A0000006000000000000000600000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000ABAA2A3F0000C0400000A040ABAA2A3F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000
GO
/****** Object:  Statistic [_WA_Sys_0000001C_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000001C_789EE131] ON [dbo].[PB_Nhanvien]([Machuyenmon]) WITH STATS_STREAM = 0x01000000010000000000000000000000F11882E000000000940100000000000054010000000000003802B1F53800000004000A00000000000000000000000000070000005DE3D80048A0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000014000000000000000000C0400000C04000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_0000001D_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000001D_789EE131] ON [dbo].[PB_Nhanvien]([Matinhoc]) WITH STATS_STREAM = 0x010000000100000000000000000000004AB277F400000000940100000000000054010000000000003802B1F53800000004000A000000000000000000000000000700000061E3D80048A0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000014000000000000000000C0400000C04000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_0000001E_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000001E_789EE131] ON [dbo].[PB_Nhanvien]([MaToNhom]) WITH STATS_STREAM = 0x01000000010000000000000000000000F836FC0800000000940100000000000054010000000000003802B1F53800000004000A000000000000000000000000000700000053E3D80048A0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000014000000000000000000C0400000C04000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_0000001F_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000001F_789EE131] ON [dbo].[PB_Nhanvien]([BHXH]) WITH STATS_STREAM = 0x01000000010000000000000000000000B30501B100000000B8010000000000007801000000000000680300006800000001000100000000000000000000000000070000005A59E90048A0000006000000000000000600000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000C040000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_00000020_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000020_789EE131] ON [dbo].[PB_Nhanvien]([BHYT]) WITH STATS_STREAM = 0x01000000010000000000000000000000B30501B100000000B8010000000000007801000000000000680300006800000001000100000000000000000000000000070000005A59E90048A0000006000000000000000600000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000C040000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_00000021_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000021_789EE131] ON [dbo].[PB_Nhanvien]([BHTN]) WITH STATS_STREAM = 0x01000000010000000000000000000000E5276FB500000000B8010000000000007801000000000000680300006800000001000100000000000000000000000000070000005F59E90048A0000006000000000000000600000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000C040000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_00000022_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000022_789EE131] ON [dbo].[PB_Nhanvien]([Phicongdoan]) WITH STATS_STREAM = 0x010000000100000000000000000000008040D30D00000000B8010000000000007801000000000000680300006800000001000100000000000000000000000000070000005F59E90048A0000006000000000000000600000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000C040000000000000803F00040000
GO
/****** Object:  Statistic [_WA_Sys_00000024_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000024_789EE131] ON [dbo].[PB_Nhanvien]([CreatedByUser]) WITH STATS_STREAM = 0x010000000100000000000000000000003E6E888200000000C7010000000000008701000000000000240300002400000010000000000000000000000006000000070000006359E90048A0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000C04000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000C040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000025_789EE131]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000025_789EE131] ON [dbo].[PB_Nhanvien]([CreatedByDate]) WITH STATS_STREAM = 0x0100000001000000000000000000000020834D38000000006E020000000000002E020000000000003D0300003D00000008001703000000000000000000000000070000007159E90048A000000600000000000000060000000000000000000000ABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000060000000100000018000000000000410000C0400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000D20000000000000030000000000000004B00000000000000660000000000000081000000000000009C00000000000000B700000000000000100018000000803F000000000000803F2259A70045A00000040000100018000000803F000000000000803F5DF70D0145A00000040000100018000000803F000000000000803FB0F6100145A00000040000100018000000803F000000000000803F36448C0048A00000040000100018000000803F000000000000803F50F88D0048A00000040000100018000000803F000000000000803FE48ACD0048A00000040000
GO
/****** Object:  Statistic [PK_Nhanvien]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_Nhanvien]([PK_Nhanvien]) WITH STATS_STREAM = 0x01000000010000000000000000000000EBEDF47F00000000A9020000000000006902000000000000A7030000A70000000A0000000000000008D0003400000000070000004FE3D80048A00000060000000000000006000000000000000000803FABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000010000000000020410000C0400000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000A40000000000000005010000000000002000000000000000410000000000000062000000000000008300000000000000300010000000803F000000000000803F040000010021004E563030303030303031300010000000803F0000803F0000803F040000010021004E563030303030303033300010000000803F0000803F0000803F040000010021004E563030303030303035300010000000803F000000000000803F040000010021004E563030303030303036FF01000000000000000600000006000000280000002800000000000000000000000F0000004E56303030303030303132333435360800000040000000004009000000810109000081010A000081010B000081010C000081010D000001010E000000, ROWCOUNT = 8, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_062DE679]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_062DE679] ON [dbo].[PB_Phongban]([Tenphong]) WITH STATS_STREAM = 0x010000000100000000000000000000003E052F54000000001302000000000000D301000000000000E703B1F5E7000000640000000000000008D000340100000007000000D359F70046A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000060410000803F00000000000060410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000002D000000000000006F000000000000000800000000000000300010000000803F000000000000803F040000010025004E006800E2006E0020007300F11EFF0100000000000000010000000100000028000000280000000000000000000000070000004E006800E2006E0020007300F11E020000004000000000010700000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_062DE679]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_062DE679] ON [dbo].[PB_Phongban]([Dienthoai]) WITH STATS_STREAM = 0x01000000010000000000000000000000765C1ACF000000000B02000000000000CB01000000000000A7020000A7000000140000000000000008D00034E700000007000000D359F70046A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000020410000803F0000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F0400000100210030363133363734343832FF01000000000000000100000001000000280000002800000000000000000000000A00000030363133363734343832020000004000000000010A00000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_062DE679]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_062DE679] ON [dbo].[PB_Phongban]([Tongsonhanvien]) WITH STATS_STREAM = 0x010000000100000000000000000000005BCBF6080000000094010000000000005401000000000000380200003800000004000A0000000000000000000000000007000000D359F70046A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000014000000000000000000803F0000803F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_062DE679]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_062DE679] ON [dbo].[PB_Phongban]([GhiChu]) WITH STATS_STREAM = 0x010000000100000000000000000000003E59EABF0000000053020000000000001302000000000000E7020000E7000000C80000000000000008D000340000803F07000000DC59F70046A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000038420000803F00000000000038420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000004D00000000000000AF000000000000000800000000000000300010000000803F000000000000803F0400000100450050006800F2006E00670020006E00E000790020006C00E00020006E006800E2006E0020007300F11E20006E00E800FF01000000000000000100000001000000280000002800000000000000000000001700000050006800F2006E00670020006E00E000790020006C00E00020006E006800E2006E0020007300F11E20006E00E800020000004000000000011700000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_062DE679]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000006_062DE679] ON [dbo].[PB_Phongban]([CreatedByUser]) WITH STATS_STREAM = 0x010000000100000000000000000000000740B92500000000C701000000000000870100000000000024030000240000001000000000000000000000000000000007000000DC59F70046A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_062DE679]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000007_062DE679] ON [dbo].[PB_Phongban]([CreatedByDate]) WITH STATS_STREAM = 0x0100000001000000000000000000000047EA8F3600000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000002400000007000000DC59F70046A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803FCAF9F50046A00000040000
GO
/****** Object:  Statistic [PK_Phongban]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_Phongban]([PK_Phongban]) WITH STATS_STREAM = 0x01000000010000000000000000000000330134B100000000BB010000000000007B01000000000000380300003800000004000A00000000000000000000000000070000000E54F70046A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 3, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_34B3CB38]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_34B3CB38] ON [dbo].[PB_PhucapNhanvien]([Maphucap]) WITH STATS_STREAM = 0x0100000001000000000000000000000022BB8A5D00000000BB010000000000007B01000000000000380313003800000004000A0000000000000000000100000007000000337ECC0049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000
GO
/****** Object:  Statistic [PK_PB_PhucapNhanvien]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_PhucapNhanvien]([PK_PB_PhucapNhanvien]) WITH STATS_STREAM = 0x01000000020000000000000000000000BCC4980E000000002302000000000000CB01000000000000A7030000A70000000A0000000000000008D0003400000000380300003800000004000A00000000000000000000000000070000007EC4D00049A0000001000000000000000100000000000000000000000000803F0000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000200000010000000000060410000803F0000000000002041000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303031FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303031020000004000000000010A00000000, ROWCOUNT = 3, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_670A40DB] ON [dbo].[PB_SoLuong]([MaNV]) WITH STATS_STREAM = 0x01000000010000000000000000000000F788FCAB00000000A9020000000000006902000000000000A703B1F5A70000000A0000000000000008D00034000000000700000016EA59014DA00000060000000000000006000000000000000000803FABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000010000000000020410000C0400000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000A40000000000000005010000000000002000000000000000410000000000000062000000000000008300000000000000300010000000803F000000000000803F040000010021004E563030303030303031300010000000803F0000803F0000803F040000010021004E563030303030303033300010000000803F0000803F0000803F040000010021004E563030303030303035300010000000803F000000000000803F040000010021004E563030303030303036FF01000000000000000600000006000000280000002800000000000000000000000F0000004E56303030303030303132333435360800000040000000004009000000810109000081010A000081010B000081010C000081010D000001010E000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_670A40DB] ON [dbo].[PB_SoLuong]([Hesoluong]) WITH STATS_STREAM = 0x0100000001000000000000000000000000E2A13A000000004B020000000000000B020000000000003E0313003E000000080035000000000000000000010000000700000080309C004EA00000060000000000000006000000000000000000803FABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000050000000100000018000000000000410000C0400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000AF00000000000000280000000000000043000000000000005E0000000000000079000000000000009400000000000000100018000000803F000000000000803F333333333333F33F040000100018000000803F000000000000803F000000000000F83F040000100018000000803F000000000000803F52B81E85EB51F83F040000100018000000803F000000000000803F48E17A14AE47F93F040000100018000000803F0000803F0000803FCDCCCCCCCCCCFC3F040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_670A40DB] ON [dbo].[PB_SoLuong]([Tonggiocongthucte]) WITH STATS_STREAM = 0x01000000010000000000000000000000E5D76E0700000000DA010000000000009A01000000000000380300003800000004000A000000000000000000000000000700000080309C004EA0000006000000000000000600000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003E00000000000000100000000000000027000000000000001000140000000040000000000000803FCD0000000400001000140000008040000000000000803FD0000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_670A40DB] ON [dbo].[PB_SoLuong]([Nghiphep]) WITH STATS_STREAM = 0x01000000010000000000000000000000E80697F400000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000000000000700000080309C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000006_670A40DB] ON [dbo].[PB_SoLuong]([BHXH]) WITH STATS_STREAM = 0x01000000010000000000000000000000E4737A1300000000B80100000000000078010000000000006803B1F568000000010001000000000000000000000000000700000080309C004EA0000006000000000000000600000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000C040000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000007_670A40DB] ON [dbo].[PB_SoLuong]([BHYT]) WITH STATS_STREAM = 0x01000000010000000000000000000000E4737A1300000000B80100000000000078010000000000006803B1F568000000010001000000000000000000000000000700000080309C004EA0000006000000000000000600000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000C040000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_00000008_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000008_670A40DB] ON [dbo].[PB_SoLuong]([BHTN]) WITH STATS_STREAM = 0x01000000010000000000000000000000E4737A1300000000B80100000000000078010000000000006803B1F568000000010001000000000000000000000000000700000080309C004EA0000006000000000000000600000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000C040000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_00000009_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000009_670A40DB] ON [dbo].[PB_SoLuong]([Phicongdoan]) WITH STATS_STREAM = 0x010000000100000000000000000000008114C6AB00000000B80100000000000078010000000000006803B1F568000000010001000000000000000000000000000700000080309C004EA0000006000000000000000600000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000C040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000C040000000000000803F00040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000A_670A40DB] ON [dbo].[PB_SoLuong]([Tienthue]) WITH STATS_STREAM = 0x01000000010000000000000000000000E80697F400000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000000000000700000080309C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000B_670A40DB] ON [dbo].[PB_SoLuong]([Songuoiphuthuoc]) WITH STATS_STREAM = 0x01000000010000000000000000000000DAE4830700000000DA010000000000009A01000000000000380300003800000004000A000000000000000000000000000700000085309C004EA00000060000000000000006000000000000000000803FABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003E00000000000000100000000000000027000000000000001000140000008040000000000000803F00000000040000100014000000803F0000803F0000803F02000000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000C_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000C_670A40DB] ON [dbo].[PB_SoLuong]([Sotienconlaichiuthue]) WITH STATS_STREAM = 0x01000000010000000000000000000000915E1E9100000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000000000000700000085309C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000D_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000D_670A40DB] ON [dbo].[PB_SoLuong]([Tiendongthue]) WITH STATS_STREAM = 0x01000000010000000000000000000000915E1E9100000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000000000000700000085309C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000E_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000E_670A40DB] ON [dbo].[PB_SoLuong]([Phicongtac]) WITH STATS_STREAM = 0x01000000010000000000000000000000915E1E9100000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000000000000700000085309C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000F_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000F_670A40DB] ON [dbo].[PB_SoLuong]([Tongtamung]) WITH STATS_STREAM = 0x01000000010000000000000000000000915E1E9100000000BB010000000000007B010000000000003803B1F53800000004000A000000000000000000000000000700000085309C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000010_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000010_670A40DB] ON [dbo].[PB_SoLuong]([Tongphucap]) WITH STATS_STREAM = 0x01000000010000000000000000000000740BE33800000000F901000000000000B901000000000000380300003800000004000A000000000000000000000000000700000085309C004EA000000600000000000000060000000000000000000000ABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000005D0000000000000018000000000000002F0000000000000046000000000000001000140000008040000000000000803F00000000040000100014000000803F000000000000803F40420F00040000100014000000803F000000000000803F60E31600040000
GO
/****** Object:  Statistic [_WA_Sys_00000011_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000011_670A40DB] ON [dbo].[PB_SoLuong]([Tongthuong]) WITH STATS_STREAM = 0x01000000010000000000000000000000CE855DE100000000BB010000000000007B0100000000000038030AF63800000004000A000000000000000000000000000700000085309C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000C04000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000C040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000012_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000012_670A40DB] ON [dbo].[PB_SoLuong]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000C80CC28300000000C7010000000000008701000000000000240300002400000010000000000000000000000006000000070000008A309C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000C04000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000C040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000013_670A40DB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000013_670A40DB] ON [dbo].[PB_SoLuong]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000BD74F2AB00000000BF010000000000007F010000000000003D0300003D00000008001703000000000000000024000000070000008A309C004EA0000006000000000000000600000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000C040000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000C040000000000000803F36D759014DA00000040000
GO
/****** Object:  Statistic [PK_Soluong]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_SoLuong]([PK_Soluong]) WITH STATS_STREAM = 0x01000000020000000000000000000000137700E500000000DF0100000000000087010000000000002403C0402400000010000000000000000000000000000000A7030000A70000000A0000000000000008D00034000000000700000008EA59014DA0000006000000000000000600000000000000000000000000803FABAA2A3E00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000002000000200000000000D0410000C04000000000000080410000204100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000C040000000000000803FB80BB6F085EA7F40A86DDD6032728B8B040000, ROWCOUNT = 6, PAGECOUNT = 1
GO
/****** Object:  Statistic [PK_PB_Tainanlaodong]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_Tainanlaodong]([PK_PB_Tainanlaodong]) WITH STATS_STREAM = 0x01000000010000000000000000000000ED0358EE0000000040000000000000000000000000000000380300003800000004000A00000000000000000000000000, ROWCOUNT = 0, PAGECOUNT = 0
GO
/****** Object:  Statistic [_WA_Sys_00000002_49AEE81E]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_49AEE81E] ON [dbo].[PB_TamungNhanvien]([MaNV]) WITH STATS_STREAM = 0x01000000010000000000000000000000D6C031B5000000000B02000000000000CB01000000000000A703006FA70000000A0000000000000008D00034FFFFFFFF07000000BC4FF9004AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000020410000803F0000000000002041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303034FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303034020000004000000000010A00000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_49AEE81E]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_49AEE81E] ON [dbo].[PB_TamungNhanvien]([Ngaytamung]) WITH STATS_STREAM = 0x01000000010000000000000000000000AC318D4200000000BF010000000000007F010000000000003D03B1F53D0000000800170300000000000000000100000007000000BC4FF9004AA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F000000004AA00000040000
GO
/****** Object:  Statistic [PK_PB_TamungNhanvien]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_TamungNhanvien]([PK_PB_TamungNhanvien]) WITH STATS_STREAM = 0x010000000100000000000000000000009F90C18000000000F201000000000000B2010000000000002403000024000000100000000000000000000000000000000700000028D3880050A0000002000000000000000200000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000002000000010000002000000000008041000000400000000000008041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000560000000000000010000000000000003300000000000000100020000000803F000000000000803F91DADC369332CC45944B6B9C846049B7040000100020000000803F000000000000803F39FF82AB5C280E409FAB7E75769C561F040000, ROWCOUNT = 2, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_5FD33367] ON [dbo].[PB_Thaydoibacluong]([Ngayapdung]) WITH STATS_STREAM = 0x010000000100000000000000000000008C540EC100000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000000000000007000000AFF0AB0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F1277AA0048A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_5FD33367] ON [dbo].[PB_Thaydoibacluong]([MaNgach]) WITH STATS_STREAM = 0x0100000001000000000000000000000078B799B700000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000B4F0AB0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_5FD33367] ON [dbo].[PB_Thaydoibacluong]([BacLuong]) WITH STATS_STREAM = 0x01000000010000000000000000000000D639544F00000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000BDF0AB0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_5FD33367] ON [dbo].[PB_Thaydoibacluong]([Hesoluong]) WITH STATS_STREAM = 0x01000000010000000000000000000000C32C1C4E00000000BF010000000000007F010000000000003E0300003E0000000800350000000000000000000000000007000000BDF0AB0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F0000000000000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000006_5FD33367] ON [dbo].[PB_Thaydoibacluong]([Nguoiky]) WITH STATS_STREAM = 0x0100000001000000000000000000000081823B57000000003B02000000000000FB01000000000000E7020000E7000000500000000000000008D000340000000007000000C2F0AB0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000008420000803F0000000000000842000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000410000000000000097000000000000000800000000000000300010000000803F000000000000803F040000010039004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300FF0100000000000000010000000100000028000000280000000000000000000000110000004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300020000004000000000011100000000
GO
/****** Object:  Statistic [_WA_Sys_00000007_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000007_5FD33367] ON [dbo].[PB_Thaydoibacluong]([Chucvunguoiky]) WITH STATS_STREAM = 0x0100000001000000000000000000000094081ABD000000002B02000000000000EB01000000000000E7020000E7000000640000000000000008D00034E700000007000000C2F0AB0048A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000D0410000803F000000000000D041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000390000000000000087000000000000000800000000000000300010000000803F000000000000803F040000010031005400D51E6E006700200067006900E1006D0020001101D11E6300FF01000000000000000100000001000000280000002800000000000000000000000D0000005400D51E6E006700200067006900E1006D0020001101D11E6300020000004000000000010D00000000
GO
/****** Object:  Statistic [_WA_Sys_00000008_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000008_5FD33367] ON [dbo].[PB_Thaydoibacluong]([Ngayky]) WITH STATS_STREAM = 0x010000000100000000000000000000008FC6265600000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000000000000007000000D5F0AB0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F0000000048A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000009_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000009_5FD33367] ON [dbo].[PB_Thaydoibacluong]([LyDo]) WITH STATS_STREAM = 0x01000000010000000000000000000000A4F81715000000001702000000000000D701000000000000E7030000E7000000C80000000000000008D000340000000007000000D5F0AB0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000002F0000000000000073000000000000000800000000000000300010000000803F000000000000803F0400000100270061007300640066006100730064006600FF01000000000000000100000001000000280000002800000000000000000000000800000061007300640066006100730064006600020000004000000000010800000000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000A_5FD33367] ON [dbo].[PB_Thaydoibacluong]([GhiChu]) WITH STATS_STREAM = 0x01000000010000000000000000000000C96FEAD1000000001302000000000000D301000000000000E7020000E7000000C80000000000000008D000340000000007000000D5F0AB0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000060410000803F00000000000060410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000002D000000000000006F000000000000000800000000000000300010000000803F000000000000803F040000010025006400730066006100730064006600FF0100000000000000010000000100000028000000280000000000000000000000070000006400730066006100730064006600020000004000000000010700000000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000B_5FD33367] ON [dbo].[PB_Thaydoibacluong]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000FDAC834200000000C70100000000000087010000000000002403B1F5240000001000000000000000000000000100000007000000D5F0AB0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_0000000C_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000C_5FD33367] ON [dbo].[PB_Thaydoibacluong]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000C454357C00000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000002400000007000000D5F0AB0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F1277AA0048A00000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000D_5FD33367]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000D_5FD33367] ON [dbo].[PB_Thaydoibacluong]([IsCurrent]) WITH STATS_STREAM = 0x0100000001000000000000000000000037EAC51800000000B801000000000000780100000000000068030000680000000100010000000000000000002400000007000000A6F0AB0048A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F01040000
GO
/****** Object:  Statistic [PK_Thaydoibacluong]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_Thaydoibacluong]([PK_Thaydoibacluong]) WITH STATS_STREAM = 0x01000000020000000000000000000000766F4C73000000002302000000000000CB01000000000000A7030000A70000000A0000000000000008D00034000000003D0300003D0000000800170300000000000000000000000007000000A6F0AB0048A0000001000000000000000100000000000000000000000000803F0000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000200000010000000000090410000803F0000000000002041000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303031FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303031020000004000000000010A00000000, ROWCOUNT = 9, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_5C02A283]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_5C02A283] ON [dbo].[PB_Thaydoichucvu]([Machucvu]) WITH STATS_STREAM = 0x01000000010000000000000000000000AA97FF2300000000BB010000000000007B010000000000003803B1F53800000004000A0000000000000000006800000007000000AA4E840048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_5C02A283]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_5C02A283] ON [dbo].[PB_Thaydoichucvu]([Ngayapdung]) WITH STATS_STREAM = 0x01000000010000000000000000000000397EE30C00000000D70200000000000097020000000000003D0300003D0000000800170300000000000000000000000007000000A40889004FA000000900000000000000090000000000000000000000398EE33D000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000090000000100000018000000000000410000104100000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003B01000000000000480000000000000063000000000000007E000000000000009900000000000000B400000000000000CF00000000000000EA0000000000000005010000000000002001000000000000100018000000803F000000000000803F854E840048A00000040000100018000000803F000000000000803F02DF850048A00000040000100018000000803F000000000000803FDD43860048A00000040000100018000000803F000000000000803F83438E0048A00000040000100018000000803F000000000000803F0ED98F0048A00000040000100018000000803F000000000000803F5BAB84004FA00000040000100018000000803F000000000000803FA2BB84004FA00000040000100018000000803F000000000000803F4C9E88004FA00000040000100018000000803F000000000000803FC1A388004FA00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_5C02A283]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_5C02A283] ON [dbo].[PB_Thaydoichucvu]([Nguoiky]) WITH STATS_STREAM = 0x01000000010000000000000000000000370E3B2B000000009B020000000000005B02000000000000E7020A02E7000000500000000000000008D000340000000007000000AE0889004FA0000009000000000000000900000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000010000000E43806420000104100000000E43806420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000007E00000000000000F70000000000000010000000000000004500000000000000300010000000803F000000000000803F040000010035003C0062003E004800C71E200074006800D11E6E0067003C002F0062003E003000100000000041000000000000803F040000010039004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300FF0100000000000000090000000200000028000000280000000000000000000000200000003C0062003E004800C71E200074006800D11E6E0067003C002F0062003E004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300030000004000000000810F00000008110F000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_5C02A283]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_5C02A283] ON [dbo].[PB_Thaydoichucvu]([Chucvunguoiky]) WITH STATS_STREAM = 0x0100000001000000000000000000000006CE610E000000008B020000000000004B02000000000000E7020000E7000000640000000000000008D00034E700000007000000AE0889004FA0000009000000000000000900000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000010000000398ED3410000104100000000398ED3410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000007600000000000000E70000000000000010000000000000004500000000000000300010000000803F000000000000803F040000010035003C0062003E004800C71E200074006800D11E6E0067003C002F0062003E003000100000000041000000000000803F040000010031005400D51E6E006700200067006900E1006D0020001101D11E6300FF01000000000000000900000002000000280000002800000000000000000000001C0000003C0062003E004800C71E200074006800D11E6E0067003C002F0062003E005400D51E6E006700200067006900E1006D0020001101D11E6300030000004000000000810F000000080D0F000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_5C02A283]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000006_5C02A283] ON [dbo].[PB_Thaydoichucvu]([Ngayky]) WITH STATS_STREAM = 0x01000000010000000000000000000000FC12AA1000000000E201000000000000A2010000000000003D03FFFF3D0000000800170300000000000000000000000007000000AE0889004FA0000009000000000000000900000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000002000000010000001800000000000041000010410000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000460000000000000010000000000000002B00000000000000100018000000A040000000000000803F0000000048A000000400001000180000008040000000000000803F000000004FA00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_5C02A283]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000007_5C02A283] ON [dbo].[PB_Thaydoichucvu]([LyDo]) WITH STATS_STREAM = 0x010000000100000000000000000000006EF1D8CE0000000098030000000000005803000000000000E703004FE7000000C80000000000000008D000340000000007000000B30889004FA000000900000000000000090000000000000000000000ABAA2A3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000060000000100000010000000E438AE410000104100000000E438AE410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000003A01000000000000F401000000000000300000000000000055000000000000007C00000000000000B300000000000000F2000000000000001501000000000000300010000000803F000000000000803F0400000100250061007300640066006100730064003000100000000040000000000000803F0400000100270061007300640066006100730064006600300010000000803F000000000000803F040000010037004B006800DF1E690020007400A11E6F0020006C00A71E6E0020001101A71E75003000100000000040000000000000803F04000001003F004D00DB1E6900200067006900610020006E006800AD1E700020006300F4006E0067002000740079003000100000000040000000000000803F040000010023004D00DB1E690020006D00E000300010000000803F000000000000803F040000010025007300640066007300610064006600FF01000000000000000900000006000000280000002800000000000000000000003400000061007300640066006100730064004B006800DF1E690020007400A11E6F0020006C00A71E6E0020001101A71E75004D00DB1E6900200067006900610020006E006800AD1E700020006300F4006E0067002000740079006D00E0007300640066007300610064006600080000004000000000C10700000002010300008110070000C00417000082101B000002022B000001072D000000
GO
/****** Object:  Statistic [_WA_Sys_00000008_5C02A283]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000008_5C02A283] ON [dbo].[PB_Thaydoichucvu]([GhiChu]) WITH STATS_STREAM = 0x0100000001000000000000000000000053FED07500000000B3020000000000007302000000000000E702B1F5E7000000C80000000000000008D000340000000007000000B70889004FA0000009000000000000000900000000000000000000000000803E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000040000000100000010000000ABAA0A410000104100000000ABAA0A41000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000A6000000000000000F01000000000000200000000000000033000000000000005A0000000000000081000000000000001000100000008040000000000000803F0400003000100000004040000000000000803F0400000100270061007300640066006100730064006600300010000000803F000000000000803F0400000100270061007300640066007300610064006600300010000000803F000000000000803F0400000100250042006F007300730020006E00E800FF01000000000000000900000004000000280000002800000000000000000000001300000061007300640066006100730064006600730061006400660042006F007300730020006E00E800050000004400000000C0040000008304040000010408000001070C000000
GO
/****** Object:  Statistic [_WA_Sys_00000009_5C02A283]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000009_5C02A283] ON [dbo].[PB_Thaydoichucvu]([CreatedByUser]) WITH STATS_STREAM = 0x010000000100000000000000000000009E1453BE00000000C701000000000000870100000000000024030000240000001000000000000000000000000100000007000000B70889004FA0000009000000000000000900000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000104100000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B0000000000000008000000000000001000200000001041000000000000803FE462C85681267D4BA0D2A6FB4F4257F8040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_5C02A283]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000A_5C02A283] ON [dbo].[PB_Thaydoichucvu]([CreatedByDate]) WITH STATS_STREAM = 0x010000000100000000000000000000008B24A2CF00000000D70200000000000097020000000000003D0300003D0000000800170300000000000000000000000007000000B70889004FA000000900000000000000090000000000000000000000398EE33D000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000090000000100000018000000000000410000104100000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000003B01000000000000480000000000000063000000000000007E000000000000009900000000000000B400000000000000CF00000000000000EA0000000000000005010000000000002001000000000000100018000000803F000000000000803F854E840048A00000040000100018000000803F000000000000803F02DF850048A00000040000100018000000803F000000000000803FDD43860048A00000040000100018000000803F000000000000803F83438E0048A00000040000100018000000803F000000000000803F0ED98F0048A00000040000100018000000803F000000000000803F5BAB84004FA00000040000100018000000803F000000000000803FA2BB84004FA00000040000100018000000803F000000000000803F4C9E88004FA00000040000100018000000803F000000000000803FC1A388004FA00000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_5C02A283]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000B_5C02A283] ON [dbo].[PB_Thaydoichucvu]([IsCurrent]) WITH STATS_STREAM = 0x010000000100000000000000000000000654913D00000000B80100000000000078010000000000006803000068000000010001000000000000000000C1A38800070000006554840048A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F01040000
GO
/****** Object:  Statistic [PK_Thangchuc]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_Thaydoichucvu]([PK_Thangchuc]) WITH STATS_STREAM = 0x01000000030000000000000000000000C8B0379F000000003B02000000000000CB01000000000000A7030000A70000000A0000000000000008D0003401000000380300003800000004000A000000000000000000000000003D0300003D0000000800170300000000000000000000000007000000AA4E840048A0000001000000000000000100000000000000000000000000803F0000803F0000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000003000000100000000000B0410000803F0000000000002041000080400000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303031FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303031020000004000000000010A00000000, ROWCOUNT = 8, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_5832119F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_5832119F] ON [dbo].[PB_Thaydoicongviec]([Macongviec]) WITH STATS_STREAM = 0x01000000010000000000000000000000A3E9D1BF00000000BB010000000000007B010000000000003803FFFF3800000004000A0000000000000000000000000007000000BBBEBD0048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F04000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_5832119F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_5832119F] ON [dbo].[PB_Thaydoicongviec]([Ngayapdung]) WITH STATS_STREAM = 0x01000000010000000000000000000000A1ED4326000000000502000000000000C5010000000000003D0300003D000000080017030000000000000000000000000700000093739B004EA00000040000000000000004000000000000000000803F0000803E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000018000000000000410000804000000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000006900000000000000180000000000000033000000000000004E00000000000000100018000000803F000000000000803FA9BEBD0048A00000040000100018000000803F000000000000803FEB71C70048A00000040000100018000000803F0000803F0000803FFCFD95004EA00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_5832119F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_5832119F] ON [dbo].[PB_Thaydoicongviec]([Nguoiky]) WITH STATS_STREAM = 0x010000000100000000000000000000008B846B2F000000003B02000000000000FB01000000000000E7020000E7000000500000000000000008D00034000000000700000097739B004EA0000004000000000000000400000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000008420000804000000000000008420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000004100000000000000970000000000000008000000000000003000100000008040000000000000803F040000010039004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300FF0100000000000000040000000100000028000000280000000000000000000000110000004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300020000004000000000041100000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_5832119F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_5832119F] ON [dbo].[PB_Thaydoicongviec]([Chucvunguoiky]) WITH STATS_STREAM = 0x01000000010000000000000000000000219898D4000000002B02000000000000EB01000000000000E7020000E7000000640000000000000008D00034E70000000700000097739B004EA0000004000000000000000400000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000D04100008040000000000000D0410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000003900000000000000870000000000000008000000000000003000100000008040000000000000803F040000010031005400D51E6E006700200067006900E1006D0020001101D11E6300FF01000000000000000400000001000000280000002800000000000000000000000D0000005400D51E6E006700200067006900E1006D0020001101D11E6300020000004000000000040D00000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_5832119F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000006_5832119F] ON [dbo].[PB_Thaydoicongviec]([Ngayky]) WITH STATS_STREAM = 0x01000000010000000000000000000000ADC82FA2000000000502000000000000C5010000000000003D03B1F53D000000080017030000000000000000000000000700000097739B004EA000000400000000000000040000000000000000000000ABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000018000000000000410000804000000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000006900000000000000180000000000000033000000000000004E000000000000001000180000000040000000000000803F0000000048A00000040000100018000000803F000000000000803F000000004AA00000040000100018000000803F000000000000803F000000004EA00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_5832119F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000007_5832119F] ON [dbo].[PB_Thaydoicongviec]([LyDo]) WITH STATS_STREAM = 0x010000000100000000000000000000002145F79A00000000E302000000000000A302000000000000E7030000E7000000C80000000000000008D000340000000007000000A1739B004EA0000004000000000000000400000000000000000000000000803E00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000004000000010000001000000000008041000080400000000000008041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000BC000000000000003F010000000000002000000000000000450000000000000068000000000000009900000000000000300010000000803F000000000000803F0400000100250042006F007300730020006D00E000300010000000803F000000000000803F04000001002300640067007300640066006700300010000000803F000000000000803F040000010031006600610073006400660061007300640066006100730064006600300010000000803F000000000000803F04000001002300730066006100730064006600FF01000000000000000400000004000000280000002800000000000000000000002000000042006F007300730020006D00E000640067007300640066006700660061007300640066006100730064006600610073006400660073006600610073006400660005000000400000000081070000008106070000810D0D000001061A000000
GO
/****** Object:  Statistic [_WA_Sys_00000008_5832119F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000008_5832119F] ON [dbo].[PB_Thaydoicongviec]([GhiChu]) WITH STATS_STREAM = 0x010000000100000000000000000000003BB3EDAF000000002202000000000000E201000000000000E702B1F5E7000000C80000000000000008D000340000000007000000A1739B004EA0000004000000000000000400000000000000000000000000003F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000200000001000000100000000000004000008040000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000042000000000000007E00000000000000100000000000000023000000000000001000100000004040000000000000803F040000300010000000803F000000000000803F04000001001F006100730064006600FF0100000000000000040000000200000028000000280000000000000000000000040000006100730064006600020000004300000000010400000000
GO
/****** Object:  Statistic [_WA_Sys_00000009_5832119F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000009_5832119F] ON [dbo].[PB_Thaydoicongviec]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000A00E866300000000C701000000000000870100000000000024031300240000001000000000000000000000000100000007000000A1739B004EA0000004000000000000000400000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000804000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B0000000000000008000000000000001000200000008040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_5832119F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000A_5832119F] ON [dbo].[PB_Thaydoicongviec]([CreatedByDate]) WITH STATS_STREAM = 0x010000000100000000000000000000000E3A0EA8000000000502000000000000C5010000000000003D0300003D0000000800170300000000000000000000000007000000A5739B004EA00000040000000000000004000000000000000000803F0000803E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000018000000000000410000804000000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000006900000000000000180000000000000033000000000000004E00000000000000100018000000803F000000000000803FA9BEBD0048A00000040000100018000000803F000000000000803FEB71C70048A00000040000100018000000803F0000803F0000803FFCFD95004EA00000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_5832119F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000B_5832119F] ON [dbo].[PB_Thaydoicongviec]([IsCurrent]) WITH STATS_STREAM = 0x010000000100000000000000000000001AF2F51700000000B80100000000000078010000000000006803B1F56800000001000100000000000000000024000000070000004FC3BD0048A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F01040000
GO
/****** Object:  Statistic [PK_Thaydoicongviec]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_Thaydoicongviec]([PK_Thaydoicongviec]) WITH STATS_STREAM = 0x01000000030000000000000000000000EDB9E7E8000000003B02000000000000CB01000000000000A7030000A70000000A0000000000000008D0003401000000380300003800000004000A00000000000000000000803F003D0300003D0000000800170300000000000000001800000007000000B6BEBD0048A0000001000000000000000100000000000000000000000000803F0000803F0000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000003000000100000000000B0410000803F0000000000002041000080400000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303031FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303031020000004000000000010A00000000, ROWCOUNT = 4, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_546180BB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_546180BB] ON [dbo].[PB_Thaydoiphongban]([Maphong]) WITH STATS_STREAM = 0x01000000010000000000000000000000A767530400000000BB010000000000007B0100000000000038030CF63800000004000A000000000000000000FFFFFFFF07000000A5D2890048A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F04000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_546180BB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_546180BB] ON [dbo].[PB_Thaydoiphongban]([Ngayapdung]) WITH STATS_STREAM = 0x01000000010000000000000000000000E46E3EDA000000004B020000000000000B020000000000003D0300003D00000008001703000000000000000000000000070000008B9B9B004EA000000500000000000000050000000000000000000000CDCC4C3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000050000000100000018000000000000410000A0400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000AF00000000000000280000000000000043000000000000005E0000000000000079000000000000009400000000000000100018000000803F000000000000803F0127880048A00000040000100018000000803F000000000000803F108A8E0048A00000040000100018000000803F000000000000803FE100900048A00000040000100018000000803F000000000000803F0D029C004BA00000040000100018000000803F000000000000803F385D9C004BA00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_546180BB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_546180BB] ON [dbo].[PB_Thaydoiphongban]([Nguoiky]) WITH STATS_STREAM = 0x010000000100000000000000000000000A926DFE000000003B02000000000000FB01000000000000E7020000E7000000500000000000000008D000343D000000070000008B9B9B004EA0000005000000000000000500000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000008420000A0400000000000000842000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000410000000000000097000000000000000800000000000000300010000000A040000000000000803F040000010039004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300FF0100000000000000050000000100000028000000280000000000000000000000110000004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300020000004000000000051100000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_546180BB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_546180BB] ON [dbo].[PB_Thaydoiphongban]([Chucvunguoiky]) WITH STATS_STREAM = 0x01000000010000000000000000000000C8F4B1D3000000002B02000000000000EB01000000000000E7020000E7000000640000000000000008D00034E7000000070000008B9B9B004EA0000005000000000000000500000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000D0410000A040000000000000D041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000390000000000000087000000000000000800000000000000300010000000A040000000000000803F040000010031005400D51E6E006700200067006900E1006D0020001101D11E6300FF01000000000000000500000001000000280000002800000000000000000000000D0000005400D51E6E006700200067006900E1006D0020001101D11E6300020000004000000000050D00000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_546180BB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000006_546180BB] ON [dbo].[PB_Thaydoiphongban]([Ngayky]) WITH STATS_STREAM = 0x01000000010000000000000000000000A491D936000000000502000000000000C5010000000000003D03B1F53D00000008001703000000000000000000000000070000008B9B9B004EA000000500000000000000050000000000000000000000ABAAAA3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000018000000000000410000A04000000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000006900000000000000180000000000000033000000000000004E000000000000001000180000004040000000000000803F0000000048A00000040000100018000000803F000000000000803F000000004AA00000040000100018000000803F000000000000803F000000004BA00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_546180BB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000007_546180BB] ON [dbo].[PB_Thaydoiphongban]([LyDo]) WITH STATS_STREAM = 0x010000000100000000000000000000008161D361000000000003000000000000C002000000000000E7030000E7000000C80000000000000008D0003400000000070000008B9B9B004EA000000500000000000000050000000000000000000000CDCC4C3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000050000000100000010000000000040410000A0400000000000004041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000D7000000000000005C0100000000000028000000000000004D000000000000006C000000000000008F00000000000000B400000000000000300010000000803F000000000000803F0400000100250042006F007300730020006D00E000300010000000803F000000000000803F04000001001F006400670073006400300010000000803F000000000000803F040000010023004D00DB1E690020006D00E000300010000000803F000000000000803F040000010025006D006F0069002000740061006F00300010000000803F000000000000803F040000010023004D00720020001001A11E7400FF01000000000000000500000005000000280000002800000000000000000000001C00000042006F007300730020006D00E00064006700730064004D00DB1E690020006D00E0006F0069002000740061006F00720020001001A11E74000700000040000000008107000000810407000040010B0000810611000081050C0000010517000000
GO
/****** Object:  Statistic [_WA_Sys_00000008_546180BB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000008_546180BB] ON [dbo].[PB_Thaydoiphongban]([GhiChu]) WITH STATS_STREAM = 0x01000000010000000000000000000000AC18385B000000003F02000000000000FF01000000000000E702B1F5E7000000C80000000000000008D0003400000000070000008B9B9B004EA00000050000000000000005000000000000000000803FABAAAA3E0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000200000001000000100000003333B3400000A040000000003333B34000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000046000000000000009B00000000000000100000000000000023000000000000001000100000004040000000000000803F040000300010000000803F0000803F0000803F04000001002300640066006700640073006600FF01000000000000000500000003000000280000002800000000000000000000000E000000610073006400660061007300640066006400660067006400730066000300000043000000008108000000010608000000
GO
/****** Object:  Statistic [_WA_Sys_00000009_546180BB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000009_546180BB] ON [dbo].[PB_Thaydoiphongban]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000B4A9176000000000C701000000000000870100000000000024030000240000001000000000000000000000000000000007000000909B9B004EA0000005000000000000000500000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000A04000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000A040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_546180BB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000A_546180BB] ON [dbo].[PB_Thaydoiphongban]([CreatedByDate]) WITH STATS_STREAM = 0x010000000100000000000000000000006A58E046000000004B020000000000000B020000000000003D0300003D0000000800170300000000000000000000000007000000909B9B004EA000000500000000000000050000000000000000000000CDCC4C3E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000050000000100000018000000000000410000A0400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000AF00000000000000280000000000000043000000000000005E0000000000000079000000000000009400000000000000100018000000803F000000000000803F0627880048A00000040000100018000000803F000000000000803F108A8E0048A00000040000100018000000803F000000000000803FE100900048A00000040000100018000000803F000000000000803F0D029C004BA00000040000100018000000803F000000000000803F385D9C004BA00000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_546180BB]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000B_546180BB] ON [dbo].[PB_Thaydoiphongban]([IsCurrent]) WITH STATS_STREAM = 0x01000000010000000000000000000000ABD6553900000000B8010000000000007801000000000000680300006800000001000100000000000000000000000000070000002F2C880048A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F01040000
GO
/****** Object:  Statistic [PK_Congviec]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_Thaydoiphongban]([PK_Congviec]) WITH STATS_STREAM = 0x01000000030000000000000000000000EFEDD4C7000000003B02000000000000CB01000000000000A7030000A70000000A0000000000000008D0003401000000380300003800000004000A000000000000000000AF0000003D0300003D0000000800170300000000000000005E000000070000002F2C880048A0000001000000000000000100000000000000000000000000803F0000803F0000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000003000000100000000000B0410000803F0000000000002041000080400000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000290000000000000067000000000000000800000000000000300010000000803F000000000000803F040000010021004E563030303030303031FF01000000000000000100000001000000280000002800000000000000000000000A0000004E563030303030303031020000004000000000010A00000000, ROWCOUNT = 9, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_30E33A54]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_30E33A54] ON [dbo].[PB_Thaydoitongsongaychamcong]([Ngayapdung]) WITH STATS_STREAM = 0x01000000010000000000000000000000EECB97A700000000BF010000000000007F010000000000003D03FFFF3D00000008001703000000000000000000000000070000004F9D2F0049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F011C2F0049A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_30E33A54]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_30E33A54] ON [dbo].[PB_Thaydoitongsongaychamcong]([Tongsongaychamcong]) WITH STATS_STREAM = 0x01000000010000000000000000000000D3D71E8A00000000B80100000000000078010000000000003003FFFF300000000100030000000000000000000000000007000000549D2F0049A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F1A040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_30E33A54]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_30E33A54] ON [dbo].[PB_Thaydoitongsongaychamcong]([Nguoiky]) WITH STATS_STREAM = 0x0100000001000000000000000000000090E8B0A1000000003B02000000000000FB01000000000000E7030000E7000000500000000000000008D0003400000000070000005D9D2F0049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000008420000803F0000000000000842000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000410000000000000097000000000000000800000000000000300010000000803F000000000000803F040000010039004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300FF0100000000000000010000000100000028000000280000000000000000000000110000004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300020000004000000000011100000000
GO
/****** Object:  Statistic [_WA_Sys_00000005_30E33A54]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_30E33A54] ON [dbo].[PB_Thaydoitongsongaychamcong]([Chucvunguoiky]) WITH STATS_STREAM = 0x010000000100000000000000000000007F7D95F5000000002B02000000000000EB01000000000000E7030000E7000000640000000000000008D00034E700000007000000629D2F0049A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000D0410000803F000000000000D041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000390000000000000087000000000000000800000000000000300010000000803F000000000000803F040000010031005400D51E6E006700200067006900E1006D0020001101D11E6300FF01000000000000000100000001000000280000002800000000000000000000000D0000005400D51E6E006700200067006900E1006D0020001101D11E6300020000004000000000010D00000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_30E33A54]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000006_30E33A54] ON [dbo].[PB_Thaydoitongsongaychamcong]([Ngayky]) WITH STATS_STREAM = 0x0100000001000000000000000000000045138AE200000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000000000000007000000629D2F0049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F0000000049A00000040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_30E33A54]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000007_30E33A54] ON [dbo].[PB_Thaydoitongsongaychamcong]([GhiChu]) WITH STATS_STREAM = 0x01000000010000000000000000000000F4E0B45000000000EE01000000000000AE01000000000000E7020000E7000000C80000000000000008D000340000000007000000629D2F0049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000000000000803F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000001B000000000000004A000000000000000800000000000000100010000000803F000000000000803F040000FF01000000000000000100000001000000280000002800000000000000000000000000000001000000010000000000
GO
/****** Object:  Statistic [_WA_Sys_00000008_30E33A54]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000008_30E33A54] ON [dbo].[PB_Thaydoitongsongaychamcong]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000C8D8584700000000C70100000000000087010000000000002403B1F5240000001000000000000000000000000000000007000000629D2F0049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000009_30E33A54]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000009_30E33A54] ON [dbo].[PB_Thaydoitongsongaychamcong]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000439948FA00000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000002400000007000000629D2F0049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803F011C2F0049A00000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_30E33A54]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000A_30E33A54] ON [dbo].[PB_Thaydoitongsongaychamcong]([IsCurrent]) WITH STATS_STREAM = 0x01000000010000000000000000000000C05031DF00000000B801000000000000780100000000000068030000680000000100010000000000000000002400000007000000621E2F0049A0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F01040000
GO
/****** Object:  Statistic [PK_Thaydoisongaychamcong]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_Thaydoitongsongaychamcong]([PK_Thaydoisongaychamcong]) WITH STATS_STREAM = 0x010000000100000000000000000000002EB2F75900000000C701000000000000870100000000000024030000240000001000000000000000000000000000000007000000051C2F0049A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803F00000000000000000000000000000000040000, ROWCOUNT = 1, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_0FB750B3]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_0FB750B3] ON [dbo].[PB_ToNhom]([Maphong]) WITH STATS_STREAM = 0x010000000100000000000000000000007E8D76EA00000000BB010000000000007B010000000000003803FFFF3800000004000A0000000000000000000000000007000000A2990D0146A0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000004000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F0000000000000008000000000000001000140000000040000000000000803F02000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000003_0FB750B3]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_0FB750B3] ON [dbo].[PB_ToNhom]([TenToNhom]) WITH STATS_STREAM = 0x01000000010000000000000000000000CEF89827000000008A020000000000004A02000000000000E7020040E7000000640000000000000008D000340000000007000000A2990D0146A0000002000000000000000200000000000000000000000000003F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000200000001000000100000000000E04100000040000000000000E0410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000007600000000000000E60000000000000010000000000000004500000000000000300010000000803F000000000000803F040000010035005400D51E200070006800E100740020007400A11E6D002000E91E6E006700300010000000803F000000000000803F040000010031005400D51E20007400ED006E00680020006C00B001A1016E006700FF0100000000000000020000000200000028000000280000000000000000000000190000005400D51E200070006800E100740020007400A11E6D002000E91E6E0067007400ED006E00680020006C00B001A1016E0067000400000040000000004003000000810C030000010A0F000000
GO
/****** Object:  Statistic [_WA_Sys_00000004_0FB750B3]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_0FB750B3] ON [dbo].[PB_ToNhom]([Tongsonhanvien]) WITH STATS_STREAM = 0x01000000010000000000000000000000976985E500000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000100000007000000A2990D0146A0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000004000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F0000000000000008000000000000001000140000000040000000000000803F00000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_0FB750B3]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_0FB750B3] ON [dbo].[PB_ToNhom]([GhiChu]) WITH STATS_STREAM = 0x0100000001000000000000000000000083591B8F00000000EE01000000000000AE01000000000000E7020000E7000000C80000000000000008D000340000000007000000A2990D0146A0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000001B000000000000004A0000000000000008000000000000001000100000000040000000000000803F040000FF01000000000000000200000001000000280000002800000000000000000000000000000001000000020000000000
GO
/****** Object:  Statistic [_WA_Sys_00000006_0FB750B3]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000006_0FB750B3] ON [dbo].[PB_ToNhom]([CreatedByUser]) WITH STATS_STREAM = 0x0100000001000000000000000000000074EA694100000000C70100000000000087010000000000002403B1F5240000001000000000000000000000000000000007000000A6990D0146A0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000004000000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B0000000000000008000000000000001000200000000040000000000000803FC783DBF06479504BB7C62D3271DE4AB5040000
GO
/****** Object:  Statistic [_WA_Sys_00000007_0FB750B3]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000007_0FB750B3] ON [dbo].[PB_ToNhom]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000DA19EB9600000000E201000000000000A2010000000000003D0300003D0000000800170300000000000000000000000007000000AB990D0146A0000002000000000000000200000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000002000000010000001800000000000041000000400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000460000000000000010000000000000002B00000000000000100018000000803F000000000000803F988E0A0146A00000040000100018000000803F000000000000803F6FBB0A0146A00000040000
GO
/****** Object:  Statistic [PK_ToNhom]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[PB_ToNhom]([PK_ToNhom]) WITH STATS_STREAM = 0x0100000001000000000000000000000035F7A07100000000BB010000000000007B01000000000000380300003800000004000A00000000000000000000000000070000009C8E0A0146A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 3, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_3EC74557]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_3EC74557] ON [dbo].[SYS_Chucnang]([Name]) WITH STATS_STREAM = 0x0100000001000000000000000000000056AEED71000000001702000000000000D701000000000000E7030000E7000000640000000000000008D000340100000007000000D143E9004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000002F0000000000000073000000000000000800000000000000300010000000803F000000000000803F040000010027004800C71E200074006800D11E6E006700FF0100000000000000010000000100000028000000280000000000000000000000080000004800C71E200074006800D11E6E006700020000004000000000010800000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_3EC74557]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_3EC74557] ON [dbo].[SYS_Chucnang]([Description]) WITH STATS_STREAM = 0x01000000010000000000000000000000EAF8DDDA0000000047020000000000000702000000000000E7020000E7000000FE0100000000000008D000340000000007000000D643E9004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000020420000803F00000000000020420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000004700000000000000A3000000000000000800000000000000300010000000803F000000000000803F04000001003F00100103016E00670020006E006800AD1E70002C002000100103016E006700200078007500A51E7400FF010000000000000001000000010000002800000028000000000000000000000014000000100103016E00670020006E006800AD1E70002C002000100103016E006700200078007500A51E7400020000004000000000011400000000
GO
/****** Object:  Statistic [PK_SYS_Chucnang]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[SYS_Chucnang]([PK_SYS_Chucnang]) WITH STATS_STREAM = 0x010000000100000000000000000000005F09EB3E00000000F901000000000000B901000000000000380300343800000004000A0000000000000000000100000007000000885EEA004EA00000040000000000000004000000000000000000803F0000803E000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000030000000100000014000000000080400000804000000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000005D0000000000000018000000000000002F000000000000004600000000000000100014000000803F000000000000803F01000000040000100014000000803F0000803F0000803F03000000040000100014000000803F000000000000803F04000000040000, ROWCOUNT = 56, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_40AF8DC9]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_40AF8DC9] ON [dbo].[SYS_Hanhdong]([ActivityName]) WITH STATS_STREAM = 0x010000000100000000000000000000003BBD41E4000000000302000000000000C301000000000000E702B1F5E7000000640000000000000008D00034E70000000700000008ABEF004EA0000002000000000000000200000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000001000000010000001000000000004040000000400000803F0000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000025000000000000005F000000000000000800000000000000300010000000803F000000000000803F04000001001D00580065006D00FF010000000100000002000000020000002800000028000000000000000000000003000000580065006D00020000004000000000010300000000
GO
/****** Object:  Statistic [PK_SYS_Hanhdong]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[SYS_Hanhdong]([PK_SYS_Hanhdong]) WITH STATS_STREAM = 0x010000000100000000000000000000007087C8B700000000BB010000000000007B01000000000000380300343800000004000A00000000000000000002000000070000001B9EEF004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 8, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000003_5F3414E9]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_5F3414E9] ON [dbo].[SYS_IndexPage]([CreatedByUser]) WITH STATS_STREAM = 0x01000000010000000000000000000000125D411200000000C70100000000000087010000000000002403B1F5240000001000000000000000000000000000000007000000B889C30054A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FE462C85681267D4BA0D2A6FB4F4257F8040000
GO
/****** Object:  Statistic [_WA_Sys_00000004_5F3414E9]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_5F3414E9] ON [dbo].[SYS_IndexPage]([CreatedByDate]) WITH STATS_STREAM = 0x010000000100000000000000000000001493C08100000000BF010000000000007F010000000000003D0300003D0000000800170300000000000000002400000007000000C189C30054A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000018000000000000410000803F000000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000023000000000000000800000000000000100018000000803F000000000000803FC36DC20054A00000040000
GO
/****** Object:  Statistic [PK_SYS_IndexPage]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[SYS_IndexPage]([PK_SYS_IndexPage]) WITH STATS_STREAM = 0x01000000010000000000000000000000B0D92E6800000000BB010000000000007B01000000000000380300003800000004000A0000000000000000000000000007000000B889C30054A0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000014000000000080400000803F00000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001F000000000000000800000000000000100014000000803F000000000000803F01000000040000, ROWCOUNT = 1, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_3726238F] ON [dbo].[SYS_Nguoidung]([Username]) WITH STATS_STREAM = 0x010000000100000000000000000000000329305A000000001F02000000000000DF01000000000000A7030000A70000001E0000000000000008D000340000000007000000C11BED004EA0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000A0410000803F000000000000A04100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000033000000000000007B000000000000000800000000000000300010000000803F000000000000803F04000001002B0061646D696E6E677579656E7068756F6E67626163FF01000000000000000100000001000000280000002800000000000000000000001400000061646D696E6E677579656E7068756F6E67626163020000004000000000011400000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_3726238F] ON [dbo].[SYS_Nguoidung]([Password]) WITH STATS_STREAM = 0x010000000100000000000000000000001A85F64400000000D5010000000000009501000000000000A5030A02A50000003200000000000000000000000000000007000000071CED004EA0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000100000000000D0410000803F000000000000D04100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000039000000000000000800000000000000300010000000803F000000000000803F0400000100310001000453E32FE8792E244C37F47E2AC66DCAA345FD3015C0A531
GO
/****** Object:  Statistic [_WA_Sys_00000004_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_3726238F] ON [dbo].[SYS_Nguoidung]([IsRequireResetPass]) WITH STATS_STREAM = 0x01000000010000000000000000000000237F4C6000000000B80100000000000078010000000000006803B1F5680000000100010000000000000000000000000007000000C11BED004EA0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F00040000
GO
/****** Object:  Statistic [_WA_Sys_00000005_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_3726238F] ON [dbo].[SYS_Nguoidung]([CodeResetPassForget]) WITH STATS_STREAM = 0x01000000010000000000000000000000119BB2FA00000000C7010000000000008701000000000000240300002400000010000000000000000000000001000000070000001A1CED004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803F395D7DCEF2AFBC40994E9C7BA3481748040000
GO
/****** Object:  Statistic [_WA_Sys_00000006_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000006_3726238F] ON [dbo].[SYS_Nguoidung]([Email]) WITH STATS_STREAM = 0x0100000001000000000000000000000048B91E0F0000000073020000000000003302000000000000E7030000E7000000640000000000000008D0003401000000070000005C90DF004FA0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000078420000004000000000000078420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000005D00000000000000CF0000000000000008000000000000003000100000000040000000000000803F040000010055006B00350063006E00740074006E0067007500790065006E007000680075006F006E006700620061006300400067006D00610069006C002E0063006F006D00FF01000000000000000200000001000000280000002800000000000000000000001F0000006B00350063006E00740074006E0067007500790065006E007000680075006F006E006700620061006300400067006D00610069006C002E0063006F006D00020000004000000000021F00000000
GO
/****** Object:  Statistic [_WA_Sys_00000007_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000007_3726238F] ON [dbo].[SYS_Nguoidung]([Fullname]) WITH STATS_STREAM = 0x010000000100000000000000000000008B370A62000000003B02000000000000FB01000000000000E7030A02E7000000640000000000000008D0003400000000070000005C90DF004FA0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000010000000000008420000004000000000000008420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000004100000000000000970000000000000008000000000000003000100000000040000000000000803F040000010039004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300FF0100000000000000020000000100000028000000280000000000000000000000110000004E00670075007900C51E6E00200050006800B001A1016E00670020004200AF1E6300020000004000000000021100000000
GO
/****** Object:  Statistic [_WA_Sys_00000008_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000008_3726238F] ON [dbo].[SYS_Nguoidung]([NumberOfLogin]) WITH STATS_STREAM = 0x010000000100000000000000000000005BF4E6B000000000E201000000000000A2010000000000007F03B1F57F00000008001300000000000000000000000000070000006590DF004FA0000002000000000000000200000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000002000000010000001800000000000041000000400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000460000000000000010000000000000002B00000000000000100018000000803F000000000000803F0000000000000000040000100018000000803F000000000000803F1A00000000000000040000
GO
/****** Object:  Statistic [_WA_Sys_00000009_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000009_3726238F] ON [dbo].[SYS_Nguoidung]([LaterLogin]) WITH STATS_STREAM = 0x01000000010000000000000000000000B326CCAE00000000E201000000000000A2010000000000003D03B1F53D00000008001703000000000000000000000000070000006590DF004FA0000002000000000000000200000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000002000000010000001800000000000041000000400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000460000000000000010000000000000002B00000000000000100018000000803F000000000000803F7270D2004FA00000040000100018000000803F000000000000803F1686DF004FA00000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000A_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000A_3726238F] ON [dbo].[SYS_Nguoidung]([IsLock]) WITH STATS_STREAM = 0x01000000010000000000000000000000C5B51BFA00000000B801000000000000780100000000000068030000680000000100010000000000000000000100000007000000111CED004EA0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F00040000
GO
/****** Object:  Statistic [_WA_Sys_0000000B_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000B_3726238F] ON [dbo].[SYS_Nguoidung]([IsDelete]) WITH STATS_STREAM = 0x01000000010000000000000000000000BDC706CA00000000B801000000000000780100000000000068030000680000000100010000000000000000000100000007000000B1E1ED004EA0000001000000000000000100000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F0000803F000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C000000000000000800000000000000100011000000803F000000000000803F00040000
GO
/****** Object:  Statistic [_WA_Sys_0000000C_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000C_3726238F] ON [dbo].[SYS_Nguoidung]([IsSuper]) WITH STATS_STREAM = 0x0100000001000000000000000000000091034A0E00000000B8010000000000007801000000000000680300006800000001000100000000000000000001000000070000006590DF004FA0000002000000000000000200000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000110000000000803F00000040000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000001C0000000000000008000000000000001000110000000040000000000000803F01040000
GO
/****** Object:  Statistic [_WA_Sys_0000000D_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000D_3726238F] ON [dbo].[SYS_Nguoidung]([CreatedByUser]) WITH STATS_STREAM = 0x0100000001000000000000000000000068B2AB7C0000000067020000000000002702000000000000A7030000A7000000FF0000000000000008D0003401000000070000007390DF004FA0000002000000000000000200000000000000000000000000003F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000020000000100000010000000000098410000004000000000000098410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000006400000000000000C30000000000000010000000000000002900000000000000300010000000803F000000000000803F040000010019002D31300010000000803F000000000000803F04000001003B0035366338363265342D323638312D346237642D613064322D613666623466343235376638FF0100000000000000020000000200000028000000280000000000000000000000260000002D3135366338363265342D323638312D346237642D613064322D6136666234663432353766380300000040000000008102000000012402000000
GO
/****** Object:  Statistic [_WA_Sys_0000000E_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000E_3726238F] ON [dbo].[SYS_Nguoidung]([CreatedByDate]) WITH STATS_STREAM = 0x01000000010000000000000000000000FB13F5D900000000E201000000000000A2010000000000003D0300003D0000000800170300000000000000007F000000070000007D90DF004FA0000002000000000000000200000000000000000000000000003F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000002000000010000001800000000000041000000400000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000460000000000000010000000000000002B00000000000000100018000000803F000000000000803F617CEC004EA00000040000100018000000803F000000000000803F7270D2004FA00000040000
GO
/****** Object:  Statistic [_WA_Sys_0000000F_3726238F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_0000000F_3726238F] ON [dbo].[SYS_Nguoidung]([GhiChu]) WITH STATS_STREAM = 0x01000000010000000000000000000000157F68CC00000000CB010000000000008B01000000000000E702B1F5E7000000C80000000000000008D0003400000000070000007D90DF004FA0000002000000000000000200000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000010000000000000000000004000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000002F00000000000000FF01000000020000000200000001000000280000002800000000000000000000000000000001000000000000000000
GO
/****** Object:  Statistic [PK_User]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[SYS_Nguoidung]([PK_User]) WITH STATS_STREAM = 0x010000000100000000000000000000008604F2B600000000C7010000000000008701000000000000240300002400000010000000000000000000000000000000070000009006FC004EA0000001000000000000000100000000000000000000000000803F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000100000020000000000080410000803F00000000000080410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B000000000000000800000000000000100020000000803F000000000000803FE462C85681267D4BA0D2A6FB4F4257F8040000, ROWCOUNT = 8, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_4668671F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_4668671F] ON [dbo].[SYS_Nhatkyhethong]([Thoigian]) WITH STATS_STREAM = 0x010000000100000000000000000000009B8CEC6F00000000CC1C0000000000008C1C0000000000003D0300003D0000000800170300000000000000000100000007000000A2CCDA0060A00000EE05000000000000EE050000000000000000803FBDB02C3A0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000C0000000C000000001000000180000000000004100C0BD440000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000000000000000000000000000401A000000000000281B00000000000000060000000000001B06000000000000360600000000000051060000000000006C060000000000008706000000000000A206000000000000BD06000000000000D806000000000000F3060000000000000E07000000000000290700000000000044070000000000005F070000000000007A070000000000009507000000000000B007000000000000CB07000000000000E60700000000000001080000000000001C08000000000000370800000000000052080000000000006D080000000000008808000000000000A308000000000000BE08000000000000D908000000000000F4080000000000000F090000000000002A09000000000000450900000000000060090000000000007B090000000000009609000000000000B109000000000000CC09000000000000E709000000000000020A0000000000001D0A000000000000380A000000000000530A0000000000006E0A000000000000890A000000000000A40A000000000000BF0A000000000000DA0A000000000000F50A000000000000100B0000000000002B0B000000000000460B000000000000610B0000000000007C0B000000000000970B000000000000B20B000000000000CD0B000000000000E80B000000000000030C0000000000001E0C000000000000390C000000000000540C0000000000006F0C0000000000008A0C000000000000A50C000000000000C00C000000000000DB0C000000000000F60C000000000000110D0000000000002C0D000000000000470D000000000000620D0000000000007D0D000000000000980D000000000000B30D000000000000CE0D000000000000E90D000000000000040E0000000000001F0E0000000000003A0E000000000000550E000000000000700E0000000000008B0E000000000000A60E000000000000C10E000000000000DC0E000000000000F70E000000000000120F0000000000002D0F000000000000480F000000000000630F0000000000007E0F000000000000990F000000000000B40F000000000000CF0F000000000000EA0F000000000000051000000000000020100000000000003B10000000000000561000000000000071100000000000008C10000000000000A710000000000000C210000000000000DD10000000000000F81000000000000013110000000000002E11000000000000491100000000000064110000000000007F110000000000009A11000000000000B511000000000000D011000000000000EB11000000000000061200000000000021120000000000003C12000000000000571200000000000072120000000000008D12000000000000A812000000000000C312000000000000DE12000000000000F91200000000000014130000000000002F130000000000004A13000000000000651300000000000080130000000000009B13000000000000B613000000000000D113000000000000EC13000000000000071400000000000022140000000000003D14000000000000581400000000000073140000000000008E14000000000000A914000000000000C414000000000000DF14000000000000FA14000000000000151500000000000030150000000000004B15000000000000661500000000000081150000000000009C15000000000000B715000000000000D215000000000000ED15000000000000081600000000000023160000000000003E16000000000000591600000000000074160000000000008F16000000000000AA16000000000000C516000000000000E016000000000000FB16000000000000161700000000000031170000000000004C17000000000000671700000000000082170000000000009D17000000000000B817000000000000D317000000000000EE17000000000000091800000000000024180000000000003F180000000000005A1800000000000075180000000000009018000000000000AB18000000000000C618000000000000E118000000000000FC18000000000000171900000000000032190000000000004D19000000000000681900000000000083190000000000009E19000000000000B919000000000000D419000000000000EF190000000000000A1A000000000000251A000000000000100018000000803F000000000000803FEE39390152A00000040000100018000000803F000000400000803FB46C390152A00000040000100018000000803F0000E0400000803F18BE390152A00000040000100018000000803F0000E0400000803F2E873D0152A00000040000100018000000803F0000E0400000803FCA7B400152A00000040000100018000000803F000040400000803FB3D8400152A00000040000100018000000803F0000E0400000803F744E420152A00000040000100018000000803F0000E0400000803FA7C7430152A00000040000100018000000803F000040400000803F4E84440152A00000040000100018000000803F0000E0400000803FE154450152A00000040000100018000000803F0000E0400000803F0592450152A00000040000100018000000803F0000E0400000803F8696460152A00000040000100018000000803F0000E0400000803FB0CF460152A00000040000100018000000803F0000E0400000803F9DFB500152A00000040000100018000000803F0000E0400000803F5095530152A00000040000100018000000803F0000A0400000803FF4A7530152A00000040000100018000000803F0000A0400000803FB8EE540152A00000040000100018000000803F0000E0400000803FF87B550152A00000040000100018000000803F000040400000803F4D9E550152A00000040000100018000000803F0000E0400000803F09B4550152A00000040000100018000000803F0000E0400000803FD81C600152A00000040000100018000000803F0000E0400000803F39E6600152A00000040000100018000000803F0000A0400000803F17BC610152A00000040000100018000000803F0000A0400000803F0F34630152A00000040000100018000000803F000070410000803F16C6650152A00000040000100018000000803F0000E0400000803FC2856E0152A00000040000100018000000803F000010410000803FE8FF6E0152A00000040000100018000000803F0000E0400000803FEAE6870053A00000040000100018000000803F0000E0400000803F1872880053A00000040000100018000000803F0000E0400000803F3FF08C0053A00000040000100018000000803F0000E0400000803FCE0B8E0053A00000040000100018000000803F0000E0400000803F0C438F0053A00000040000100018000000803F0000E0400000803FF3B6980053A00000040000100018000000803F0000A0400000803FA3519B0053A00000040000100018000000803F0000E0400000803F4365AC0053A00000040000100018000000803F000040400000803F8C6FC40053A00000040000100018000000803F000010410000803FB749D00053A00000040000100018000000803F0000A0400000803F7C4DDC0053A00000040000100018000000803F0000E0400000803F00CBE50053A00000040000100018000000803F000040400000803F4FA4E70053A00000040000100018000000803F0000E0400000803F2169EF0053A00000040000100018000000803F0000E0400000803FC18BF00053A00000040000100018000000803F0000A0400000803F29A4F00053A00000040000100018000000803F0000E0400000803F3752070153A00000040000100018000000803F0000A0400000803FE13B080153A00000040000100018000000803F000010410000803F2055090153A00000040000100018000000803F0000E0400000803F62BA090153A00000040000100018000000803F000010410000803FBBB50B0153A00000040000100018000000803F0000E0400000803F0C710D0153A00000040000100018000000803F0000E0400000803F82DB0D0153A00000040000100018000000803F0000E0400000803F9AF80D0153A00000040000100018000000803F000010410000803F5711100153A00000040000100018000000803F0000D8410000803F1A57140153A00000040000100018000000803F0000E0400000803F2EB5140153A00000040000100018000000803F000030410000803F8C36170153A00000040000100018000000803F0000E0400000803F0A49180153A00000040000100018000000803F000030410000803F7C90190153A00000040000100018000000803F000040400000803F87BA190153A00000040000100018000000803F0000E0400000803F87E9190153A00000040000100018000000803F000030410000803FCA681A0153A00000040000100018000000803F0000E0400000803F11D11A0153A00000040000100018000000803F000040400000803FFDD6850054A00000040000100018000000803F0000E0400000803FE411870054A00000040000100018000000803F0000E0400000803FF884930054A00000040000100018000000803F000040400000803FB095930054A00000040000100018000000803F0000E0400000803F0F20960054A00000040000100018000000803F0000E0400000803F71A6970054A00000040000100018000000803F0000E0400000803F474C980054A00000040000100018000000803F0000E0400000803F66A3980054A00000040000100018000000803F0000E0400000803F51A49A0054A00000040000100018000000803F0000E0400000803FB7C59A0054A00000040000100018000000803F000030410000803F26AE9B0054A00000040000100018000000803F0000E0400000803F13C59B0054A00000040000100018000000803F0000E0400000803F94FD9B0054A00000040000100018000000803F0000E0400000803F2C239C0054A00000040000100018000000803F0000E0400000803F1801A00054A00000040000100018000000803F0000E0400000803F8564A00054A00000040000100018000000803F0000E0400000803F7E0BA60054A00000040000100018000000803F000040400000803F146EA60054A00000040000100018000000803F0000E0400000803F6CA4A60054A00000040000100018000000803F000040400000803F2E49AC0054A00000040000100018000000803F0000E0400000803FDE86AC0054A00000040000100018000000803F0000E0400000803F889AAC0054A00000040000100018000000803F0000E0400000803FC9C0AC0054A00000040000100018000000803F0000E0400000803FC3E6AC0054A00000040000100018000000803F0000E0400000803FDC01AD0054A00000040000100018000000803F0000E0400000803F7362AD0054A00000040000100018000000803F000040400000803FDC3DBA0054A00000040000100018000000803F0000E0400000803FE9B6C30054A00000040000100018000000803F000040400000803F29E5C30054A00000040000100018000000803F0000E0400000803F9907DE0054A00000040000100018000000803F0000E0400000803FEA5DE10054A00000040000100018000000803F000040400000803FBECEE70054A00000040000100018000000803F0000E0400000803F31BCEF0054A00000040000100018000000803F0000E0400000803F3EFCEF0054A00000040000100018000000803F000040400000803F4EA3F50054A00000040000100018000000803F0000E0400000803FA0D6050154A00000040000100018000000803F000040400000803F15DC050154A00000040000100018000000803F0000E0400000803F14EB050154A00000040000100018000000803F000050410000803F5F1C060154A00000040000100018000000803F0000A0400000803F3C8F060154A00000040000100018000000803F0000A0400000803F0AE8070154A00000040000100018000000803F000030410000803FB1BE080154A00000040000100018000000803F0000A0400000803F5B39090154A00000040000100018000000803F0000A0400000803FBE7F090154A00000040000100018000000803F0000A0400000803F90E20A0154A00000040000100018000000803F0000A0400000803FA6220B0154A00000040000100018000000803F0000A0400000803F64840B0154A00000040000100018000000803F0000A0400000803F914F0C0154A00000040000100018000000803F0000A0400000803FFA6A0C0154A00000040000100018000000803F0000A0400000803F83E80C0154A00000040000100018000000803F0000A0400000803F4ABE0D0154A00000040000100018000000803F0000A0400000803F06150E0154A00000040000100018000000803F000070410000803F9C770F0154A00000040000100018000000803F0000E0400000803F89C7160154A00000040000100018000000803F0000E0400000803F8E67B90055A00000040000100018000000803F0000E0400000803F3701BF0055A00000040000100018000000803F0000E0400000803FC459C00055A00000040000100018000000803F0000E0400000803F6AAAEC0055A00000040000100018000000803F0000E0400000803FA1AFEE0055A00000040000100018000000803F0000E0400000803FB314B60057A00000040000100018000000803F0000E0400000803F790EBB0057A00000040000100018000000803F0000E0400000803F58028F0058A00000040000100018000000803F0000E0400000803F87D49C0058A00000040000100018000000803F0000E0400000803F1E7EED0058A00000040000100018000000803F0000E0400000803F56D7180158A00000040000100018000000803F0000E0400000803F4E9EAF0059A00000040000100018000000803F0000E0400000803F0BBAB10059A00000040000100018000000803F0000E0400000803FBAA8E50059A00000040000100018000000803F0000E0400000803FBDBC8A005AA00000040000100018000000803F0000E0400000803FAD288E005AA00000040000100018000000803F0000E0400000803F9E328F005AA00000040000100018000000803F0000E0400000803FDE778F005AA00000040000100018000000803F0000E0400000803FE58A8F005AA00000040000100018000000803F0000E0400000803F84E69D005AA00000040000100018000000803F0000E0400000803FE579AD005AA00000040000100018000000803F0000E0400000803FCEADAE005AA00000040000100018000000803F0000E0400000803F97D2B1005AA00000040000100018000000803F0000E0400000803FEBECB1005AA00000040000100018000000803F0000E0400000803F635BB4005AA00000040000100018000000803F0000E0400000803F8EE7B9005AA00000040000100018000000803F0000E0400000803F0848C1005AA00000040000100018000000803F0000E0400000803FD954C2005AA00000040000100018000000803F0000E0400000803FC5F9C2005AA00000040000100018000000803F0000E0400000803FED672F015BA00000040000100018000000803F0000E0400000803F5E3430015BA00000040000100018000000803F0000E0400000803F9E8130015BA00000040000100018000000803F0000E0400000803FF8BC5C015BA00000040000100018000000803F0000E0400000803F9F5F61015BA00000040000100018000000803F0000E0400000803F84BD62015BA00000040000100018000000803F0000E0400000803FF93464015BA00000040000100018000000803F0000E0400000803F2CF466015BA00000040000100018000000803F0000E0400000803FBDB867015BA00000040000100018000000803F0000E0400000803FA96A6C015BA00000040000100018000000803F0000E0400000803F0A52FF005CA00000040000100018000000803F0000E0400000803FAB7FFF005CA00000040000100018000000803F0000E0400000803F3A1F09015CA00000040000100018000000803F0000E0400000803F4FD813015CA00000040000100018000000803F0000E0400000803F6CAA59015CA00000040000100018000000803F0000E0400000803F23ED72015CA00000040000100018000000803F000070410000803F3AB907005DA00000040000100018000000803F0000E0400000803F8D9FA6005DA00000040000100018000000803F0000E0400000803F51AAA9005DA00000040000100018000000803F0000E0400000803FEE41AB005DA00000040000100018000000803F0000E0400000803F45C0AE005DA00000040000100018000000803F0000E0400000803F3ED6AF005DA00000040000100018000000803F0000E0400000803FBF4CB8005DA00000040000100018000000803F0000E0400000803F752BBC005DA00000040000100018000000803F0000E0400000803F1DFDC0005DA00000040000100018000000803F0000E0400000803F2789C3005DA00000040000100018000000803F0000E0400000803F6D94D7005DA00000040000100018000000803F0000E0400000803F90BFDD005DA00000040000100018000000803F0000E0400000803F0D1CE1005DA00000040000100018000000803F0000E0400000803F50F2F9005DA00000040000100018000000803F0000E0400000803F9D27FD005DA00000040000100018000000803F0000E0400000803F36C500015DA00000040000100018000000803F0000E0400000803F1B1299005EA00000040000100018000000803F0000E0400000803FBFD499005EA00000040000100018000000803F0000E0400000803FCB699A005EA00000040000100018000000803F0000E0400000803F8284AD005EA00000040000100018000000803F0000E0400000803F882A82015EA00000040000100018000000803F0000E0400000803F5C50F2005FA00000040000100018000000803F000010410000803FDDE0F2005FA00000040000100018000000803F000010410000803FD0C4F7005FA00000040000100018000000803F000010410000803FCB5AFA005FA00000040000100018000000803F000010410000803F5FD19D0060A00000040000100018000000803F000010410000803F3B75B10060A00000040000100018000000803F000010410000803F747AB20060A00000040000100018000000803F000010410000803F7B10CF0060A00000040000100018000000803F000030410000803FBE56DA0060A00000040000100018000000803F000020410000803FABC6DA0060A00000040000100018000000803F000000000000803FADC8DA0060A0000004000003000000E34F80015EA0000000000000000C9640AA09000000000000C1000000000000A02639473FE10D77E217745B4000000000000000000000000000B88A40000000000060874059FFE84FE6F9D23F6335AD0054A000000000000000308540E606000000000000BD000000000000004A2A583FF4164137F1EB86400000000000000000000000000084864000000000000029C0AE8D0305E67AE83F68C3390152A00000000000000000284043040000000000000B000000000000605555B53F0000000000D0844000000000000000000000000000F484400000000000001240D45F13A73D29F13F
GO
/****** Object:  Statistic [_WA_Sys_00000003_4668671F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_4668671F] ON [dbo].[SYS_Nhatkyhethong]([Chucnang]) WITH STATS_STREAM = 0x01000000010000000000000000000000293A3BAB00000000D1050000000000009105000000000000380300003800000004000A0000000000000000000100000007000000A7CCDA0060A00000EE05000000000000EE050000000000000000000026B4173D00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001B0000001B00000001000000140000000000804000C0BD44000000000000804000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000900000000000000000000000000000045030000000000002D04000000000000D800000000000000EF0000000000000006010000000000001D0100000000000034010000000000004B01000000000000620100000000000079010000000000009001000000000000A701000000000000BE01000000000000D501000000000000EC0100000000000003020000000000001A02000000000000310200000000000048020000000000005F0200000000000076020000000000008D02000000000000A402000000000000BB02000000000000D202000000000000E902000000000000000300000000000017030000000000002E030000000000001000140000800144000000000000803F010000000400001000140000009242000000000000803F020000000400001000140000004442000000000000803F030000000400001000140000002F43000000000000803F05000000040000100014000000E040000000000000803F060000000400001000140000005842000000000000803F07000000040000100014000000803F000000000000803F0C0000000400001000140000005042000000000000803F0E0000000400001000140000004041000000000000803F0F000000040000100014000000C841000000000000803F100000000400001000140000002041000000000000803F110000000400001000140000000943000000000000803F12000000040000100014000000A040000000000000803F13000000040000100014000000803F000000000000803F140000000400001000140000008642000000000000803F160000000400001000140000002041000000000000803F18000000040000100014000000C040000000000000803F1A0000000400001000140000001042000000000000803F1F000000040000100014000000803F000000000000803F20000000040000100014000000C041000000000000803F210000000400001000140000009841000000000000803F230000000400001000140000006842000000000000803F250000000400001000140000007842000000000000803F26000000040000100014000000D041000000000000803F290000000400001000140000006C42000000000000803F2A000000040000100014000000E041000000000000803F2B0000000400001000140000004040000000000000803F380000000400000300000039D8F9005FA000000000000000AC9640D2090000000000001B000000000000C084F6A23F00000000000000000000000000000000000000000078894000000000006087409754E03DEFEFA33F6335AD0054A000000000000000308540E60600000000000014000000000000A09999A93F000000000000084000000000000000000000000000C4874000000000000029C02024C739C43CDD3F6CC3390152A000000000000000002840430400000000000006000000000000605555C53F00000000000000000000000000004E400000000000F484400000000000001240F190BDF56769FD3F
GO
/****** Object:  Statistic [_WA_Sys_00000004_4668671F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000004_4668671F] ON [dbo].[SYS_Nhatkyhethong]([Hanhdong]) WITH STATS_STREAM = 0x01000000010000000000000000000000D07F6B520000000046030000000000000603000000000000380314003800000004000A0000000000000000000400001007000000A7CCDA0060A00000EE05000000000000EE0500000000000000000000ABAA2A3E0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000600000001000000140000000000804000C0BD440000000000008040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000000000000000000000000000BA00000000000000A201000000000000300000000000000047000000000000005E0000000000000075000000000000008C00000000000000A3000000000000001000140000007043000000000000803F010000000400001000140000008B43000000000000803F020000000400001000140000C07144000000000000803F050000000400001000140000006041000000000000803F060000000400001000140000008841000000000000803F070000000400001000140000000040000000000000803F080000000400000300000042D8F9005FA000000000000000AC9640D20900000000000006000000000000605555C53F0000000000000000000000000000000000000000007889400000000000608740C91740859FD68E3F6335AD0054A000000000000000308540E60600000000000006000000000000605555C53F000000000000000000000000000000000000000000C4874000000000000029C0113D633426EEB13F6CC3390152A000000000000000002840430400000000000002000000000000000000E03F000000000000000000000000009881400000000000F48440000000000000124095F19EC4978EF53F
GO
/****** Object:  Statistic [_WA_Sys_00000005_4668671F]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000005_4668671F] ON [dbo].[SYS_Nhatkyhethong]([Doituong]) WITH STATS_STREAM = 0x01000000010000000000000000000000045418D400000000CB010000000000008B01000000000000E7020000E7000000FE0100000000000008D000340000000007000000C3226B0050A0000033000000000000003300000000000000000000000000803F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000100000000000000000004C4200004C42000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000002F00000000000000FF010000000C0000000C00000001000000280000002800000000000000000000000000000001000000000000000000
GO
/****** Object:  Statistic [PK_SYS_Nhatkyhethong]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[SYS_Nhatkyhethong]([PK_SYS_Nhatkyhethong]) WITH STATS_STREAM = 0x01000000040000000000000000000000BC439FE50000000090020000000000000802000000000000A703666DA70000001E0000000000000008D00034FE0700003D0300003D00000008001703000000000000000001000000380300003800000004000A000000000000000000000000003803B1F53800000004000A00000000000000000001000000070000001854A90050A0000002000000000000000200000000000000000000000000003F0000003F0000003F0000003F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000200000004000000100000000000E4410000004000000000000048410000004100008040000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000005700000000000000A40000000000000010000000000000002C00000000000000300010000000803F000000000000803F04000001001C0061646D696E300010000000803F000000000000803F04000001002B0061646D696E6E677579656E7068756F6E67626163FF01000000000000000200000002000000280000002800000000000000000000001400000061646D696E6E677579656E7068756F6E676261630300000040000000004105000000010F05000000, ROWCOUNT = 1636, PAGECOUNT = 15
GO
/****** Object:  Statistic [_WA_Sys_00000002_4A38F803]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_4A38F803] ON [dbo].[SYS_PhanQuyen]([RollID]) WITH STATS_STREAM = 0x01000000010000000000000000000000A0F345C100000000560200000000000016020000000000003803B1F53800000004000A0000000000000000000000000007000000CFF500014FA000000B000000000000000B000000000000000000803F8C2EBA3D00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000006000000010000001400000000008040000030410000000000008040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000BA00000000000000300000000000000047000000000000005E0000000000000075000000000000008C00000000000000A300000000000000100014000000803F000000000000803F01000000040000100014000000803F0000803F0000803F03000000040000100014000000803F0000803F0000803F05000000040000100014000000803F0000803F0000803F07000000040000100014000000803F0000803F0000803F09000000040000100014000000803F0000803F0000803F0B000000040000
GO
/****** Object:  Statistic [PK_SYS_PhanQuyen]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[SYS_PhanQuyen]([PK_SYS_PhanQuyen]) WITH STATS_STREAM = 0x01000000020000000000000000000000B1765AAD00000000DF010000000000008701000000000000240300002400000010000000000000000000000000000000380300003800000004000A0000000000000000000000000007000000CFF500014FA000000B000000000000000B00000000000000000000000000803F8C2EBA3D00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000002000000200000000000A0410000304100000000000080410000804000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000002B0000000000000008000000000000001000200000003041000000000000803FE462C85681267D4BA0D2A6FB4F4257F8040000, ROWCOUNT = 53, PAGECOUNT = 1
GO
/****** Object:  Statistic [_WA_Sys_00000002_4850AF91]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000002_4850AF91] ON [dbo].[SYS_Quyen]([Rollname]) WITH STATS_STREAM = 0x01000000010000000000000000000000F2579E18000000003F05000000000000FF04000000000000E703B1F5E7000000640000000000000008D000340200000007000000F683EB004FA000000A000000000000000A0000000000000000000000CDCCCC3D00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000A0000000A00000001000000100000000000D04100002041000000000000D0410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000003A020000000000009B0300000000000050000000000000007F00000000000000A400000000000000CD0000000000000004010000000000002B010000000000006A01000000000000A101000000000000D6010000000000000F02000000000000300010000000803F000000000000803F04000001002F004200A31E6E00670020007400680061006D0020007300D11E300010000000803F000000000000803F040000010025004300E000690020001101B71E7400300010000000803F000000000000803F0400000100290043006800A51E6D0020006300F4006E006700300010000000803F000000000000803F040000010037004300A10120006300A51E750020002D0020007400D51E200063006800E91E6300300010000000803F000000000000803F0400000100270047006900A31E6900200074007200ED00300010000000803F000000000000803F04000001003F0048006F00E0006E00200074006800E0006E006800200063006800A51E6D0020006300F4006E006700300010000000803F000000000000803F040000010037004E006800AD1E740020006B00FD0020006800C71E200074006800D11E6E006700300010000000803F000000000000803F0400000100350051007500A31E6E0020006C00FD0020006E006800E2006E0020007300F11E300010000000803F000000000000803F0400000100390051007500A31E6E00200074007200CB1E20006800C71E200074006800D11E6E006700300010000000803F000000000000803F04000001002B005400ED006E00680020006C00B001A1016E006700FF01000000000000000A0000000A000000280000002800000000000000000000007B0000004200A31E6E00670020007400680061006D0020007300D11E4300E000690020001101B71E74006800A51E6D0020006300F4006E006700A10120006300A51E750020002D0020007400D51E200063006800E91E630047006900A31E6900200074007200ED0048006F00E0006E00200074006800E0006E006800200063006800A51E6D0020006300F4006E0067004E006800AD1E740020006B00FD0020006800C71E200074006800D11E6E00670051007500A31E6E0020006C00FD0020006E006800E2006E0020007300F11E74007200CB1E20006800C71E200074006800D11E6E0067005400ED006E00680020006C00B001A1016E0067000D0000004000000000810C000000C0010C000081060D00008108130000010F1B000081082A000081143200008110460000C005560000810A5B0000010C650000010A71000000
GO
/****** Object:  Statistic [_WA_Sys_00000003_4850AF91]    Script Date: 12/12/2017 12:44:55 AM ******/
CREATE STATISTICS [_WA_Sys_00000003_4850AF91] ON [dbo].[SYS_Quyen]([Description]) WITH STATS_STREAM = 0x01000000010000000000000000000000AFCC594A000000003D08000000000000FD070000000000006303000063000000FFFF00000000000008D0003401000000070000000484EB004FA000000A000000000000000A000000000000000000803FCDCCCC3D0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000090000000900000001000000100000009A998B4200002041000000009A998B420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000008D03000000000000990600000000000048000000000000005B00000000000000F8000000000000003D010000000000007C01000000000000C5010000000000005802000000000000D9020000000000001803000000000000100010000000803F000000000000803F040000300010000000803F0000803F0000803F04000001009D004300E000690020001101B71E740020006300F4006E006700200074006800E91E630020007400ED006E00680020006C00B001A1016E0067002C0020004C00B001A1016E00670020007400D11E69002000740068006900C31E75002C0020005100100120007300D11E20006E006700E0007900200063006800A51E6D0020006300F4006E006700300010000000803F000000000000803F0400000100450043006800A51E6D0020006300F4006E0067002000630068006F0020006E006800E2006E00200076006900EA006E00300010000000803F000000000000803F04000001003F0048006F00E0006E00200074006800E0006E006800200063006800A51E6D0020006300F4006E006700300010000000803F000000000000803F04000001004900540068006100790020001101D51E690020006300E100630020006200A31E6E00670020007400680061006D0020007300D11E300010000000803F000000000000803F04000001009300540068006100790020001101D51E690020006300A10120006300A51E750020007400D51E200063006800E91E63002000740072006F006E00670020006300F4006E0067002000740079002000280050006800F2006E0067002000620061006E002C0020007400D51E2C00200063006800E91E630020007600E51E2900300010000000803F000000000000803F040000010081005400680065006F0020006400F500690020006800C71E200074006800D11E6E00670020002D00200043006800C91E20006300F3002000530075007000650072002000550073006500720020006D00DB1E690020006300F300200052006F006C006C0020006E00E0007900300010000000803F000000000000803F04000001003F005400ED006E00680020006C00B001A1016E00670020006E006800E2006E00200076006900EA006E00300010000000803F000000000000803F040000010075005800ED1E20006400E51E6E00670020006400CB1E6300680020007600E51E200074006800B001200067006900E3006E0020002D00200067006900A31E6900200074007200ED0020006300E71E610020007700650062007300690074006500FF01000000000000000A0000000A000000280000002800000000000000000000004E0100004300E100630020007600A51E6E0020001101C11E20006C006900EA006E0020007100750061006E0020001101BF1E6E0020006E006800E2006E0020007300F11EE000690020001101B71E740020006300F4006E006700200074006800E91E630020007400ED006E00680020006C00B001A1016E0067002C0020004C00B001A1016E00670020007400D11E69002000740068006900C31E75002C0020005100100120007300D11E20006E006700E0007900200063006800A51E6D0020006300F4006E0067006800A51E6D0020006300F4006E0067002000630068006F0020006E006800E2006E00200076006900EA006E0048006F00E0006E00200074006800E0006E006800200063006800A51E6D0020006300F4006E006700540068006100790020001101D51E690020006300E100630020006200A31E6E00670020007400680061006D0020007300D11EA10120006300A51E750020007400D51E200063006800E91E63002000740072006F006E00670020006300F4006E0067002000740079002000280050006800F2006E0067002000620061006E002C0020007400D51E2C00200063006800E91E630020007600E51E290065006F0020006400F500690020006800C71E200074006800D11E6E00670020002D00200043006800C91E20006300F3002000530075007000650072002000550073006500720020006D00DB1E690020006300F300200052006F006C006C0020006E00E0007900ED006E00680020006C00B001A1016E00670020006E006800E2006E00200076006900EA006E005800ED1E20006400E51E6E00670020006400CB1E6300680020007600E51E200074006800B001200067006900E3006E0020002D00200067006900A31E6900200074007200ED0020006300E71E6100200077006500620073006900740065000E0000004100000000C001000000811F010000814220000001166200008114780000C0018C0000C0018D0000C0088E0000810F9600000134A500000133D9000001130C0100012F1F010000
GO
/****** Object:  Statistic [PK_Quyen]    Script Date: 12/12/2017 12:44:55 AM ******/
UPDATE STATISTICS [dbo].[SYS_Quyen]([PK_Quyen]) WITH STATS_STREAM = 0x01000000010000000000000000000000166307E9000000003702000000000000F701000000000000380300003800000004000A0000000000000000000000000007000000DAEBF4004EA00000090000000000000009000000000000000000803F398EE33D000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000050000000100000014000000000080400000104100000000000080400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000009B0000000000000028000000000000003F0000000000000056000000000000006D000000000000008400000000000000100014000000803F000000000000803F01000000040000100014000000803F0000803F0000803F03000000040000100014000000803F000000000000803F04000000040000100014000000803F000040400000803F0A000000040000100014000000803F000000000000803F0B000000040000, ROWCOUNT = 13, PAGECOUNT = 1
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Khi đã hoàn thành chấm công thì không được phép sửa, có người ký' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PB_Danhsachchamcong', @level2type=N'COLUMN',@level2name=N'IsFinish'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tiền lương mỗi giờ tăng ca' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PB_Luongtangca', @level2type=N'COLUMN',@level2name=N'LuongGio'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dựa vào quan hệ phụ thuộc để tính giảm trừ gia cảnh' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PB_Nguoithannhanvien', @level2type=N'COLUMN',@level2name=N'Phuthuoc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NV00000001' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PB_Nhanvien', @level2type=N'COLUMN',@level2name=N'MaNV'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Có 4 trạng thái: 1 - Đang làm việc, 2 - Đang thử việc, 3 - Tạm ngưng việc, 4 - Đã nghỉ việc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PB_Nhanvien', @level2type=N'COLUMN',@level2name=N'Tinhtrang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quy định tổng số ngày phải chấm công trong mỗi tháng' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PB_Thaydoitongsongaychamcong', @level2type=N'COLUMN',@level2name=N'Tongsongaychamcong'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Yeu cau Reset mat khau tu nguoi dung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_Nguoidung', @level2type=N'COLUMN',@level2name=N'IsRequireResetPass'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ma xac nhan khi quen mat khau se duoc gui vao Email de Reset Pass' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_Nguoidung', @level2type=N'COLUMN',@level2name=N'CodeResetPassForget'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DIC_Cauhinhcongthuc"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 219
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 10
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_DIC_Cauhinhcongthuc_HT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_DIC_Cauhinhcongthuc_HT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PB_Luongtoithieu"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 208
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Luongtoithieu_HT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Luongtoithieu_HT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PB_Nhanvien"
            Begin Extent = 
               Top = 10
               Left = 254
               Bottom = 205
               Right = 412
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PB_Thaydoichucvu"
            Begin Extent = 
               Top = 11
               Left = 0
               Bottom = 202
               Right = 155
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "DIC_Chucvu"
            Begin Extent = 
               Top = 20
               Left = 563
               Bottom = 135
               Right = 718
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thaydoichucvu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thaydoichucvu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[49] 4[20] 2[19] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -288
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DIC_Dantoc"
            Begin Extent = 
               Top = 9
               Left = 213
               Bottom = 124
               Right = 368
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "PB_Nhanvien"
            Begin Extent = 
               Top = 353
               Left = 263
               Bottom = 468
               Right = 421
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "DIC_Quoctich"
            Begin Extent = 
               Top = 256
               Left = 0
               Bottom = 371
               Right = 155
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DIC_Tongiao"
            Begin Extent = 
               Top = 246
               Left = 424
               Bottom = 361
               Right = 579
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "DIC_Bangcap"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DIC_Ngonngu"
            Begin Extent = 
               Top = 120
               Left = 518
               Bottom = 235
               Right = 673
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DIC_Chuyenmon"
            Begin Extent = 
               Top = 4
               Left = 452
               Bottom = 119
               Right = 607
            End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thongtincanhan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DIC_Tinhoc"
            Begin Extent = 
               Top = 194
               Left = 23
               Bottom = 309
               Right = 178
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thongtincanhan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thongtincanhan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PB_Nhanvien"
            Begin Extent = 
               Top = 6
               Left = 424
               Bottom = 121
               Right = 582
            End
            DisplayFlags = 280
            TopColumn = 21
         End
         Begin Table = "PB_Phongban"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PB_Thaydoiphongban"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 361
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "DIC_Chucvu"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PB_Thaydoichucvu"
            Begin Extent = 
               Top = 126
               Left = 236
               Bottom = 241
               Right = 391
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "DIC_Congviec"
            Begin Extent = 
               Top = 6
               Left = 231
               Bottom = 121
               Right = 386
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PB_Thaydoicongviec"
            Begin Extent = 
               Top = 126
               Left = 429
               Bottom = 241
               Right = 584
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thongtincoban'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'          End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "PB_ToNhom"
            Begin Extent = 
               Top = 246
               Left = 231
               Bottom = 361
               Right = 391
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thongtincoban'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thongtincoban'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[52] 4[8] 2[36] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PB_Thaydoicongviec"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DIC_Congviec"
            Begin Extent = 
               Top = 6
               Left = 231
               Bottom = 121
               Right = 386
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DIC_BacLuong"
            Begin Extent = 
               Top = 6
               Left = 424
               Bottom = 121
               Right = 579
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DIC_NgachLuong"
            Begin Extent = 
               Top = 6
               Left = 617
               Bottom = 121
               Right = 772
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PB_Thaydoibacluong"
            Begin Extent = 
               Top = 6
               Left = 810
               Bottom = 121
               Right = 965
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PB_ToNhom"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PB_Nhanvien"
            Begin Extent = 
               Top = 126
               Left = 236
               Bottom = 241
               Right = 394
         ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thongtincongviec'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'   End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PB_Phongban"
            Begin Extent = 
               Top = 126
               Left = 432
               Bottom = 241
               Right = 592
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PB_Thaydoiphongban"
            Begin Extent = 
               Top = 126
               Left = 630
               Bottom = 241
               Right = 785
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DIC_Chucvu"
            Begin Extent = 
               Top = 126
               Left = 823
               Bottom = 241
               Right = 978
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PB_Thaydoichucvu"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 361
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2280
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thongtincongviec'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PB_Nhanvien_Thongtincongviec'
GO
USE [master]
GO
ALTER DATABASE [QLNS] SET  READ_WRITE 
GO

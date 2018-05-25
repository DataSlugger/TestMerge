set nocount on
print ''
print 'Adding reference data into ''dbo.APPLAUNCHER_APPS'' table .. '
print ''
go

DECLARE @rows_affected  int,
        @errcode        int,
		@smsg           varchar(max)

IF NOT EXISTS (select 1 
               from dbo.APPLAUNCHER_APPS 
			   where product = 'OIL' AND 
			         app_title = 'GIF Dashboard')
BEGIN
   BEGIN TRAN
   BEGIN TRY
	 insert into dbo.APPLAUNCHER_APPS 
	      (product, app_uid, app_title, tile_size, tile_icon, link_type, 
		   link_path, link_invoke, autorun_order, 
           search_enabled, search_default, roles, enabled)
	   values('OIL', NEWID(), 'GIF Dashboard', 'W', NULL, 'Path', 'C:\TC\ICTS\logistics\Applications\GIF-Dashboard\GIF-Dashboard.exe', NULL, NULL, 0, 0, NULL, 1)
	 set @rows_affected  = @@rowcount
   END TRY
   BEGIN CATCH
     set @errcode = ERROR_NUMBER()
	 set @smsg = ERROR_MESSAGE()
     IF @@TRANCOUNT >0
        ROLLBACK TRAN
     RAISERROR('= Failed to add records into the APPLAUNCHER_APPS table due to the error', 0, 1) with nowait
     RAISERROR('== ERROR %d %s', 0, 1, @errcode, @smsg) with nowait
     GOTO endofscript
   END CATCH
   COMMIT TRAN 
   IF @rows_affected>  0
      RAISERROR('= %d record(s) were added into the APPLAUNCHER_APPS table', 0, 1, @rows_affected) with nowait 
END
endofscript:
go
go
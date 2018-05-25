set nocount on
print ''
print 'Adding reference data into ''dbo.APPLAUNCHER_CATEGORIES_APPS'' table .. '
print ''
go

DECLARE @rows_affected  int,
		@app_uid		uniqueidentifier,
		@category_uid	uniqueidentifier,
		@position		int,
		@errcode        int,
		@smsg           varchar(max)

SELECT @app_uid = app_uid 
FROM APPLAUNCHER_APPS 
where product = 'OIL' and 
      app_title = 'GIF Dashboard'
	  
select @category_uid = category_uid 
from APPLAUNCHER_CATEGORIES 
where product = 'OIL' and 
      category_title = 'Operations'
	  
select @position = isnull(max(position), 0) + 10
from APPLAUNCHER_CATEGORIES_APPS 
where category_uid = @category_uid and 
      product = 'OIL'and 
	  app_uid = (select app_uid from APPLAUNCHER_APPS where app_title = 'GIF Dashboard')   
	  
IF NOT EXISTS (select 1 
               from dbo.APPLAUNCHER_CATEGORIES_APPS 
			   WHERE product = 'OIL' AND 
			         category_uid = @category_uid AND 
					 app_uid = @app_uid)
BEGIN
   BEGIN TRAN
   BEGIN TRY
     insert into dbo.APPLAUNCHER_CATEGORIES_APPS (product, category_uid, app_uid, tile_group, position)   
         values('OIL', @category_uid, @app_uid, NULL, @position)
     set @rows_affected  = @@rowcount;
   END TRY
   BEGIN CATCH
     set @errcode = ERROR_NUMBER()
	 set @smsg = ERROR_MESSAGE()
     IF @@TRANCOUNT > 0
        ROLLBACK TRAN
     RAISERROR('=> Failed to add records into the ''APPLAUNCHER_CATEGORIES_APPS'' table due to the error:', 0, 1) with nowait
     RAISERROR('=> ERROR %d: %s', 0, 1, @errcode, @smsg) with nowait
     GOTO endofscript
   END CATCH
   COMMIT TRAN
   IF @rows_affected > 0
      RAISERROR('=> %d record(s) were added into the APPLAUNCHER_CATEGORIES_APPS table', 0, 1, @rows_affected) with nowait
END
endofscript:
go
go
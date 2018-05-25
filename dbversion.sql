print ' '
print 'Updating database version info to save db version 3413.1 ...'
go

update dbo.database_info
set major_revnum = '3413',
    minor_revnum = '1',
    last_touch_date = getdate(),
    patch_level = null,
    note = 'asof REL-3.3.0000_build_18'
where owner_code = 'TC'
go
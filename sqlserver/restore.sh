#!/bin/bash

# Khởi động SQL Server trong nền
echo "🔄 Khởi động SQL Server..."
/opt/mssql/bin/sqlservr &

# Kiểm tra nếu SQL Server đã sẵn sàng để kết nối
echo "Chờ SQL Server khởi động..."
until /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "SELECT 1" &>/dev/null; do
    echo "SQL Server chưa sẵn sàng, thử lại..."
    sleep 30s
done

# Sau khi SQL Server đã sẵn sàng, bắt đầu khôi phục database từ file PA.bak
echo "🚀 Bắt đầu khôi phục database từ file PA.bak..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "
    RESTORE DATABASE CongTyPA 
    FROM DISK = '/var/opt/mssql/backup/PA.bak' 
    WITH REPLACE, 
    MOVE 'CongTyPhuongAn' TO '/var/opt/mssql/data/CongTyPA.mdf', 
    MOVE 'CongTyPhuongAn_log' TO '/var/opt/mssql/data/CongTyPhuongAn_log.ldf';
"

# Kiểm tra kết quả khôi phục
if [ $? -eq 0 ]; then
    echo "✅ Khôi phục database CongTyPA thành công!"
else
    echo "❌ Khôi phục database thất bại!"
fi

# Chạy SQL Server ở foreground để container không dừng
echo "🔄 Tiếp tục khởi động SQL Server ở foreground..."
wait $!

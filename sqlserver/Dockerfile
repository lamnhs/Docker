# Sử dụng image SQL Server 2019
FROM mcr.microsoft.com/mssql/server:2019-latest

# Cấu hình môi trường
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Lamlam@123

# Cài đặt sqlcmd và các công cụ khác
USER root
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    apt-get clean

# Tạo thư mục chứa file .bak
RUN mkdir -p /var/opt/mssql/backup

# Copy file .bak và script restore vào container
COPY ./PA.bak /var/opt/mssql/backup/PA.bak
COPY ./restore.sh /restore.sh

# Thực thi quyền cho script restore
RUN chmod +x /restore.sh


# Chạy restore khi container khởi động
USER mssql
CMD /bin/bash /restore.sh && /opt/mssql/bin/sqlservr

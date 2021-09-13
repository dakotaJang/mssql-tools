FROM mcr.microsoft.com/mssql-tools
RUN apt-get update && apt-get install -y unzip
RUN mkdir ~/Downloads
# Link to download sqlpackage, found from https://go.microsoft.com/fwlink/?linkid=2157202
# which was found from https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download
RUN curl https://download.microsoft.com/download/0/2/0/020aa2fa-f3f2-41ba-bacd-ff15557890d3/sqlpackage-linux-x64-en-US-15.0.5084.2.zip -o ~/Downloads/sqlpackage.zip
RUN mkdir /opt/sqlpackage
RUN unzip ~/Downloads/sqlpackage.zip -d /opt/sqlpackage
RUN echo 'export PATH="$PATH:/opt/sqlpackage"' >> ~/.bashrc
RUN chmod a+x /opt/sqlpackage/sqlpackage
RUN /bin/bash -c "source ~/.bashrc"
RUN rm -rf ~/Downloads
# Install additional dependencies for sqlpackage, sudo, and openssh-server
# https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download?view=sql-server-ver15#get-sqlpackage-net-core-for-linux
RUN apt-get update && apt-get install -y libunwind8 libicu55 sudo openssh-server
RUN useradd --password $(openssl passwd -1 docker) --shell /bin/bash docker
RUN service ssh restart
RUN ln -s /opt/sqlpackage/sqlpackage /usr/bin/sqlpackage
RUN ln -s /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd
CMD /bin/bash

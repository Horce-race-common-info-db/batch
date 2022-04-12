FROM centos

# yum アップデートとcronのインストール
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-* && \
    yum update -y --disableplugin=fastestmirror && \
    yum install -y epel-release --disableplugin=fastestmirror && \
    yum install -y --disableplugin=fastestmirror sudo cronie

# PAMの設定
RUN sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond

# Timezone 設定
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial && \
    dnf -y upgrade && \
    dnf -y install glibc-locale-source && \
    dnf clean all && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8" \
    TZ="Asia/Tokyo"

# lha の install
RUN yum install -y wget && \
    yum install -y unzip && \
    yum install -y automake && \
    yum install -y gcc && \ 
    yum install -y make && \ 
    wget https://github.com/jca02266/lha/archive/master.zip && \
    unzip master.zip && \
    cd lha-master && \
    aclocal && \
    autoheader && \
    automake -a && \
    autoconf && \
    ./configure --prefix=/usr/local --disable-dependency-tracking && \
    make && \
    make check && \
    make install

# Dockerfileと同じ階層の"cron.d"フォルダ内にcronの処理スクリプトを格納しておく
ADD cron.d /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*

CMD crond -n

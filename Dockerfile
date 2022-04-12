FROM centos

# update yum
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-* && \
    yum update -y --disableplugin=fastestmirror && \
    yum install -y epel-release --disableplugin=fastestmirror

# set env
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    TZ="Asia/Tokyo"

# install lha
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

# install rbenv
RUN yum install -y git && \
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv && \
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    ~/.rbenv/plugins/ruby-build/install.sh
ENV PATH ~/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
    echo 'eval "$(rbenv init -)"' >> .bashrc

# install ruby
RUN yum install -y openssl-devel zlib-devel && \
    bash -lc "rbenv install 3.1.0" && \
    bash -lc "rbenv global 3.1.0"

# bundle install
ADD ./app/upserter/Gemfile .
ADD ./app/upserter/Gemfile.lock .
RUN bash -lc "bundle install"

CMD /usr/sbin/init

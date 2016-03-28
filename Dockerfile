FROM ubuntu:14.04

MAINTAINER Clark Lin "linchengkuang@foxmail.com"
ENV REFRESHED_AT 2016-03-22

ENV SS_PORT 3888
ENV SS_PW shadowsockspasswd

############### Add Aliyun Ubuntu Mirrors ###############
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" > /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list

############### shadowsocks installation ###############
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y python-gevent python-pip python-m2crypto \
	&& pip install shadowsocks


############### Shadowsocks server ports ###############
EXPOSE $SS_PORT

# Create Shadowsocks Server Configuration ###############
RUN echo "{" > /etc/shadowsocks.json \
	&& echo ""server":"0.0.0.0"," > /etc/shadowsocks.json \
	&& echo ""server_port":$SS_PORT," > /etc/shadowsocks.json \
	&& echo ""local_port":1080," > /etc/shadowsocks.json \
	&& echo ""password":"$SS_PW"," > /etc/shadowsocks.json \
	&& echo ""timeout":600," > /etc/shadowsocks.json \
	&& echo ""method":"aes-256-cfb"" > /etc/shadowsocks.json \
	&& echo "}" > /etc/shadowsocks.json

ENTRYPOINT ["ssserver -c /etc/shadowsocks.json -d start"]
CMD ["--tail-log"]

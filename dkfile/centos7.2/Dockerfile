#FROM oraclelinux:7.0
FROM centos:centos7.2.1511

# Maintainer
# ----------
MAINTAINER Dylan Yin<oracle.yin@oracle.com>

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV HTTPS_PROXY=http://cn-proxy.jp.oracle.com:80
ENV HTTP_PROXY=http://cn-proxy.jp.oracle.com:80
ENV http_proxy=http://cn-proxy.jp.oracle.com:80
ENV https_proxy=http://cn-proxy.jp.oracle.com:80

# Copy packages
# -------------

# Setup filesystem and oracle user
# Install and configure Oracle JDK
# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
# ------------------------------------------------------------
RUN echo "proxy=http://cn-proxy.cn.oracle.com:80" >> /etc/yum.conf && \
    echo "exclude=*.i686,*i.386" >> /etc/yum.conf
RUN yum update -y && yum clean all
RUN yum --nogpg install -y vim zsh git tmux sudo tar && yum clean all
RUN yum --nogpg install -y python-pip.noarch libffi-devel.x86_64 python-cairocffi.noarch pycairo.x86_64 meld && yum clean all
RUN yum --nogpg groupinstall -y "X Window System" && yum clean all
RUN yum -y install firefox xorg-x11-fonts; yum clean all
#RUN yum --nogpg groupinstall -y "Fonts" && yum clean all
#RUN yum --nogpg install -y kde-workspace gdm && yum clean all
#RUN yum --nogpg install -y libXext* libXtst* libXrender* && yum clean all

# Setup filesystem and oracle user
# ------------------------------------------------------------
RUN mkdir /home/oracle && chmod a+xr /home/oracle && \
    useradd -m -s /bin/bash oracle && \
	echo oracle:welcome1 | chpasswd 
RUN ls -l /home/oracle

# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
RUN chown oracle:oracle -R /home/oracle \
    && echo "oracle ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers \
    && chsh -s /bin/zsh oracle

USER oracle
WORKDIR /home/oracle

RUN git config --global http.proxy http://cn-proxy.jp.oracle.com:80 \
	&& git config --global https.proxy http://cn-proxy.jp.oracle.com:80 \
	&& git config --global user.email dylan.yin@oracle.com \
	&& git config --global user.name dylan \
    && git clone https://github.com/bwithem/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc


RUN git clone https://github.com/ys2006/dotfile.git ~/.dotfiles \
    &&  ln -f ~/.dotfiles/zshrc ~/.zshrc \
    &&  ln -f ~/.dotfiles/vimrc ~/.vimrc \
    &&  ln -f ~/.dotfiles/tmux.conf ~/.tmux.conf

RUN sudo pip install cairosvg \

# Define default command to start bash. 
CMD ["zsh"]

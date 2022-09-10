#FROM ubuntu:latest
##########################
#Ubuntu v22.04 -> rolling
FROM ubuntu:rolling
##########################
#Ubuntu v20.04 -> focal
FROM ubuntu:focal
#########################
LABEL maintainer "bennyplo@gmail.com"
ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt install  openssh-server sudo -y
RUN apt install nano
ARG USER=ubuntu
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 $USER 
RUN usermod -aG sudo $USER
RUN echo "Port 22" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN service ssh start
RUN echo $USER:$USER | chpasswd
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
RUN apt-get upgrade -y
RUN apt-get install bash-completion -y
EXPOSE 5901
EXPOSE 5902
RUN apt install gnome-panel gnome-settings-daemon metacity -y
RUN apt install nautilus gnome-terminal -y
RUN apt install ubuntu-desktop -y
RUN apt install tightvncserver -y
RUN apt install lxde -y

#RUN su ubuntu
#RUN echo "ubuntu\nubuntu" | vncserver 
#RUN vncserver -kill :1

#---------------------------------------
#create the file for starting the vnc
RUN mkdir /home/ubuntu/.vnc
RUN echo "#!/bin/sh" >> /home/ubuntu/.vnc/xstartup
RUN echo "unset SESSION_MANAGER" >> /home/ubuntu/.vnc/xstartup
RUN echo "unset DBUS_SESSION_BUS_ADDRESS" >> /home/ubuntu/.vnc/xstartup
RUN echo "/usr/bin/startlxde" >> /home/ubuntu/.vnc/xstartup
RUN echo "[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup" \
>> /home/ubuntu/.vnc/xstartup
RUN echo "[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources" \
>> /home/ubuntu/.vnc/xstartup
RUN echo "x-window-manager &" >> /home/ubuntu/.vnc/xstartup
RUN chmod a-xr /home/ubuntu/.vnc
RUN chmod u+xr /home/ubuntu/.vnc
RUN chown ubuntu:root /home/ubuntu/.vnc
RUN chown ubuntu:root /home/ubuntu/.vnc/xstartup
RUN chmod a+x /home/ubuntu/.vnc/xstartup

#---------------------------------------------
#start vncserver when boot
RUN echo "#!/bin/sh -e" >> /etc/init.d/vncserver
RUN echo "### BEGIN INIT INFO" >> /etc/init.d/vncserver
RUN echo "# Provides:          vncserver" >> /etc/init.d/vncserver
RUN echo "# Required-Start:    networking" >> /etc/init.d/vncserver
RUN echo "# Default-Start:     S" >> /etc/init.d/vncserver
RUN echo "# Default-Stop:      0 6" >> /etc/init.d/vncserver
RUN echo "### END INIT INFO" >> /etc/init.d/vncserver
RUN echo 'PATH="$PATH:/usr/X11R6/bin/"' >> /etc/init.d/vncserver
RUN echo "# The Username:Group that will run VNC" >> /etc/init.d/vncserver
RUN echo 'export USER="ubuntu"' >> /etc/init.d/vncserver
RUN echo "#${RUNAS}" >> /etc/init.d/vncserver
RUN echo "# The display that VNC will use" >> /etc/init.d/vncserver
RUN echo 'DISPLAY="1"' >> /etc/init.d/vncserver
RUN echo "# Color depth (between 8 and 32)" >> /etc/init.d/vncserver
RUN echo 'DEPTH="24"' >> /etc/init.d/vncserver
RUN echo "# The Desktop geometry to use." >> /etc/init.d/vncserver
RUN echo 'GEOMETRY="1280x1024"' >> /etc/init.d/vncserver
RUN echo 'NAME="my-vnc-server"' >> /etc/init.d/vncserver
RUN echo 'OPTIONS="-name ${NAME} -depth ${DEPTH} -geometry ${GEOMETRY} \
:${DISPLAY}"' >> /etc/init.d/vncserver
RUN echo ". /lib/lsb/init-functions" >> /etc/init.d/vncserver
RUN echo 'case "$1" in' >> /etc/init.d/vncserver
RUN echo "start)" >> /etc/init.d/vncserver
RUN echo 'log_action_begin_msg "Starting vncserver for user '${USER}' on \
'>> /etc/init.d/vncserver
RUN echo 'localhost:${DISPLAY}"' >> /etc/init.d/vncserver
RUN echo 'su ${USER} -c "/usr/bin/vncserver ${OPTIONS}"' >>\ 
/etc/init.d/vncserver
RUN echo ";;" >> /etc/init.d/vncserver
RUN echo "stop)" >> /etc/init.d/vncserver
RUN echo 'log_action_begin_msg "Stoping vncserver for user '${USER}' \
on '>> /etc/init.d/vncserver
RUN echo 'localhost:${DISPLAY}"' >> /etc/init.d/vncserver
RUN echo 'su ${USER} -c "/usr/bin/vncserver -kill :${DISPLAY}"' >>\
/etc/init.d/vncserver
RUN echo ';;' >> /etc/init.d/vncserver
RUN echo 'restart)' >> /etc/init.d/vncserver
RUN echo '$0 stop' >> /etc/init.d/vncserver
RUN echo '$0 start' >> /etc/init.d/vncserver
RUN echo ';;' >> /etc/init.d/vncserver
RUN echo 'esac' >> /etc/init.d/vncserver
RUN echo 'exit 0' >> /etc/init.d/vncserver
RUN chmod +x /etc/init.d/vncserver
RUN update-rc.d vncserver defaults

#RUN echo "ubuntu\nubuntu\nn" | service vncserver start

#Notes:
#when started, run the following to start the vncserver
#service vncserver start

FROM ubuntu:focal-20210827

ARG USER_ID
ARG GROUP_ID

RUN apt-get update && apt install python3 -y

RUN addgroup --gid $GROUP_ID user \
&& adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

USER user

COPY file.sh /

#RUN ./google-cloud-sdk/install.sh --rc-path /home/$USER_ID/.bash_profile -q \
#&& PATH="$PATH" && exec bash

#RUN source '/home/jovyan/work/google-cloud-sdk/path.bash.inc' \
#&& source '/home/jovyan/work/google-cloud-sdk/completion.bash.inc' \
#&& gcloud components install app-engine-python



 

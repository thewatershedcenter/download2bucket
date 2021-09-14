FROM ubuntu:focal-20210827

ARG USER_ID
ARG GROUP_ID

RUN apt-get update && apt install parallel python3 curl -y



# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
RUN mkdir -p /usr/local/gcloud \
    && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
    && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# add a user based on args
RUN addgroup --gid $GROUP_ID user \
    && adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

COPY file.sh /
RUN  chmod 777 file.sh

# change to user
USER user

ENTRYPOINT ["/file.sh"]

#RUN ./google-cloud-sdk/install.sh --rc-path /home/$USER_ID/.bash_profile -q \
#&& PATH="$PATH" && exec bash

#RUN source '/home/jovyan/work/google-cloud-sdk/path.bash.inc' \
#&& source '/home/jovyan/work/google-cloud-sdk/completion.bash.inc' \
#&& gcloud components install app-engine-python



 

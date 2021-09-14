FROM ubuntu:focal-20210827

# parse args
ARG USER_ID
ARG GROUP_ID

# install packages
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

# copy file and change permissions
COPY file.sh /
RUN  chmod 777 file.sh

# change to user
USER user

# labels
LABEL maintainer=michael@thewatershedcenter.com

# enter into bash script
ENTRYPOINT ["/file.sh"]





 

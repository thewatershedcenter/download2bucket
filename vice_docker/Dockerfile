FROM connormanning/entwine:sha-db0aa5a9

# labels
LABEL maintainer=michael@thewatershedcenter.com

# parse args (these are not used here but exsit for build consistency with other tagged versions)
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
#RUN addgroup --gid $GROUP_ID user \
#    && adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

# copy file and change permissions
COPY vice_file.sh /
RUN  chmod 777 vice_file.sh

# change to user
#USER user

# remove the gcloud tarball for image size reduction
RUN rm -rf /tmp/*

# change workdir    
WORKDIR /root/work

# enter into bash script
ENTRYPOINT ["/vice_file.sh"]

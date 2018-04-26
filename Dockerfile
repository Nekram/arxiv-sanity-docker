FROM python:3
MAINTAINER James Folberth <jamesfolberth@gmail.com>
# Heavily modified from https://github.com/karpathy/arxiv-sanity-preserver/pull/38

USER root
RUN apt-get update -y &&\
    apt-get install -y poppler-utils\
                       imagemagick\
                       libopenblas-dev\
                       ghostscript\
                       sqlite3\
                       sudo &&\
    apt-get clean

# Install more recent mongodb from mongodb's repo
# https://docs.mongodb.com/v2.6/tutorial/install-mongodb-on-debian/#install-mongodb
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 &&\
    echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list &&\
    sudo apt-get update -y &&\
    sudo apt-get install -y mongodb-org

# Install python packages
COPY arxiv-sanity-preserver/requirements.txt /home/$USER/arxiv-sanity-requirements.txt
RUN pip install --no-cache-dir -r /home/$USER/arxiv-sanity-requirements.txt &&\
    rm /home/$USER/arxiv-sanity-requirements.txt

# Create user that runs the stuff
ENV USER=arxiv
ENV PASS=arxiv
RUN useradd -m -s /bin/bash -G sudo $USER && echo "$USER:$PASS" | chpasswd

# Add the arxiv-sanity repo to the container
ADD arxiv-sanity-preserver /home/$USER/arxiv-sanity-preserver
RUN chown -R arxiv /home/$USER/arxiv-sanity-preserver

# Create an empty directory that we'll mount when we run the container
RUN mkdir -p /data/arxiv-sanity

EXPOSE 6785

USER $USER
WORKDIR /home/$USER/arxiv-sanity-preserver
#CMD ["serve.sh"]
CMD ["/bin/bash"]

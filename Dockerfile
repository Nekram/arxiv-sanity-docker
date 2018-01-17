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
                       sudo\
                       mongodb &&\
    apt-get clean
RUN systemctl enable mongodb.service
#TODO JMF 16 Jan 2018: mongodb doesn't appear to be started when we try to serve things

# Create user that runs the stuff
ENV USER=arxiv
RUN useradd -m $USER

# Install python packages
COPY arxiv-sanity-preserver/requirements.txt /home/$USER/arxiv-sanity-requirements.txt
RUN pip install --no-cache-dir -r /home/$USER/arxiv-sanity-requirements.txt

# Add the arxiv-sanity repo to the container
ADD arxiv-sanity-preserver /home/$USER/arxiv-sanity-preserver

# Create an empty directory that we'll mount when we run the container
RUN mkdir -p /data/arxiv-sanity

EXPOSE 6785

USER $USER
WORKDIR /home/$USER
#CMD ["python", "serve.py", "--prod", "--port", "6785"]
CMD ["/bin/bash"]

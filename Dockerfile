FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \libjpeg-dev 
RUN git clone https://github.com/michaelrsweet/mxml.git
WORKDIR /mxml
RUN CC=afl-clang ./configure
RUN make
RUN make install
RUN mkdir /mxmlCorpus
RUN wget http://www-db.deis.unibo.it/courses/TW/DOCS/w3schools/xml/note.xml
RUN wget http://www-db.deis.unibo.it/courses/TW/DOCS/w3schools/xml/simple.xml
RUN wget http://www-db.deis.unibo.it/courses/TW/DOCS/w3schools/xml/plant_catalog.xml
RUN wget http://www-db.deis.unibo.it/courses/TW/DOCS/w3schools/xml/cd_catalog.xml
RUN cp *.xml /mxmlCorpus

ENTRYPOINT ["afl-fuzz", "-i", /mxmlCorpus", "-o", "/mxmlOut"]
CMD ["/mxml/testmxml", "@@"]

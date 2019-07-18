FROM continuumio/miniconda3:4.6.14

LABEL version="1.5.6"

# Update distro and install basic tools
ENV APT_PACKAGES \
    autoconf build-essential bzip2 cmake curl gcc git libboost-dev libsdsl3 \
    libz-dev zlib1g
RUN apt-get update && apt-get install --yes ${APT_PACKAGES} \
    && rm -rf /var/lib/apt/lists/*

# Configure conda and install tools
ENV CONDA_PACKAGES \
    abyss=2.0.1 bedtools biopython pandas pip
RUN \
    conda config --add channels conda-forge && \
    conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda install --yes ${CONDA_PACKAGES} && \
    conda clean --all --yes

# Install SDSL-lite
# RUN \
#     cd /opt/ && \
#     git clone --recursive https://github.com/simongog/sdsl-lite.git && \
#     cd sdsl-lite/ && \
#     ./install.sh /usr/

# Install Biobloom tools
RUN \
    cd /opt/ && \
    git clone --recursive https://github.com/bcgsc/biobloom.git && \
    cd biobloom/ && \
    git submodule update --init && \
    git checkout 0a42916922d42611a087d4df871e424a8907896e && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local/ && \
    make -j 4 && \
    make install


# Install exfi
RUN pip install https://github.com/jlanga/exfi/archive/v1.5.6.zip

RUN git clone --recursive https://github.com/jlanga/exfi
RUN build_baited_bloom_filter \
    --input-fasta exfi/data/transcript.fa \
    --kmer 25 \
    --bloom-size 100M \
    --levels 1 \
    --threads 4 \
    --output-bloom genome_k25_m100M_l1.bf \
    --verbose \
    exfi/data/genome.fa.gz
RUN build_splice_graph \
    --input-fasta exfi/data/transcript.fa \
    --input-bloom genome_k25_m100M_l1.bf \
    --kmer 25 \
    --max-fp-bases 5 \
    --verbose \
    --output-gfa test.gfa
RUN cat test.gfa
RUN rm -rf exfi

MAINTAINER Jorge Langa <jorge.langa.arranz@gmail.com>

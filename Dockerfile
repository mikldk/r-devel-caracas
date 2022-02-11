## Emacs, make this -*- mode: sh; -*-

## start with the Docker 'base R' Debian-based image
FROM rocker/r-devel:latest

## This handle reaches Carl and Dirk
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

## Needed in case a base package has an interactive question
## (as e.g. base-passwd in Oct 2020)
ENV DEBIAN_FRONTEND noninteractive

## Remain current
RUN apt-get update -qq \
	&& apt-get dist-upgrade -y

## From the Build-Depends of the Debian R package, plus subversion
RUN apt-get update -qq \
	&& apt-get install -t unstable -y --no-install-recommends \		
		pandoc nano python3-pip 

RUN echo en_US ISO-8859-1 >> /etc/locale.gen
RUN locale-gen

RUN pip3 install virtualenv

RUN install2.r --error --skipinstalled --ncpus -3 \
    remotes \
    reticulate \
    knitr \
    rmarkdown \ 
    magrittr \
    testthat

RUN RD -e "reticulate::install_miniconda();"

RUN RD -e "reticulate::py_discover_config();"

#RUN RD -e "reticulate::py_install('sympy')"
#RUN RD -e "reticulate::py_install(packages = c('sympy==1.5.1'))"
RUN RD -e "reticulate::py_install(packages = c('sympy==1.9'))"




FROM rocker/shiny-verse:latest

RUN rm -rf /srv/shiny-server/*


RUN apt-get update && apt-get install -y curl

RUN install2.r --error \
shinyjs  \
plotly  \
remotes  \
tidytext \ 
DT \
knitr \
scales \
glue \
prompter \
shinybrowser \
janitor \
kableExtra \
rmarkdown \
markdown \
gt \
conflicted \
bslib \
lubridate \
readxl \
bsicons

COPY ./app /srv/shiny-server
COPY ./app/01_raw_data /srv/shiny-server/01_raw_data
# RUN R -e "remotes::install_github('rstudio/bslib')"

# R has to render the documentation and needs write permission to this specific subfolder
RUN chown -R shiny:shiny /srv/shiny-server/www/documentation
RUN mkdir /srv/shiny-server/app_cache
RUN chown -R shiny:shiny /srv/shiny-server/app_cache

USER shiny

CMD ["/init"] 
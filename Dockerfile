# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM ghcr.io/jimboid/biosim-jupyter-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"
LABEL org.opencontainers.image.source=https://github.com/jimboid/biosim-equilibration-workshop
LABEL org.opencontainers.image.description="A container environment for the ccpbiosim workshop on Equilibration."
LABEL org.opencontainers.image.licenses=MIT

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Install workshop deps
RUN conda install mdtraj matplotlib numpy -y
RUN conda install ipywidgets -c conda-forge -y

RUN git clone https://github.com/CCPBioSim/equilibration-workshop.git && \
    mv equilibration-workshop/* . && \
    rm -r AUTHORS LICENSE README.md equilibration-workshop && \
    mv equilT.png equilt.png

# Copy lab workspace
COPY --chown=1000:100 default-37a8.jupyterlab-workspace /home/jovyan/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER

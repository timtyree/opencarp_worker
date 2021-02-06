
docker pull docker.opencarp.org/opencarp/opencarp:latest
docker run -it docker.opencarp.org/opencarp/opencarp:latest



#then, 
git clone https://git.opencarp.org/openCARP/experiments.git



#then install opencarp-docker
# cd <path-to-your-codebase>/openCARP/docker
# ./install_script.sh <path-to-your-bin>
# For example, to install to `/usr/local/bin`, run:
sudo ./install_script.sh /usr/local/bin

# The script enables you to start with the keyword `opencarp-docker` followed by the appropriate command.


#note they can be run on clusters
#source: https://opencarp.org/documentation/examples/02_ep_tissue/20_parameter_sweep#run-parameter-sweeps-using-carputils-on-clusters

opencarp-docker pull
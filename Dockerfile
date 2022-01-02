###########################
##
##	SETUP
##
##	Debian - Latest
##	Kali keyring 2020.2
##	Users - root, sordidlist
##
###########################


FROM debian:latest

RUN useradd -m -s /bin/bash sordidlist && \
    echo 'sordidlist ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Configure debian
ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
ENV TERM xterm-256color

WORKDIR /home

# Get package cache and upgrade packages
RUN rm -fR /var/lib/apt/ && \
    apt-get clean && \
    apt-get update -y && \
    apt-get upgrade -y

RUN apt-get install -y wget && \
	wget -O kali-archive-keyring_2020.2_all.deb https://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2020.2_all.deb && \
	apt-get update -y && \
	apt-get upgrade -y 

###########################
##
##	LANGUAGES AND PACKAGE MANAGERS
##
##	Python 2.7
##	Python 3.x
##	Rust latest
##  Homebrew latest
##
###########################


# Install python2 and necessary modules
RUN apt-get update -y && \
    apt-get install -y python2 && \
    wget https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python2 get-pip.py && \
    rm get-pip.py
RUN apt-get install -y git && \
	git clone git://github.com/kennethreitz/requests.git && \
    cd requests && \
    python2 ./setup.py install && \
    cd ../ && \
    rm -rf requests && \
    apt-get update -y

# Install python3 and necessary modules
RUN apt-get install -y python3-setuptools && \
    apt-get install -y python3-pip && \
    pip3 install requests

# Rust
RUN apt-get install -y curl && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# # Homebrew
RUN mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew




###########################
##
##	APPLICATIONS
##
##	a bunch
##
###########################

RUN apt-get install --no-install-recommends -y file && \
	apt-get install --no-install-recommends -y zsh

###########################
##
##	FRAMEWORKS
##
##	Metasploit
##	Radare2
##
###########################

# Install Metasploit Framework
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
    chmod 755 msfinstall && \
    ./msfinstall

# radare2
RUN git clone https://github.com/radareorg/radare2.git && cd radare2 && sys/install.sh


###########################
##
##	TERMINAL SETUP
##
###########################

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
	# sed -i 's/# ZSH_THEME'
	sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/g' ~/.zshrc && \
	echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >> ~/.zshrc


###########################
##
##	SCRATCH SPACE
##
###########################







# Managing Byzantine Robots via Blockchain Technology in a Swarm Robotics Collective Decision Making Scenario

## Instructions

# Linux
sudo apt-get install cmake libfreeimage-dev libfreeimageplus-dev \
  qt5-default freeglut3-dev libxi-dev libxmu-dev liblua5.3-dev \
  lua5.3 doxygen graphviz libgraphviz-dev asciidoc

If qt5-default is not found, use this:
sudo apt-get install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools


install python

sudo apt-get install g++


./scripts/install_argos.sh

nano ~/.bashrc

source /home/thivi/argos3-dist/bin/setup_argos3


install go 1.7.3

export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

./create-geths.sh

./create_sc.sh

sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc

install npm

install solc@0.4.8

install sendmail

edit experiment file

mkdir build

cd build

cmake ..

make

Add export PATH=$PATH:/home/thivi/poi/blockchain-swarm-robotics/go-ethereum0/build/bin

start experiment

Decision Rules

1 DMVD

2 DC

3 DMMD

### Requirements:
- ARGoS 3
- ARGoS-epuck
- git
- cmake
- golang (tested with version 1.7.3)
- optional: sendmail

## Scenario

Using the robot swarm simulator ARGoS 3, we study a collective
decision scenario, in which robots sense which of two features in an
environment is the most frequent one---a best-of-2 problem. Our
approach is based on the collective decision scenario of Valentini et
al. Via blockchain-based smart contracts using the Ethereum protocol,
we add a security layer on top of the classical approach that allows
to take care of the presence of Byzantine robots. Our blockchain
approach also allows to log events in a tamper-proof way: these logs
can then be used to analyze, if necessary, the behavior of the robots
in the swarm without incurring the risk that some malicious agent has
modified them. In addition, it provides a new way to understand how we
debug and do data forensics on decentralized systems such as robot

The goal of the robot swarm is to make a collective decision and to
reach consensus on the most frequent tile color of a black/white
grid. Each robot has a current opinion about the correct color, and
via dissemination/decision-making strategies, they influence their
peers. At the end of a successful run, all robots have the opinion of
the majority color (in our experiments it is always the white).

<p align="center">
<img src="https://github.com/Pold87/blockchain-swarm-robotics/blob/master/img/environment.png" alt="Collective decision-making scenario"/>
</p>

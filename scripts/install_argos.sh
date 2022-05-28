#/bin/env bash -e

# Script by Lorenzo Garattoni

# Modifica

USERNAME=`whoami`

# Installation directory (specify a full path!)
INSTALL_DIR=/home/${USERNAME}/argos3-dist

# ARGoS3 repository
ARGOS3_REPOSITORY=https://github.com/ilpincy/argos3.git
ARGOS3_BRANCH=3.0.0-beta48
ARGOS3_DIR=argos3

# IRIDIA e-puck repository
#EPUCK_REPOSITORY=https://garattonilorenzo:prova@iridia-dev.ulb.ac.be/projects/argos3-epuck.git
EPUCK_REPOSITORY=https://github.com/demiurge-project/argos3-epuck.git
EPUCK_BRANCH=v48
EPUCK_DIR=argos3-epuck


function error() {
    echo
    echo "Error, script halted."
    exit 1
}

# Fetches the latest sources from a git repository
# $1: full repository URL
# $2: repository branch
# $3: output directory
function get_code() {
    local REPO=$1
    local BRANCH=$2
    local OUTDIR=$3

    if [ ! -d $OUTDIR ]; then
        echo -n "Downloading... "
        git clone --branch=$BRANCH $REPO $OUTDIR || error
    else
        echo -n "Updating... "
        cd $OUTDIR || error
        git checkout $BRANCH || error
        git pull || error
        cd ..
    fi
    echo "done"
}

# Creates the build directory, builds the code, and installs binaries
# $1: source location
# $*: extra CMake args
function do_build_install() {
    local SRC=../$1
    shift
    rm -rf build || error
    echo -n "Compiling... "
    mkdir build || error
    cd build || error
    cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
          -DCMAKE_BUILD_TYPE=Release \
          $* $SRC || error
    make -j4 || error
    echo "done"
    echo "Installing... "
    make install || error
    cd ..
    echo "done"
}

# Builds and installs ARGoS3
function do_argos3() {
    echo "+++ ARGoS3 +++"
    get_code $ARGOS3_REPOSITORY $ARGOS3_BRANCH $ARGOS3_DIR
    cd $ARGOS3_DIR
    do_build_install src -DARGOS_INSTALL_LDSOCONF=OFF -DARGOS_DOCUMENTATION=OFF
    cd ..
    echo -n "Deleting default e-puck... "
    rm -rf \
        $INSTALL_DIR/include/argos3/plugins/robots/e-puck \
        $INSTALL_DIR/lib/argos3/lib*epuck*.so
    echo "done"
}

# Builds and installs e-puck
function do_epuck() {
    echo "+++ e-puck +++"
    export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
    get_code $EPUCK_REPOSITORY $EPUCK_BRANCH $EPUCK_DIR
    cd $EPUCK_DIR
    do_build_install src
    cd ..
}

# Creates the setup script
function do_create_setup_script() {
    local SCRIPTFILE=$INSTALL_DIR/bin/setup_argos3
    echo "export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig" > $SCRIPTFILE
    echo "export ARGOS_PLUGIN_PATH=$INSTALL_DIR/lib/argos3" >> $SCRIPTFILE
    echo "export LD_LIBRARY_PATH=\$ARGOS_PLUGIN_PATH:/usr/java/jdk1.6.0_43/jre/lib/amd64:/usr/java/jdk1.6.0_43/jre/lib/amd64/server:/usr/java/jdk1.6.0_43/jre/lib/amd64/xawt" >> $SCRIPTFILE
    echo "export PATH=\$PATH:$INSTALL_DIR/bin" >> $SCRIPTFILE
    echo "Execute the following command to setup the environment for ARGoS3:"
    echo
    echo "  source $SCRIPTFILE"
}

# Erase and re-create installation directory
#rm -rf $INSTALL_DIR
#mkdir $INSTALL_DIR

# Go through packages
do_argos3
do_epuck

# Create the setup script
do_create_setup_script

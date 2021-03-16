#!/bin/bash

function prompt_yesno {
    
    while true; do
        read -p "$1 [yn] " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
        esac
    done
}

function prompt_path {

    local question=$1
    local default=${2:-./}

    while true; do
        read -e -p "$question " -i $default path
        if [ ! -z $path ]; then
            echo $path
            break
        fi
    done
}

function command_exists {
    exists=$(command -v $1 >/dev/null 2>&1)
    return $exists
}

function clone {
    
    local repo=$1
    local dest=$2

    local cmd="git clone git@bitbucket.org:carpusers/${1}.git $2"

    echo $cmd
    echo
    eval $cmd

    if [ $? -ne 0 ]; then
        echo 
        echo "Clone failed - perhaps you do not have access, or have"
        echo "previously cloned this repository."
        exit 1;
    else
        echo
    fi
}

echo "=================================================================="
echo "                   CARP Examples Quick Install"
echo "=================================================================="
echo
echo "    This script is an interactive quick installer for the new"
echo "    CARP examples and testing framework."
echo
echo "    The new framework is developed on the carpusers Bitbucket"
echo "    team:"
echo "        https://bitbucket.org/carpusers/"
echo
echo "    For access to the team and respositories, please create a"
echo "    Bitbucket account and email your username to Andrew"
echo "    Crozier at:"
echo "        andrew.crozier@medunigraz.at"
echo
echo "=================================================================="
echo

echo "Checking dependencies..."
echo
dependencies=0
for cmd in git python2; do
    if command_exists $cmd; then
        echo "    $cmd exists"
    else
        echo "    $cmd missing!"
        dependencies=1
    fi
done

echo

if [ $dependencies == 0 ]; then
    echo "All dependencies ok"
else
    echo "Some dependencies missing, please install and retry"
    exit 1
fi

echo
echo "=============================================================="
echo

echo "Installation Configuration"
echo
echo "Decide which parts to get (answer yes to all if unsure):"
echo

CARPUTILS=0
if prompt_yesno "Install carputils (core framework)?"; then CARPUTILS=1; fi
DEVTESTS=0
if prompt_yesno "Install developer tests?"; then DEVTESTS=1; fi
BENCHMARKS=0
if prompt_yesno "Install benchmarks?"; then BENCHMARKS=1; fi
REFERENCE=0
if prompt_yesno "Install reference solutions?"; then REFERENCE=1; fi
TUTORIALS=0
if prompt_yesno "Install benchmarks?"; then TUTORIALS=1; fi

echo

echo "Repository Locations"
echo
DEF_ROOT=$(prompt_path "Set default software root:" "$HOME/software")
DEF_ROOT=$(readlink -m $DEF_ROOT) # Clean path
echo

echo "Set repository locations:"
echo 
CARPUTILS_PATH=$(prompt_path "carputils (core framework):" "$DEF_ROOT/carputils")
EXAMPLES_PATH=$(prompt_path "Test repos:" "$DEF_ROOT/carp-examples")
REFERENCE_PATH=$(prompt_path "Reference solution repos:" "$DEF_ROOT/carp-example-reference")

# Clean paths
CARPUTILS_PATH=$(readlink -m $CARPUTILS_PATH)
EXAMPLES_PATH=$(readlink -m $EXAMPLES_PATH)
REFERENCE_PATH=$(readlink -m $REFERENCE_PATH)

echo
echo "=============================================================="
echo

echo "Cloning Repositories"
echo

# Get carputils
if [ $CARPUTILS == 1 ]; then
    clone "carputils" $CARPUTILS_PATH
fi

# Check examples directory exists
if [ $DEVTESTS == 1 ] || [ $BENCHMARKS == 1 ] || [ $TUTORIALS == 1 ]; then
    if [ ! -d "$EXAMPLES_PATH" ]; then
        echo "Example directory $EXAMPLES_PATH does not exist, creating..."
        mkdir "$EXAMPLES_PATH"
        echo
    fi
fi

# Clone test repositories
if [ $DEVTESTS == 1 ]; then
    clone "devtests" "$EXAMPLES_PATH/devtests"
fi
if [ $BENCHMARKS == 1 ]; then
    clone "benchmarks" "$EXAMPLES_PATH/benchmarks"
fi
if [ $TUTORIALS == 1 ]; then
    clone "tutorials" "$EXAMPLES_PATH/tutorials"
fi

# Clone reference solution repositories
if [ $REFERENCE == 1 ]; then
    
    # Check reference solution directory exists
    if [ ! -d "$REFERENCE_PATH" ]; then
        echo "Reference solution directory $REFERENCE_PATH does not exist, creating..."
        mkdir "$REFERENCE_PATH"
        echo
    fi

    # Clone reference solutions
    if [ $DEVTESTS == 1 ]; then
        clone "devtests-reference" "$REFERENCE_PATH/devtests"
    fi
    if [ $BENCHMARKS == 1 ]; then
        clone "benchmarks-reference" "$REFERENCE_PATH/benchmarks"
    fi

fi

echo
echo "=============================================================="
echo

echo "Environment Variable Configuration"
echo

echo "The following lines must be added to your .bashrc (or similar)"
echo "for the testing framework to function:"
echo
echo "export PATH=\$PATH:$CARPUTILS_PATH/bin"
echo "export PYTHONPATH=\$PYTHONPATH:$CARPUTILS_PATH:$EXAMPLES_PATH"
echo

if prompt_yesno "Do you want to append these to your .bashrc?"; then
    echo "" >> $HOME/.bashrc
    echo "# Automatically added by carptests quick setup script"     >> $HOME/.bashrc
    echo "export PATH=\$PATH:$CARPUTILS_PATH/bin"                    >> $HOME/.bashrc
    echo "export PYTHONPATH=\$PYTHONPATH:$CARPUTILS_PATH:$EXAMPLES_PATH" >> $HOME/.bashrc
fi

echo
echo "=============================================================="
echo

echo "Create settings.yaml"
echo

SETTINGS=$HOME/.config/carputils/settings.yaml
SETTINGS_CREATE=1

if [ -f "$SETTINGS" ]; then
    SETTINGS_CREATE=0
    if prompt_yesno "Settings file $SETTINGS already exists. Overwrite?"; then
        rm -f $SETTINGS
        SETTINGS_CREATE=1
    fi
    echo
fi

if [ $SETTINGS_CREATE == 1 ]; then

    NEW_SETTINGS=$CARPUTILS_PATH/bin/cusettings
    MOD_PYPATH=$PYTHONPATH:$CARPUTILS_PATH

    OPTS="--software-root $DEF_ROOT --regression-ref $REFERENCE_PATH"

    if [ -d "$EXAMPLES_PATH/devtests" ]; then
        OPTS="$OPTS --regression-pkg devtests"
    fi

    if [ -d "$EXAMPLES_PATH/benchmarks" ]; then
        OPTS="$OPTS --regression-pkg benchmarks"
    fi

    PYTHONPATH=$MOD_PYPATH python2 $NEW_SETTINGS $SETTINGS $OPTS

    echo "New settings file generated in $SETTINGS"
    echo
    echo "Please open it in your editor of choice and correct the"
    echo "paths to the location of your CARP installation etc."
    echo
fi

echo "=============================================================="

echo
echo "Installation is now complete. After reloading your .bashrc,"
echo "try running carptests on the command line to run a test suite."

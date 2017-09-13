#!/usr/bin/env bash
# Installs OMERO requirements

set -e
set -u
set -x

# Write the following enviorment variables commands to the profile
if [[ "${LANG}" != "en_GB.UTF-8" ]]; then
  echo "export LANG=en_US.UTF-8" >> ~/.bash_profile
fi

if [[ "${LANG}" != "en_US:en" ]]; then
  echo "export LANGUAGE=en_US:en" >> ~/.bash_profile
fi

# Test whether this script is run in a job environment
JOB_NAME=${JOB_NAME:-}
if [[ -n $JOB_NAME ]]; then
    DEFAULT_TESTING_MODE=true
else
    DEFAULT_TESTING_MODE=false
fi
TESTING_MODE=${TESTING_MODE:-$DEFAULT_TESTING_MODE}

###################################################################
# Homebrew installation
###################################################################

# Install Homebrew in /usr/local
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Update Homebrew
brew update

# Run brew doctor
brew doctor

# Install git if not already installed
brew list | grep "\bgit\b" || brew install git

# Install PostgreSQL
brew install postgresql

###################################################################
# Python pip installation
###################################################################

# Install Homebrew python
# Alternately, the system Python can be used but installing Python
# dependencies may require sudo
brew install python

# This will add ice tap https://github.com/zeroc-ice/homebrew-tap
# OMERO is only compatible with ICE 3.6 at the moment.
brew tap zeroc-ice/tap || echo "Already tapped"
brew install zeroc-ice/tap/ice36
if brew ls --versions ice > /dev/null; then
  # The package is installed
  echo "Ice already installed, unlinkning it"
  brew unlink ice 
fi  
brew link ice@3.6

# Tap homebrew-science library (HDF5)
brew tap homebrew/science || echo "Already tapped"

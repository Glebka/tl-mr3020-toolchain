#!/bin/bash
# Abort on Error
#
# This code was copied from Stack Owerflow question:
# http://stackoverflow.com/questions/26082444/how-to-work-around-travis-cis-4mb-output-limit
# Answer URL: http://stackoverflow.com/questions/26082444/how-to-work-around-travis-cis-4mb-output-limit/26082445#26082445
# Author: SHC (http://stackoverflow.com/users/1033422/shc)
set -e

export PING_SLEEP=30s
export WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export BUILD_OUTPUT=$WORKDIR/build.out

touch $BUILD_OUTPUT

dump_output() {
   echo Tailing the last 500 lines of output:
   tail -500 $BUILD_OUTPUT  
}
error_handler() {
  echo ERROR: An error was encountered with the build.
  dump_output
  kill $PING_LOOP_PID
  exit 1
}
# If an error occurs, run our error handler to output a tail of the build
trap 'error_handler' ERR

# Set up a repeating loop to send some output to Travis.

bash -c "while true; do echo \$(date) - building ...; sleep $PING_SLEEP; done" &
PING_LOOP_PID=$!

# Build command:
# your_build_command_1 >> $BUILD_OUTPUT 2>&1
# your_build_command_2 >> $BUILD_OUTPUT 2>&1
export FORCE_UNSAFE_CONFIGURE=1
make toolchain/install -j1 V=s >> $BUILD_OUTPUT 2>&1

# The build finished without returning an error so dump a tail of the output
dump_output

# nicely terminate the ping output loop
kill $PING_LOOP_PID
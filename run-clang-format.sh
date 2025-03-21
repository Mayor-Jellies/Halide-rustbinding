#!/bin/bash

set -e

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# We are currently standardized on using LLVM/Clang13 for this script.
# Note that this is totally independent of the version of LLVM that you
# are using to build Halide itself. If you don't have LLVM13 installed,
# you can usually install what you need easily via:
#
# sudo apt-get install llvm-13 clang-13 libclang-13-dev clang-tidy-13
# export CLANG_FORMAT_LLVM_INSTALL_DIR=/usr/lib/llvm-13

[ -z "$CLANG_FORMAT_LLVM_INSTALL_DIR" ] && echo "CLANG_FORMAT_LLVM_INSTALL_DIR must point to an LLVM installation dir for this script." && exit
echo CLANG_FORMAT_LLVM_INSTALL_DIR = ${CLANG_FORMAT_LLVM_INSTALL_DIR}

VERSION=$(${CLANG_FORMAT_LLVM_INSTALL_DIR}/bin/clang-format --version)
if [[ ${VERSION} =~ .*version\ 13.* ]]
then
    echo "clang-format version 13 found."
else
    echo "CLANG_FORMAT_LLVM_INSTALL_DIR must point to an LLVM 13 install!"
    exit 1
fi

# Note that we specifically exclude files starting with . in order
# to avoid finding emacs backup files
find "${ROOT_DIR}/apps" \
     "${ROOT_DIR}/src" \
     "${ROOT_DIR}/tools" \
     "${ROOT_DIR}/test" \
     "${ROOT_DIR}/util" \
     "${ROOT_DIR}/python_bindings" \
     \( -name "*.cpp" -o -name "*.h" -o -name "*.c" \) -and -not -wholename "*/.*" | \
     xargs ${CLANG_FORMAT_LLVM_INSTALL_DIR}/bin/clang-format -i -style=file

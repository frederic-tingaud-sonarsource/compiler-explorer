#!/usr/bin/env bash

set -eu

# Assuming this file is at the top of compiler-explorer repository.
GIT_TOP=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

# SONAR_CPP, LLVM_INSTALL, and SUBPROCESS can be user-provided to use custom paths if the default ones don't work for you.
SONAR_CPP="${SONAR_CPP:-"${GIT_TOP}/../sonar-cpp"}"

# Remove trailing slash from path to ensure it is correctly joined.
SONAR_CPP="${SONAR_CPP%/}"

# Fallback to Gradle extraction point for LLVM install.
LLVM_INSTALL=${LLVM_INSTALL:-"${SONAR_CPP}/toolchain/build/llvm-install"}
# Fallback to Gradle build directory for subprocess.
SUBPROCESS=${SUBPROCESS:-"${SONAR_CPP}/build/cmake/subprocess"}

for FILE in etc/config/c++.defaults.properties etc/config/compiler-explorer.defaults.properties run-sonar.sh
do
  TMP_FILE=$(mktemp)

  sed \
    -e "s@##SONAR_CPP##@${SONAR_CPP}@g" \
    -e "s@##SUBPROCESS##@${SUBPROCESS}@g" \
    -e "s@##LLVM_INSTALL##@${LLVM_INSTALL}@g" \
    -e "s@##GIT_TOP##@${GIT_TOP}@g" \
    "${GIT_TOP}/${FILE}" \
    > "${TMP_FILE}"

  # Ensure the files were configured.
  if cmp --quiet "${GIT_TOP}/${FILE}" "${TMP_FILE}"
  then
    echo "${FILE} was not properly configured." >&2
    exit 1
  fi

  mv "${TMP_FILE}" "${GIT_TOP}/${FILE}"
done

chmod u+x "${GIT_TOP}/run-sonar.sh"


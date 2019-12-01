#!/bin/bash

set -e

#HEADER

ARCHIVE_ROOT=$(dirname "$(readlink -f "$0")") # TODO: fix for nested binaries

# TODO: package fakechroot & chroot as statically linked here as well
fakechroot chroot "$ARCHIVE_ROOT" "$BINARY"

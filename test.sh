#!/bin/bash

set -e

. nix2standalone.sh

init /nix/store/z2fs34xkj1kvhckmq8ykn4w27f1l0y7h-firefox-70.0.1
wrap /nix/store/z2fs34xkj1kvhckmq8ykn4w27f1l0y7h-firefox-70.0.1/bin/firefox
package

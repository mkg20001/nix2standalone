#!/bin/bash

set -e

SELF=$(dirname "$(readlink -f $0)")

init() {
  pushd "$(mktemp -d)"

  INPUT="$1"

  FILES=$(nix-store -qR "$INPUT")
  FILES="$FILES ."

  NAME="$(basename $INPUT)"
}

package() {
  OUT="$NAME.tar.gz"
  find $FILES -print0 \
    | sort -z \
    | tar -cf "$OUT" \
          --format=posix \
          --numeric-owner \
          --owner=0 \
          --group=0 \
          --mode="go-rwx,u-rw" \
          --mtime='1970-01-01' \
          --no-recursion \
          --null \
          --gzip \
          --verbose \
          "--exclude=$OUT" \
          --files-from -

  pwd
}

w_new() {
  W_HEADER=""
}

w_add() {
  W_HEADER="$W_HEADER
$1"
}

w_add_e() {
  w_add "export $1='$2'"
}

w_add_v() {
  w_add "$1='$2'"
}

w_gen() {
  echo "#!/bin/bash
$W_HEADER"
  cat "$SELF/wrapper.sh" | sed "s|#!/bin/bash||g"
  W_HEADER=""
}

wrap() {
  REAL_PATH="$1"
  OUT_NAME="$2"

  if [ -z "$OUT_NAME" ]; then
    OUT_NAME=$(basename "$REAL_PATH")
  fi

  w_add_v "BINARY" "$REAL_PATH"

  mkdir -p "$(dirname "$OUT_NAME")"
  w_gen > "$OUT_NAME"
  chmod +x "$OUT_NAME"
}

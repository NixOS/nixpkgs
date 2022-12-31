source $stdenv/setup

set -euo pipefail

cp -r $src ./pier
chmod -R u+rw ./pier

urbit -d ./pier

cleanup () {
  if [ -f ./pier/.vere.lock ]; then
    kill $(< ./pier/.vere.lock) || true
  fi
}

trap cleanup EXIT

header "running +ivory"

port=$(cat ./pier/.http.ports | grep loopback | tr -s ' ' '\n' | head -n 1)

lensa() {
  # -f elided, this can hit server-side timeouts
  curl -s                                                              \
    --data "{\"source\":{\"dojo\":\"$2\"},\"sink\":{\"app\":\"$1\"}}"  \
    "http://localhost:$port" | xargs printf %s | sed 's/\\n/\n/g'
}

lensf() {
  # -f elided, this can hit server-side timeouts
  d=$(echo $1 | sed 's/\./\//g')
  curl -sJO                                                                   \
    --data "{\"source\":{\"dojo\":\"$2\"},\"sink\":{\"output-pill\":\"$d\"}}" \
    "http://localhost:$port"
}

lensf ivory.pill '+ivory'
lensa hood '+hood/exit'

stopNest

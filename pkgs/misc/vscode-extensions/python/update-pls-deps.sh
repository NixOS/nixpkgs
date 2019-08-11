#!/usr/bin/env bash
DIR=$(cd "$(dirname "$0")"; pwd)

(
cd $DIR
nix-shell -E 'with import ../../../.. {}; (callPackage ./. {extractNuGet = null;}).python-language-server' --run "
  mkdir -p /tmp/python-lang-server
  export depsScript="$(readlink -f ../../../servers/nosql/eventstore/create-deps.sh)"
  export depsNix="$(readlink -f ./python-language-server-deps.nix)"
  cd /tmp/python-lang-server
  rm -rf python-language-server*
  unpackPhase 
  cd python-language-server*
  cd src/LanguageServer/Impl
  dotnet nuget locals all --clear
  dotnet restore -v d > deps.log
  bash \$depsScript deps.log > \$depsNix
"
)

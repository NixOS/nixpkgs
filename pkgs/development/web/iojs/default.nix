{ stdenv, fetchurl, python, utillinux, nightly ? false }:

let
  version = if nightly then "1.1.1-nightly201502072c3121c606" else "1.1.0";
  inherit (stdenv.lib) optional maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "iojs-${version}";

  src = fetchurl {
    url = if nightly
          then "https://iojs.org/download/nightly/v${version}/iojs-v${version}.tar.gz"
          else "https://iojs.org/dist/v${version}/iojs-v${version}.tar.gz";
    sha256 = if nightly
             then "1jjh5f8kpcgdjjib9q1f2hqvrs6p4m4fyfbfy6dsdbzl2hglajvw"
             else "0yvz3rw7d73snc1g447l4amqbbyydbyzr9ynykmyld7l3gdsif7h";
  };

  prePatch = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i configure
  '';

  buildInputs = [ python ] ++ (optional stdenv.isLinux utillinux);
  setupHook = ../nodejs/setup-hook.sh;

  meta = {
    description = "A friendly fork of Node.js with an open governance model";
    homepage = https://iojs.org/;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

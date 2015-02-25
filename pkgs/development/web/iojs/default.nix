{ stdenv, fetchurl, python, utillinux, openssl, http-parser, zlib, libuv, nightly ? false }:

let
  version = if nightly then "1.2.1-nightly201502201bf91878e7" else "1.3.0";
  inherit (stdenv.lib) optional maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "iojs-${version}";

  src = fetchurl {
    url = if nightly
          then "https://iojs.org/download/nightly/v${version}/iojs-v${version}.tar.gz"
          else "https://iojs.org/dist/v${version}/iojs-v${version}.tar.gz";
    sha256 = if nightly
             then "1bk0jiha7n3s9xawj77d4q1navq28pq061w2wa6cs70lik7n6ri4"
             else "08g0kmz2978jrfx4551fi12ypcsv9p6vic89lfs08ki7ajw2yrgb";
  };

  prePatch = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i configure
  '';

  configureFlags = [ "--shared-openssl" "--shared-http-parser" "--shared-zlib" "--shared-libuv" ];

  buildInputs = [ python openssl http-parser zlib libuv ] ++ (optional stdenv.isLinux utillinux);
  setupHook = ../nodejs/setup-hook.sh;

  passthru.interpreterName = "iojs";

  meta = {
    description = "A friendly fork of Node.js with an open governance model";
    homepage = https://iojs.org/;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

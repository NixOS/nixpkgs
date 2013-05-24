{ stdenv, fetchurl, openssl, python, zlib, utillinux }:

stdenv.mkDerivation rec {
  version = "0.10.7";
  name = "nodejs-${version}";

  src = fetchurl {
    url = http://nodejs.org/dist/v0.10.7/node-v0.10.7.tar.gz;
    sha256 = "1q15siga6b3rxgrmy42310cdya1zcc2dpsrchidzl396yl8x5l92";
  };

  configureFlags = [
    "--openssl-includes=${openssl}/include"
    "--openssl-libpath=${openssl}/lib"
  ];

  # Expose the host compiler on darwin, which is the only compiler capable of building it
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    export OLDPATH=$PATH
    export PATH=/usr/bin:/usr/sbin:$PATH
  '';

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    export PATH=$OLDPATH
  '' + ''
    sed -e 's|^#!/usr/bin/env node$|#!'$out'/bin/node|' -i $out/lib/node_modules/npm/bin/npm-cli.js
  '';

  buildInputs = [ python openssl zlib ]
    ++ stdenv.lib.optional stdenv.isLinux utillinux;

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}

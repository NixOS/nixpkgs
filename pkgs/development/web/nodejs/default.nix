{ stdenv, fetchurl, openssl, python, zlib, v8, utillinux }:

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
  ]
  ++ (if !stdenv.isDarwin then [ # Shared V8 is broken on Mac OS X. Who can fix V8 on Darwin makes me very happy, but I gave up studying python-gyp.
    "--shared-v8"
    "--shared-v8-includes=${v8}/includes"
    "--shared-v8-libpath=${v8}/lib"
  ] else []);

  #patches = stdenv.lib.optional stdenv.isDarwin ./no-arch-flag.patch;

  # Expose the host compiler on darwin, which is the only compiler capable of building it
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    export OLDPATH=$PATH
    export PATH=/usr/bin:/usr/sbin:$PATH
  '';

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    export PATH=$OLDPATH
  '' + ''
    sed -e 's|^#!/usr/bin/env node$|#!'$out'/bin/node|' -i $out/lib/node_modules/npm/bin/npm-cli.js
  '' /*+ stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libv8.dylib ${v8}/lib/libv8.dylib $out/bin/node
  ''*/;

  buildInputs = [ python openssl zlib ]
    ++ stdenv.lib.optional stdenv.isLinux utillinux
    ++ stdenv.lib.optional (!stdenv.isDarwin) v8;
  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}

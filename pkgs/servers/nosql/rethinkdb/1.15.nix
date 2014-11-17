{ stdenv, fetchurl, fetchgit, which, protobuf, gperftools, boost, zlib, curl, python, m4, xterm
, nodejs, v8, writeText
, callPackage, utillinux
}:

let 
  inherit (stdenv) lib;
  nodePackages = callPackage (import ../../../top-level/node-packages.nix) {
    neededNatives = [python] ++ lib.optional (stdenv.isLinux) utillinux;
    self = nodePackages;
    generated = ./node-packages.nix;
  };

  src_v8 = rec {
    name = "v8-${version}";
    version = "3.22.24.17";

    src = fetchurl {
      url = "https://commondatastorage.googleapis.com/chromium-browser-official/"
          + "${name}.tar.bz2";
      sha256 = "17iwyfrim4b5jdzf6qfcs1shiwsl137sapbhlnx7d1qap98s5f6b";
    };
  }.src;

  v8_fetch = writeText "v8_fetch_pkg_fetch" ''
      pkg_fetch () {
        src_url=file://${src_v8}
        pkg_fetch_archive
        sed -i 's@/bin/bash@/bin/sh@' "$src_dir/build/gyp/gyp"
      }
  '';

in

stdenv.mkDerivation rec {
  name = "rethinkdb-1.15.x";

  src = fetchgit {
    url = https://github.com/rethinkdb/rethinkdb.git;
    rev = "refs/heads/v1.15.x";
    sha256 = "ca2e1b5a94786c65f66f5e977075f2b0b42e8d004dcc0b0864b6bb05d1036fc3";
  };

  preConfigure = ''
    # npm install wants to access $HOME/.npm which makes some locking fail,
    # thus provide a home directory
    HOME=$TMP/HOME
    mkdir $HOME

    export ALLOW_WARNINGS=1
    patchShebangs .
    cat ${v8_fetch} >> mk/support/pkg/v8.sh
    export LESSC=${nodePackages.less}/bin/lessc
    export COFFEE=${nodePackages.coffee-script}/bin/coffee
    export BROWSERIFY=${nodePackages.browserify}/bin/browserify
  '';

  configureFlags = "--lib-path ${gperftools}/lib --fetch v8";

  buildInputs = [ protobuf boost boost.lib zlib curl nodejs v8 which];

  nativeBuildInputs = [ which m4 python ];

  meta = {
    description = "An open-source distributed database built with love";
    longDescription = ''
      RethinkDB is built to store JSON documents, and scale to multiple machines with very little
      effort. It has a pleasant query language that supports really useful queries like table joins
      and group by, and is easy to setup and learn.
    '';
    homepage = http://www.rethinkdb.com;
    license = stdenv.lib.licenses.agpl3;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}

{ stdenv, fetchurl, perl, curl, bzip2, openssl ? null
, pkgconfig, boehmgc
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre24855";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/774404/download/4/${name}.tar.bz2";
    sha256 = "cd2a75a04fc03dcafbab1d183e6ee485b491e17f1680bb7ee38738a2b1235932";
  };

  buildNativeInputs = [ perl pkgconfig ];
  buildInputs = [ curl openssl boehmgc ];

  configureFlags =
    ''
      --with-store-dir=${storeDir} --localstatedir=${stateDir}
      --with-bzip2=${bzip2}
      --disable-init-state
      --enable-gc
      CFLAGS=-O3 CXXFLAGS=-O3
    '';

  crossAttrs = {
    configureFlags =
      ''
        --with-store-dir=${storeDir} --localstatedir=${stateDir}
        --with-bzip2=${bzip2.hostDrv}
        --disable-init-state
        CFLAGS=-O3 CXXFLAGS=-O3
      '';
    doCheck = false;
  };

  doCheck = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPLv2+";
  };
}

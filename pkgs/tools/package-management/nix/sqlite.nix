{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre25036";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/787041/download/4/${name}.tar.bz2";
    sha256 = "ccba5f44b75801187b766d4b98a53bccf335df35cde32aeab71630bfca7882f6";
  };

  buildInputs = [ perl curl openssl pkgconfig boehmgc ];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-bzip2=${bzip2} --with-sqlite=${sqlite}
    --disable-init-state
    --enable-gc
    CFLAGS=-O3 CXXFLAGS=-O3
  '';

  doCheck = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPLv2+";
  };
}

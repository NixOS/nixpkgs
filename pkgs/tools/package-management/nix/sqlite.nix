{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre24749";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/757682/download/4/${name}.tar.bz2";
    sha256 = "ab2bda296eb91a600d01a22ed4096acdf9b5d613f1155f98433d87e273a58970";
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

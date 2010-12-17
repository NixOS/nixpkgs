{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre25121";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/805927/download/4/${name}.tar.bz2";
    sha256 = "94e619e8b44f1172e71dc86d0aec1a557e76d49609e9a1fccbcea752360e3e97";
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

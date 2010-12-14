{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre25100";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/800113/download/4/${name}.tar.bz2";
    sha256 = "466f044c02c69f4eb8c572c762a057d7ee24e90e8836eab336bb5188a3901d56";
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

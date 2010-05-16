{ stdenv, fetchurl, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.16pre21778";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/408983/download/4/${name}.tar.bz2";
    sha256 = "54e154776efe05973aaf75b33f6e00987cd147d1cb7a2a132f4386d4b51c6bdc";
  };

  buildNativeInputs = [ perl ];
  buildInputs = [ curl openssl ];

  configureFlags =
    ''
      --with-store-dir=${storeDir} --localstatedir=${stateDir}
      --with-bzip2=${bzip2}
      --disable-init-state
      CFLAGS=-O3 CXXFLAGS=-O3
    '';

  doCheck = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPLv2+";
  };
}

{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.16pre21920";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/413218/download/4/${name}.tar.bz2";
    sha256 = "7d978a5d48a329c01d2af763ce6fc2038dbc24318e4ee57d873fa0c68d30f7ae";
  };

  buildInputs = [ perl curl openssl ];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-bzip2=${bzip2} --with-sqlite=${sqlite}
    --disable-init-state
    CFLAGS=-O3 CXXFLAGS=-O3
  '';

  doCheck = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPL";
  };
}

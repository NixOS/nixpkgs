{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre23559";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/614186/download/4/${name}.tar.bz2";
    sha256 = "5c7fd783effc9c570f6feb5631f94e369a37de6b4fb2f51459964e48c465dcfa";
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
    license = "LGPLv2+";
  };
}

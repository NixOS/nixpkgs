{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.16pre22953";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/527157/download/4/${name}.tar.bz2";
    sha256 = "7fe185f49bda5281274b203467d206a6a76a762f742a93adeca71ba63470f71e";
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

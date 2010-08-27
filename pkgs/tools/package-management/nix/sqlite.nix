{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre23431";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/605509/download/4/${name}.tar.bz2";
    sha256 = "63999912e1e139333f658cf1dd8fb80c8d894d127888067695b37e44e5d0ac07";
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

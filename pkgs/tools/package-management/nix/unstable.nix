{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc, perlPackages
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre29200";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/1320284/download/4/${name}.tar.bz2";
    sha256 = "a10f65b52bcf72b9ec7bf5610e16de2d49c1cc4c008bf0a93281e8e2233fa1b1";
  };

  buildNativeInputs = [ perl pkgconfig ];
  buildInputs = [ curl openssl boehmgc ];

  configureFlags =
    ''
      --with-store-dir=${storeDir} --localstatedir=${stateDir}
      --with-bzip2=${bzip2} --with-sqlite=${sqlite}
      --with-dbi=${perlPackages.DBI}/lib/perl5/site_perl
      --with-dbd-sqlite=${perlPackages.DBDSQLite}/lib/perl5/site_perl
      --disable-init-state
      --enable-gc
      CFLAGS=-O3 CXXFLAGS=-O3
    '';

  crossAttrs = {
    configureFlags =
      ''
        --with-store-dir=${storeDir} --localstatedir=${stateDir}
        --with-bzip2=${bzip2.hostDrv} --with-sqlite=${sqlite.hostDrv}
        --disable-init-state
        CFLAGS=-O3 CXXFLAGS=-O3
      '';
    doCheck = false;
  };

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPLv2+";
  };
}

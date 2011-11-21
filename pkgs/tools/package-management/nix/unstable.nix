{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc, perlPackages
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre30510";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/1563803/download/4/${name}.tar.bz2";
    sha256 = "22f6b686a47e136d48c0d3b91a1311a30d39539e1282c664872dca6967e91384";
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
        --enable-gc
        --with-dbi=${perlPackages.DBI}/lib/perl5/site_perl
        --with-dbd-sqlite=${perlPackages.DBDSQLite}/lib/perl5/site_perl
        --disable-init-state
        CFLAGS=-O3 CXXFLAGS=-O3
      '' + stdenv.lib.optionalString (
          stdenv.cross ? nix && stdenv.cross.nix ? system
      ) ''--with-system=${stdenv.cross.nix.system}'';
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

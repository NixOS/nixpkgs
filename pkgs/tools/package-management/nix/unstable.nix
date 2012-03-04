{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc, perlPackages
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.0pre2606_8afd28a";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/2183656/download/4/${name}.tar.bz2";
    sha256 = "4f21d01563ab9e949e09997ddaa89066c40a13b27e028a6fdffc67b97dd90dcb";
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

  # Hack to get the check to succeed on Darwin.
  phases = stdenv.lib.optionalString stdenv.isDarwin
    "$prePhases unpackPhase patchPhase $preConfigurePhases configurePhase $preBuildPhases buildPhase $preInstallPhases installPhase checkPhase fixupPhase $preDistPhases distPhase $postPhases";

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPLv2+";
  };
}

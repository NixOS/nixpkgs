{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc, perlPackages
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-1.8pre3766_809ca33";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/13584170/download/5/${name}.tar.xz";
    sha256 = "e6d91e73aabf8e8912f9701bf87b66089c197c5b8c8fbcc1707b888c88b96dfd";
  };

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ curl openssl sqlite ];

  propagatedBuildInputs = [ boehmgc ];

  # Note: bzip2 is not passed as a build input, because the unpack phase
  # would end up using the wrong bzip2 when cross-compiling.
  # XXX: The right thing would be to reinstate `--with-bzip2' in Nix.
  postUnpack =
    '' export CPATH="${bzip2}/include"
       export LIBRARY_PATH="${bzip2}/lib"
    '';

  configureFlags =
    ''
      --with-store-dir=${storeDir} --localstatedir=${stateDir} --sysconfdir=/etc
      --with-dbi=${perlPackages.DBI}/${perl.libPrefix}
      --with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}
      --with-www-curl=${perlPackages.WWWCurl}/${perl.libPrefix}
      --disable-init-state
      --enable-gc
      CFLAGS=-O3 CXXFLAGS=-O3
    '';

  makeFlags = "profiledir=$(out)/etc/profile.d";

  installFlags = "sysconfdir=$(out)/etc";

  doInstallCheck = true;

  crossAttrs = {
    postUnpack =
      '' export CPATH="${bzip2.crossDrv}/include"
         export NIX_CROSS_LDFLAGS="-L${bzip2.crossDrv}/lib -rpath-link ${bzip2.crossDrv}/lib $NIX_CROSS_LDFLAGS"
      '';

    configureFlags =
      ''
        --with-store-dir=${storeDir} --localstatedir=${stateDir}
        --with-dbi=${perlPackages.DBI}/${perl.libPrefix}
        --with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}
        --with-www-curl=${perlPackages.WWWCurl}/${perl.libPrefix}
        --disable-init-state
        --enable-gc
        CFLAGS=-O3 CXXFLAGS=-O3
      '' + stdenv.lib.optionalString (
          stdenv.cross ? nix && stdenv.cross.nix ? system
      ) ''--with-system=${stdenv.cross.nix.system}'';

    doInstallCheck = false;
  };

  enableParallelBuilding = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}

{ lib, stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, pkgconfig, boehmgc, perlPackages, libsodium
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

let

  common = { name, src }: stdenv.mkDerivation rec {
    inherit name src;

    outputs = [ "out" "doc" ];

    nativeBuildInputs = [ perl pkgconfig ];

    buildInputs = [ curl openssl sqlite ] ++
      lib.optional (stdenv.isLinux || stdenv.isDarwin) libsodium;

    propagatedBuildInputs = [ boehmgc ];

    # Note: bzip2 is not passed as a build input, because the unpack phase
    # would end up using the wrong bzip2 when cross-compiling.
    # XXX: The right thing would be to reinstate `--with-bzip2' in Nix.
    postUnpack =
      '' export CPATH="${bzip2}/include"
         export LIBRARY_PATH="${bzip2}/lib"
         export CXXFLAGS="-Wno-error=reserved-user-defined-literal"
      '';

    configureFlags =
      ''
        --with-store-dir=${storeDir} --localstatedir=${stateDir} --sysconfdir=/etc
        --with-dbi=${perlPackages.DBI}/${perl.libPrefix}
        --with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}
        --with-www-curl=${perlPackages.WWWCurl}/${perl.libPrefix}
        --disable-init-state
        --enable-gc
      '';

    makeFlags = "profiledir=$(out)/etc/profile.d";

    installFlags = "sysconfdir=$(out)/etc";

    doInstallCheck = false;

    separateDebugInfo = stdenv.isLinux;

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
        '' + stdenv.lib.optionalString (
            stdenv.cross ? nix && stdenv.cross.nix ? system
        ) ''--with-system=${stdenv.cross.nix.system}'';

      doInstallCheck = false;
    };

    enableParallelBuilding = true;

    meta = {
      description = "Powerful package manager that makes package management reliable and reproducible";
      longDescription = ''
        Nix is a powerful package manager for Linux and other Unix systems that
        makes package management reliable and reproducible. It provides atomic
        upgrades and rollbacks, side-by-side installation of multiple versions of
        a package, multi-user package management and easy setup of build
        environments.
      '';
      homepage = http://nixos.org/;
      license = stdenv.lib.licenses.lgpl2Plus;
      maintainers = [ stdenv.lib.maintainers.eelco ];
      platforms = stdenv.lib.platforms.all;
    };
  };

in rec {

   nix = nixStable;

   nixStable = common rec {
     name = "nix-1.10";
     src = fetchurl {
       url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
       sha256 = "5612ca7a549dd1ee20b208123e041aaa95a414a0e8f650ea88c672dc023d10f6";
     };
   };

   nixUnstable = lib.lowPrio (common rec {
     name = "nix-1.11pre4244_133a421";
     src = fetchurl {
       url = "http://hydra.nixos.org/build/26680779/download/4/${name}.tar.xz";
       sha256 = "cb98e3e0791c3f5a508990e8ddba02ce7fe9282a9fe151c743206c1410cdfd93";
     };
   });

}

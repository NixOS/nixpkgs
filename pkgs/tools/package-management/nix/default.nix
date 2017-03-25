{ lib, stdenv, fetchurl, fetchFromGitHub, perl, curl, bzip2, sqlite, openssl ? null, xz
, pkgconfig, boehmgc, perlPackages, libsodium, aws-sdk-cpp
, autoreconfHook, autoconf-archive, bison, flex, libxml2, libxslt, docbook5, docbook5_xsl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

let

  common = { name, suffix ? "", src, fromGit ? false }: stdenv.mkDerivation rec {
    inherit name src;
    version = lib.getVersion name;

    VERSION_SUFFIX = lib.optionalString fromGit suffix;

    outputs = [ "out" "dev" "man" "doc" ];

    nativeBuildInputs =
      [ perl pkgconfig ]
      ++ lib.optionals fromGit [ autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook5_xsl ];

    buildInputs = [ curl openssl sqlite xz ]
      ++ lib.optional (stdenv.isLinux || stdenv.isDarwin) libsodium
      ++ lib.optional ((stdenv.isLinux || stdenv.isDarwin) && lib.versionAtLeast version "1.12pre")
          (aws-sdk-cpp.override {
            apis = ["s3"];
            customMemoryManagement = false;
          });

    propagatedBuildInputs = [ boehmgc ];

    # Note: bzip2 is not passed as a build input, because the unpack phase
    # would end up using the wrong bzip2 when cross-compiling.
    # XXX: The right thing would be to reinstate `--with-bzip2' in Nix.
    postUnpack =
      '' export CPATH="${bzip2.dev}/include"
         export LIBRARY_PATH="${bzip2.out}/lib"
         export CXXFLAGS="-Wno-error=reserved-user-defined-literal"
      '';

    configureFlags =
      [ "--with-store-dir=${storeDir}"
        "--localstatedir=${stateDir}"
        "--sysconfdir=/etc"
        "--with-dbi=${perlPackages.DBI}/${perl.libPrefix}"
        "--with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}"
        "--disable-init-state"
        "--enable-gc"
      ]
      ++ lib.optional (!lib.versionAtLeast version "1.12pre") [
        "--with-www-curl=${perlPackages.WWWCurl}/${perl.libPrefix}"
      ];

    makeFlags = "profiledir=$(out)/etc/profile.d";

    installFlags = "sysconfdir=$(out)/etc";

    doInstallCheck = true;

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
    name = "nix-1.11.8";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "69e0f398affec2a14c47b46fec712906429c85312d5483be43e4c34da4f63f67";
    };
  };

  nixUnstable = lib.lowPrio (common rec {
    name = "nix-1.12${suffix}";
    suffix = "pre5073_1cf4801";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "1cf480110879ffc8aee94b4b75999da405b71d7c";
      sha256 = "1iwpddz0yni7cz2g9asj6nmrwhaai3rhfmkq954hph8nx02c3l02";
    };
    fromGit = true;
  });

}

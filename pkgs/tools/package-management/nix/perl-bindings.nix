{ stdenv, lib, nix, perl, pkgconfig, curl, libsodium
, autoreconfHook, autoconf-archive, perlPackages
}:

stdenv.mkDerivation {
  name = "nix-perl-" + nix.version;

  inherit (nix) src;

  postUnpack = "sourceRoot=$sourceRoot/perl";

  nativeBuildInputs =
    [ perl pkgconfig curl nix libsodium ]
    ++ lib.optionals nix.fromGit [ autoreconfHook autoconf-archive ];

  configureFlags =
  [ "--with-dbi=${perlPackages.DBI}/${perl.libPrefix}"
    "--with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}"
  ];

  preConfigure = "export NIX_STATE_DIR=$TMPDIR";

  preBuild = "unset NIX_INDENT_MAKE";
}

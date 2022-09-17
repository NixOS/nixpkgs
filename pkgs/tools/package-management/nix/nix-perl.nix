{ stdenv
, lib
, perl
, pkg-config
, curl
, nix
, libsodium
, boost
, autoreconfHook
, autoconf-archive
, nlohmann_json
, Security
}:

stdenv.mkDerivation {
  pname = "nix-perl";
  inherit (nix) version src;

  postUnpack = "sourceRoot=$sourceRoot/perl";

  buildInputs = lib.optional (stdenv.isDarwin) Security;

  # This is not cross-compile safe, don't have time to fix right now
  # but noting for future travellers.
  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    boost
    curl
    libsodium
    nix
    nlohmann_json
    perl
    pkg-config
  ];

  configureFlags = [
    "--with-dbi=${perl.pkgs.DBI}/${perl.libPrefix}"
    "--with-dbd-sqlite=${perl.pkgs.DBDSQLite}/${perl.libPrefix}"
  ];

  preConfigure = "export NIX_STATE_DIR=$TMPDIR";

  preBuild = "unset NIX_INDENT_MAKE";
}

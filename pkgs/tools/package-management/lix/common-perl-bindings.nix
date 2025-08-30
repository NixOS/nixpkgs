{
  lib,
  suffix ? "",
  version,
  src,
  patches ? [ ],
  ...
}@args:

{
  stdenv,
  lib,
  lix,
  boost,
  capnproto,
  perl,
  libsodium,
  meson,
  pkg-config,
  ninja,
}:

perl.pkgs.toPerlModule (
  stdenv.mkDerivation {
    pname = "lix-perl";
    version = "${version}${suffix}";
    inherit src patches;

    # sourceRoot doesn't work due to us wanting to apply patches at the root
    preConfigure = "cd perl";

    nativeBuildInputs = [
      pkg-config
      meson
      ninja
    ];

    buildInputs = [
      lix
      perl
      boost
      libsodium
      perl.pkgs.DBI
      perl.pkgs.DBDSQLite
      # for kj-async
      capnproto
    ];

    # point 'nix edit' and ofborg at the file that defines the attribute,
    # not this common file.
    pos = builtins.unsafeGetAttrPos "version" args;

    enableParallelBuilding = true;

    passthru = { inherit perl; };

    meta = {
      description = "Perl bindings for Lix";
      homepage = "https://git.lix.systems/lix-project/lix/src/branch/main/perl";
      license = lib.licenses.lgpl21Plus;
      teams = [ lib.teams.lix ];
      platforms = lib.platforms.unix;
      # perl version checking is grumpy and we could patch it but we want to kill <2.93 anyway
      broken = lib.versionOlder version "2.93";
    };
  }
)

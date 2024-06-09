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
, xz
, Security
, meson
, ninja
, bzip2
}:

let
  atLeast223 = lib.versionAtLeast nix.version "2.23";

  mkConfigureOption = { mesonOption, autoconfOption, value }:
    let
      setFlagTo = if atLeast223
        then lib.mesonOption mesonOption
        else lib.withFeatureAs true autoconfOption;
    in
    setFlagTo value;
in stdenv.mkDerivation (finalAttrs: {
  pname = "nix-perl";
  inherit (nix) version src;

  postUnpack = "sourceRoot=$sourceRoot/perl";

  buildInputs = [
    boost
    bzip2
    curl
    libsodium
    nix
    perl
    xz
  ] ++ lib.optional (stdenv.isDarwin) Security;

  # Not cross-safe since Nix checks for curl/perl via
  # NEED_PROG/find_program, but both seem to be needed at runtime
  # as well.
  nativeBuildInputs = [
    pkg-config
    perl
    curl
  ] ++ (if atLeast223 then [
    meson
    ninja
  ] else [
    autoconf-archive
    autoreconfHook
  ]);

  # `perlPackages.Test2Harness` is marked broken for Darwin
  doCheck = !stdenv.isDarwin;

  nativeCheckInputs = [
    perl.pkgs.Test2Harness
  ];

  ${if atLeast223 then "mesonFlags" else "configureFlags"} = [
    (mkConfigureOption {
      mesonOption = "dbi_path";
      autoconfOption = "dbi";
      value = "${perl.pkgs.DBI}/${perl.libPrefix}";
    })
    (mkConfigureOption {
      mesonOption = "dbd_sqlite_path";
      autoconfOption = "dbd-sqlite";
      value = "${perl.pkgs.DBDSQLite}/${perl.libPrefix}";
    })
  ] ++ lib.optionals atLeast223 [
    (lib.mesonEnable "tests" finalAttrs.doCheck)
  ];

  preConfigure = "export NIX_STATE_DIR=$TMPDIR";
})

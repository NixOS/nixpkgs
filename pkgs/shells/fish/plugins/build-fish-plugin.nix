{ stdenv, lib, writeScript, wrapFish }:

attrs@{
  pname,
  version,
  src,

  name ? "fishplugin-${pname}-${version}",
  unpackPhase ? "",
  configurePhase ? ":",
  buildPhase ? ":",
  preInstall ? "",
  postInstall ? "",

  checkInputs ? [],
  # plugin packages to add to the vendor paths of the test fish shell
  checkPlugins ? [],
  # vendor directories to add to the function path of the test fish shell
  checkFunctionDirs ? [],
  # test script to be executed in a fish shell
  checkPhase ? "",
  doCheck ? checkPhase != "",

  ...
}:

let
  # Do not pass attributes that are only relevant to buildFishPlugin to mkDerivation.
  drvAttrs = builtins.removeAttrs attrs [
    "checkPlugins"
    "checkFunctionDirs"
  ];
in

stdenv.mkDerivation (drvAttrs // {
  inherit name;
  inherit unpackPhase configurePhase buildPhase;

  inherit preInstall postInstall;
  installPhase = ''
    runHook preInstall

    (
      install_vendor_files() {
        source="$1"
        target="$out/share/fish/vendor_$2.d"

        [ -d $source ] || return 0
        mkdir -p $target
        cp -r $source/*.fish "$target/"
      }

      install_vendor_files completions completions
      install_vendor_files functions functions
      install_vendor_files conf conf
      install_vendor_files conf.d conf
    )

    runHook postInstall
  '';

  inherit doCheck;

  checkInputs = [ (wrapFish {
    pluginPkgs = checkPlugins;
    functionDirs = checkFunctionDirs;
  }) ] ++ checkInputs;

  checkPhase = ''
    export HOME=$(mktemp -d)  # fish wants a writable home
    fish "${writeScript "${name}-test" checkPhase}"
  '';
})

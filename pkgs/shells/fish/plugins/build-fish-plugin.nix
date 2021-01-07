{ stdenv, lib, writeShellScriptBin, writeScript, fish }:

let
  rtpPath = "share/fish";

  mapToFuncPath = v:
    if lib.isString v
    then v
    else "${v}/${rtpPath}/vendor_functions.d";

  fishWithFunctionPath = plugins: let
    funcPaths = map mapToFuncPath plugins;
  in writeShellScriptBin "fish" ''
    ${fish}/bin/fish \
      --init-command \
        "set --prepend fish_function_path ${lib.escapeShellArgs funcPaths}" \
      "$@"
  '';

in attrs@{
  pname,
  version,
  src,

  name ? "fishplugin-${pname}-${version}",
  unpackPhase ? "",
  configurePhase ? ":",
  buildPhase ? ":",
  preInstall ? "",
  postInstall ? "",
  # name of the subdirectory in which to store the plugin
  installPath ? lib.getName pname,

  checkInputs ? [],
  # plugins or paths to add to the function path of the test fish shell
  checkFunctionPath ? [],
  # test script to be executed in a fish shell
  checkPhase ? "",
  doCheck ? checkPhase != "",

  ...
}:

stdenv.mkDerivation (attrs // {
  inherit name;
  inherit unpackPhase configurePhase buildPhase;

  inherit preInstall postInstall;
  installPhase = ''
    runHook preInstall

    (
      install_vendor_files() {
        source="$1"
        target="$out/${rtpPath}/vendor_$2.d"

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
  checkInputs = [ (fishWithFunctionPath checkFunctionPath) ] ++ checkInputs;
  checkPhase = ''
    export HOME=$(mktemp -d)  # fish wants a writable home
    fish "${writeScript "${name}-test" checkPhase}"
  '';
})

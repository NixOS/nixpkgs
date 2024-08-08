{ stdenv, pkgs, lib, ... }:

let
  name = "xnode-personaliser";
  version = "0.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = name;
    rev = "16ac1d5862fffd18a4da185b6e6ef3ac0a3904cb";
    sha256 = "sha256-U+9oWxqqbAtXiaEQ/7li078LG130kOQ6KcbnEY9OAIs=";
  };
  inputs = with pkgs; [ jq curl gnugrep ];
  script = (pkgs.writeScriptBin name (builtins.readFile "${src}/src/xnode-personaliser.sh")).overrideAttrs(old: {
          buildCommand = "${old.buildCommand}\n patchShebangs $out";
        });
in
pkgs.symlinkJoin {
  name = name;
  version = version;

  buildInputs = [ pkgs.makeWrapper ];
  paths = [ script ] ++ inputs;
  postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";

  meta = with lib; {
    homepage = "https://openmesh.network/";
    description = "Installs a simple script that takes a script from any applicable personalisation interface (kernel cmdline base64/etc) and provides a well defined runtime environment.";
    mainProgram = "xnode-personaliser";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ j-openmesh ];
  };
}

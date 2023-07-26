{ lib, nimPackages, fetchFromGitHub, srcOnly, nim }:

nimPackages.buildNimPackage rec {
  pname = "nimlsp";
  version = "0.4.4";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "PMunch";
    repo = "nimlsp";
    rev = "v${version}";
    sha256 = "sha256-Z67iKlL+dnRbxdFt/n/fsUcb2wpZwzPpL/G29jfCaMY=";
  };

  buildInputs = with nimPackages; [ jsonschema asynctools ];

  nimFlags = [
    "--threads:on"
    "-d:explicitSourcePath=${srcOnly nimPackages.nim.passthru.nim}"
    "-d:tempDir=/tmp"
  ];

  nimDefines = [ "nimcore" "nimsuggest" "debugCommunication" "debugLogging" ];

  doCheck = false;

  meta = with lib; {
    description = "Language Server Protocol implementation for Nim";
    homepage = "https://github.com/PMunch/nimlsp";
    license = licenses.mit;
    platforms = nim.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}

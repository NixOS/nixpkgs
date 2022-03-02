{ lib, nimPackages, fetchFromGitHub, srcOnly, nim }:

nimPackages.buildNimPackage rec {
  pname = "nimlsp";
  version = "0.4.0";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "PMunch";
    repo = "nimlsp";
    rev = "v${version}";
    sha256 = "sha256-eih8JmofLFXkidanRocjtA6wv84HkA1bi0M4dxkiDr4=";
  };

  buildInputs = with nimPackages; [ jsonschema ];

  nimFlags = [
    "--threads:on"
    "-d:explicitSourcePath=${srcOnly nimPackages.nim.passthru.nim}"
    "-d:tempDir=/tmp"
  ];

  nimDefines = [ "nimcore" "nimsuggest" "debugCommunication" "debugLogging" ];

  meta = with lib; {
    description = "Language Server Protocol implementation for Nim";
    homepage = "https://github.com/PMunch/nimlsp";
    license = licenses.mit;
    platforms = nim.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}

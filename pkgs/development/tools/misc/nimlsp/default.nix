{ lib, nimPackages, fetchFromGitHub, srcOnly, nim }:

nimPackages.buildNimPackage rec {
  pname = "nimlsp";
  version = "0.3.2";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "PMunch";
    repo = "nimlsp";
    rev = "v${version}";
    sha256 = "1lm823nvpp3bj9527jd8n1jxh6y8p8ngkfkj91p94m7ffai6jazq";
  };

  buildInputs = with nimPackages; [ astpatternmatching jsonschema ];

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

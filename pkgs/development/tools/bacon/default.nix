{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G1vds0156dYTxB6I155NiTuI9JnqZ7Uh3f5vHNTOMsk=";
  };

  cargoSha256 = "sha256-ytS+U+Tbyz2cMgXN/rZ5Kf4WgoIr8RIuBwLLUJ2XtHU=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}

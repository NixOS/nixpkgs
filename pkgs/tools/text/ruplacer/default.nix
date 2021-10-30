{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "ruplacer";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "TankerHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gme/p/F+LvfzynPNKmaPbNsKbwNKFCeEbAADk5PyMh8=";
  };

  cargoSha256 = "sha256-/37TBl/FnCtkiufusPuJIpirD2WVO882xSqrfWVMNW0=";

  buildInputs = (lib.optional stdenv.isDarwin Security);

  meta = with lib; {
    description = "Find and replace text in source files";
    homepage = "https://github.com/TankerHQ/ruplacer";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

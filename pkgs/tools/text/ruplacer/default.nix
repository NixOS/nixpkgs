{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "ruplacer";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "TankerHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rndWKi/EDQzTWAw2deddhTXdmIfuEVM54MOfS4mNf+Y=";
  };

  cargoHash = "sha256-DkhmMdpUcka6Wkyz6hEfqB2gUpsGNziGv+23rVfwXN8=";

  buildInputs = (lib.optional stdenv.isDarwin Security);

  meta = with lib; {
    description = "Find and replace text in source files";
    mainProgram = "ruplacer";
    homepage = "https://github.com/TankerHQ/ruplacer";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

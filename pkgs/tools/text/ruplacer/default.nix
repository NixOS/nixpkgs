{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "ruplacer";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "TankerHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-N71oiOlhMMDq0VhujV4SgnnKMQRi5SdplrTjK2vyhUE=";
  };

  cargoHash = "sha256-EyLompGEin12q6SC1M1D0QsE42HVEq5O/E99qi54cGo=";

  buildInputs = (lib.optional stdenv.hostPlatform.isDarwin Security);

  meta = with lib; {
    description = "Find and replace text in source files";
    mainProgram = "ruplacer";
    homepage = "https://github.com/TankerHQ/ruplacer";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, IOKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "oxigraph";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BiPK0eFlKtGQ7m0LaVeeXp5gz+C1UW0JK7L8Nc21rKU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-VGXnUdJDbD8bGdXRbIkC4wgAmSUK2gh/XEYLaPfaaLg=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit Security ];

  cargoBuildFlags = [ "--package" "oxigraph_server" ];

  # requires packaging of the associated python modules
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/oxigraph/oxigraph";
    description = "SPARQL graph database";
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    maintainers = with maintainers; [ astro ];
    license = with licenses; [ asl20 mit ];
  };
}

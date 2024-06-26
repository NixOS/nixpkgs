{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "code-minimap";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d9qcSSiRv1I7NYuLrra5ShIUXT2HVeHGD0WPb+dnQCc=";
  };

  cargoHash = "sha256-5/UgEzkJw9XDgtS1jKyWh5ijTp3L+UQLuE5CXcyIgTs=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "High performance code minimap render";
    homepage = "https://github.com/wfxr/code-minimap";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ bsima ];
    mainProgram = "code-minimap";
  };
}

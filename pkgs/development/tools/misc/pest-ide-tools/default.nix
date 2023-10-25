{ lib
, fetchFromGitHub
, rustPlatform
, nix-update-script
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "pest-ide-tools";
  version = "0.3.6";
  cargoSha256 = "sha256-uFcEE5Hlb0fhOH0birqeH+hOuAyZVjQOYFhoMdR8czM=";

  src = fetchFromGitHub {
    owner = "pest-parser";
    repo = "pest-ide-tools";
    rev = "v${version}";
    sha256 = "sha256-SymtMdj7QVOEiSeTjmVidejFeGK8swnM6nfT7u18URs=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "IDE support for Pest, via the LSP.";
    homepage = "https://pest.rs";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ nickhu ];
    mainProgram = "pest-language-server";
  };
}

{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  nix-update-script,
  Security,
  SystemConfiguration,
  openssl,
}:

let
  pname = "gptcommit";
  version = "0.5.17";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zurawiki";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MB78QsJA90Au0bCUXfkcjnvfPagTPZwFhFVqxix+Clw=";
  };

  cargoHash = "sha256-F4nabUeQZMnmSNC8KlHjx3IcyR2Xn36kovabmJ6g1zo=";

  nativeBuildInputs = [ pkg-config ];

  # 0.5.6 release has failing tests
  doCheck = false;

  buildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Git prepare-commit-msg hook for authoring commit messages with GPT-3.";
    mainProgram = "gptcommit";
    homepage = "https://github.com/zurawiki/gptcommit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; all;
  };
}

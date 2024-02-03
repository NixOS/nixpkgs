{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "twm";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gvo5+lZNe5QOHNI4nrPbCR65D+VFf/anmLVdu5RXJiY=";
  };

  cargoHash = "sha256-5+1B+SbrIrswGjtNLlwbtLEhARMZNs75DFK8wQI2O0M=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A customizable workspace manager for tmux";
    homepage = "https://github.com/vinnymeller/twm";
    changelog = "https://github.com/vinnymeller/twm/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
    mainProgram = "twm";
  };
}

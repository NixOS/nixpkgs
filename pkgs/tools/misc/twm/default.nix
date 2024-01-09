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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r9l5gNWoIkKHzjHOCK7qnPLfg6O+km7OX+6pHQKhN6g=";
  };

  cargoHash = "sha256-0nCMgfnEqr0D3HpocUN/Hc9tG9byu2CYvBy/8vIU+bI=";

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

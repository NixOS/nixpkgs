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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Q8WdNmO5uSm4PvitBXQ7YEkjJhlCz4qfJO/F6+XckXY=";
  };

  cargoHash = "sha256-fxDUUfC7mBgVHN+M6pb5leRp28wzO69ZdStdYmQFxQE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A customizable workspace manager for tmux";
    homepage = "https://github.com/vinnymeller/twm";
    changelog = "https://github.com/vinnymeller/twm/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ vinnymeller ];
  };
}

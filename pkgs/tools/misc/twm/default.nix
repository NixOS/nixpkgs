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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OUaT/JMh4JgFbzIYlU34EN7gxEydNKBXSLJfYKOeck4=";
  };

  cargoHash = "sha256-VGbY3QRkO4znEGs2daUhpDeNntONwvGeUg1ryFyWmjE=";

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

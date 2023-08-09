{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ares-rs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "bee-san";
    repo = "ares";
    rev = "refs/tags/${version}";
    hash = "sha256-F+uBGRL1G8kiNZUCsiPbISBfId5BPwShenusqkcsHug=";
  };

  cargoHash = "sha256-7zDq66oWT+j6t9LEBUoeby8MQ1Ihhvk3KLwWPQAThyc=";

  meta = with lib; {
    description = "Automated decoding of encrypted text without knowing the key or ciphers used";
    homepage = "https://github.com/bee-san/ares";
    changelog = "https://github.com/bee-san/Ares/releases/tag${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ares";
  };
}

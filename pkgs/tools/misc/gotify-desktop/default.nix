{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config}:

rustPlatform.buildRustPackage rec {
  pname = "gotify-desktop";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = pname;
    rev = version;
    sha256 = "sha256-QQpZeXFv8BqFOQ+7ANWmtsgNlMakAL2ML4rlG2cFZJE=";
  };

  cargoSha256 = "sha256-zcSAsI/yGGJer7SPKDKZ6NQ3UgTdBcDighS6VTNITMo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Small Gotify daemon to send messages as desktop notifications";
    homepage = "https://github.com/desbma/gotify-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bryanasdev000 genofire ];
  };
}

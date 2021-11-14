{ lib, rustPlatform, openssl, pkg-config, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cliscord";
  version = "unstable-2020-12-08";

  src = fetchFromGitHub {
    owner = "somebody1234";
    repo = pname;
    rev = "b02fbe5516fd7f153d0b0e3c7d5d11e2ab651b43";
    sha256 = "sha256-hzZozgOkw8kFppuHiX9TQxHhxKRv8utWWbhEOIzKDLo=";
  };

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "12zfwdssyv0j83bff6s4376d99pv7z8ya8q8adwmf5ayvgmj4xz4";

  meta = with lib; {
    description = "Simple command-line tool to send text and files to discord";
    homepage = "https://github.com/somebody1234/cliscord";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
    mainProgram = "cliscord";
  };
}

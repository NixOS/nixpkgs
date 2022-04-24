{ lib
, dbus
, fetchFromGitHub
, libssh
, openssl
, pkg-config
, rustPlatform
, Foundation
, Security
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "termscp";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WqOkud8gOa81P6FT44y5RZX4CWjmou9HufZ3QPoYuAk=";
  };

  cargoSha256 = "sha256-jckJiFhiUvbn0fkgKzqDorWQvuLenx/S8+RyPoqaWUg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    libssh
    openssl
  ] ++ lib.optional stdenv.isDarwin [
    Foundation
    Security
  ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Terminal tool for file transfer and explorer";
    homepage = "https://github.com/veeso/termscp";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

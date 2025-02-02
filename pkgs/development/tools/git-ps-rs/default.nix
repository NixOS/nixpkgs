{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, pkg-config
, dbus
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-ps-rs";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "uptech";
    repo = "git-ps-rs";
    rev = version;
    hash = "sha256-HkiCc/5Xx+1IKMz/vXPXwUp3c8qSjobhQaIJCzq8dqQ=";
  };

  cargoHash = "sha256-r4cmnLkW8ocTcTECAbCk3S94T09lOUzHLQIGHv97W54=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl dbus ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Tool for working with a stack of patches";
    mainProgram = "gps";
    homepage = "https://git-ps.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ alizter ];
  };
}

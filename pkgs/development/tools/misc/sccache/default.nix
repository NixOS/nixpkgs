{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  version = "0.5.2";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
    sha256 = "sha256-CriVsjxbfe3iJ0FD9HAve3QunBt3rWkzWqQDuJcPR9A=";
  };

  cargoSha256 = "sha256-/pr+YT0ZejF0EpxZUlUBS21crtuhE/M222kvLAXaoyU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # Tests fail because of client server setup which is not possible inside the pure environment,
  # see https://github.com/mozilla/sccache/issues/460
  doCheck = false;

  meta = with lib; {
    description = "Ccache with Cloud Storage";
    homepage = "https://github.com/mozilla/sccache";
    changelog = "https://github.com/mozilla/sccache/releases/tag/v${version}";
    maintainers = with maintainers; [ doronbehar figsoda ];
    license = licenses.asl20;
  };
}

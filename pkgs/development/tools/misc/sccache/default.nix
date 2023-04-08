{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  version = "0.4.1";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
    sha256 = "sha256-omov7/o1ToWJBTsDXTp3FNLk7PuWGL3J6pNz6n47taU=";
  };

  cargoSha256 = "sha256-UkccHrs3q4MlIaK/lo+bPC9Jy/JCBjGzo8jgjZsvEIc=";

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

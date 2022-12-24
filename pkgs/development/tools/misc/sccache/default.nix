{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  version = "0.4.0-pre.2";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
    sha256 = "sha256-l397KpdsQR6HSjmvLNlNGbI5IRas6xrd+UZKTv2ycig=";
  };

  cargoSha256 = "sha256-z0TXkqW3cN4h/5fhsh0xl78c2Rf5drUIOk0QO8fo04Y=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # sccache-dist is only supported on x86_64 Linux machines.
  buildFeatures = lib.optionals (stdenv.system == "x86_64-linux") [ "dist-client" "dist-server" ];

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

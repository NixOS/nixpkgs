{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  version = "0.3.1";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
    sha256 = "sha256-SjGtFkFyHJRnFg3QwXksrV+T08oku80vcivLzFWt94g=";
  };

  cargoSha256 = "sha256-cd/4otvrneOqntBzNZP1/RY0jg/NYeugiblr1tatITI=";

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
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.asl20;
  };
}

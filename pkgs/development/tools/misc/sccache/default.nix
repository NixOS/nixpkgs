{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  version = "0.7.5";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
    sha256 = "sha256-rql5Nj/w7cNaO6UKK96vYYE2E19RIiCHYHTnbW+U4n8=";
  };

  cargoHash = "sha256-VdI39DgQrUZhoawMqBC6ngTvldW+QbDjMjxjjbH9G1A=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # Tests fail because of client server setup which is not possible inside the
  # pure environment, see https://github.com/mozilla/sccache/issues/460
  doCheck = false;

  meta = with lib; {
    description = "Ccache with Cloud Storage";
    homepage = "https://github.com/mozilla/sccache";
    changelog = "https://github.com/mozilla/sccache/releases/tag/v${version}";
    maintainers = with maintainers; [ doronbehar figsoda ];
    license = licenses.asl20;
  };
}

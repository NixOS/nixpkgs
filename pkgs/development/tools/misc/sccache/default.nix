{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  version = "0.7.6";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
    sha256 = "sha256-dIUwooXphjXpFMZXpwQMSvXRvVt/y6J5X7oCrBBSvBM=";
  };

  cargoHash = "sha256-GDODIAyTIZUHw2tUEQfNnnPH2S9pFHIjYEZLpM5E52A=";

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

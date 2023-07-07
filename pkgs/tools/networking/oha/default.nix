{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-IMr4CAh+XyPnv1GToZVZVpMi0eI565N6W9DivmivU70=";
  };

  cargoSha256 = "sha256-AXm9tNv0buR40B8cWZRaSvbYXwqalwqJZnBAwrjvBiY=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # tests don't work inside the sandbox
  doCheck = false;

  meta = with lib; {
    description = "HTTP load generator inspired by rakyll/hey with tui animation";
    homepage = "https://github.com/hatoo/oha";
    changelog = "https://github.com/hatoo/oha/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

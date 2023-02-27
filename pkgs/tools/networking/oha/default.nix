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
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-lk4CePSvJb8W/3TAWyRhMcUUi7ZRdIs097Ny0ipXIuc=";
  };

  cargoSha256 = "sha256-cBtK/38b+W4GKiH+u9ouT52tapGUcPsHfC4DlNDHyjg=";

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

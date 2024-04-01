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
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-r5jYHs+oVflgFTQZpKvdNs56TmZtyljZKDJMVP+iUNY=";
  };

  cargoHash = "sha256-Q3ixlB/P/99h6ZuT37KrM9fxyBzcmlmM5jw6xDT2lPE=";

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
    mainProgram = "oha";
  };
}

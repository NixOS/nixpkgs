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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mjQyeotXKF1hohSmPisshR8Cap9K/IEE55cYSk/QxQE=";
  };

  cargoHash = "sha256-JZIuKUky8D9Q+1JZQ4Vg8GF6Qkh9hG/FebpqyRzPOcA=";

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

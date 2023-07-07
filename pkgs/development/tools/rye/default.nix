{ lib
, fetchFromGitHub
, rustPlatform
, git
, openssl
, pkg-config
, stdenv
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "rye";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = pname;
    rev = version;
    # One of the tests runs git command so we need .git directory there
    leaveDotGit = true;
    sha256 = "llm4aqMfaVf3VbHudWjb9V2GFgJpP9S211Ui7xXdrAU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dialoguer-0.10.4" = "sha256-WDqUKOu7Y0HElpPxf2T8EpzAY3mY8sSn9lf0V0jyAFc=";
    };
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    git
    openssl
  ]
  ++ lib.optional stdenv.isDarwin SystemConfiguration;

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "A tool to easily manage python dependencies and environments";
    homepage = "https://github.com/mitsuhiko/rye";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}

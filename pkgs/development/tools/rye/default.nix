{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, Libsystem
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "rye";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-00Q+qvK1fq9CGb6umtCiUJZZ1M5LMxiSIM3/s7eOumM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dialoguer-0.10.4" = "sha256-WDqUKOu7Y0HElpPxf2T8EpzAY3mY8sSn9lf0V0jyAFc=";
      "monotrail-utils-0.0.1" = "sha256-4x5jnXczXnToU0QXpFalpG5A+7jeyaEBt8vBwxbFCKQ=";
    };
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isDarwin [
    Libsystem
    SystemConfiguration
  ];

  checkFlags = [
    "--skip=utils::test_is_inside_git_work_tree"
  ];

  meta = with lib; {
    description = "A tool to easily manage python dependencies and environments";
    homepage = "https://github.com/mitsuhiko/rye";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}

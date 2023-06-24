{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, sqlite
}:

rustPlatform.buildRustPackage rec {
  pname = "autokernel";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "autokernel";
    rev = "v${version}";
    hash = "sha256-upiENXRYVSZMPLcb9DeUx0FR97rMbW/sEAlYKi9dvI4=";
  };

  cargoHash = "sha256-yE9vIcy4OJrGyQPWnUAIyliiVsNews/CZfxwTmudXyU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
  ];

  doCheck = false;

  meta = with lib; {
    description = "A tool for managing your kernel configuration that guarantees semantic correctness";
    homepage = "https://github.com/oddlama/autokernel";
    changelog = "https://github.com/oddlama/autokernel/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ oddlama janik ];
  };
}

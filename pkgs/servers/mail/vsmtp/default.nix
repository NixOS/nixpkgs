{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
, openssl
, testers
, vsmtp
}:

rustPlatform.buildRustPackage rec {
  pname = "vsmtp";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "viridIT";
    repo = "vsmtp";
    rev = "v${version}";
    hash = "sha256-nBkfIjACmjnVNF3hJ22B4ecjWrX9licV7c8Yxv2tQCg=";
  };

  cargoHash = "sha256-HqQ8WD1/K7xMx97SbuP45Q/+4oADh1WZFJPXB8wlkbM=";

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ openssl ];

  cargoBuildFlags = [
    "--package"
    "vsmtp"
    "--package"
    "vqueue"
  ];

  postInstall = ''
    installManPage tools/install/man/*.1
  '';

  passthru = {
    tests.version = testers.testVersion { package = vsmtp; version = "v${version}"; };
  };

  meta = with lib; {
    description = "A next-gen mail transfer agent (MTA) written in Rust";
    homepage = "https://viridit.com";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nickcao ];
  };
}

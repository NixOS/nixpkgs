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
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "viridIT";
    repo = "vsmtp";
    rev = "v${version}";
    hash = "sha256-pY/CjdrRlZ2+z82RngLQ8jXQwZl9wy9phQG4/4uXCKA=";
  };

  cargoHash = "sha256-7nDSTzZRjMbjhVNk3mqeQ8JemA62yCUMvhRwjkPlWn0=";

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

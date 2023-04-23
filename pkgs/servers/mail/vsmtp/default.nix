{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, testers
, vsmtp
}:

rustPlatform.buildRustPackage rec {
  pname = "vsmtp";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "viridIT";
    repo = "vsmtp";
    rev = "v${version}";
    hash = "sha256-dRw5Q6bejaAJCnoR9j2wBU+L+p1pk1Tnxtm0WcRyOaY=";
  };

  cargoHash = "sha256-RYHn9kZZApgXWTExAHl9ZnCsuvqnnb67unmvd4Pnwz0=";

  nativeBuildInputs = [ installShellFiles ];

  buildFeatures = [
    "telemetry"
    "journald"
    "syslog"
  ];

  # tests do not run well in the nix sandbox
  doCheck = false;

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

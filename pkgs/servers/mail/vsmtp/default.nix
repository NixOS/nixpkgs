{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, testers
, vsmtp
}:

rustPlatform.buildRustPackage rec {
  pname = "vsmtp";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "viridIT";
    repo = "vsmtp";
    rev = "v${version}";
    hash = "sha256-iyjtSeus1gctylYfXAEqpwZNPg/KU/lXv82Wi0h5mAM=";
  };

  cargoHash = "sha256-N4cxAFAFtYnd1/wdomm0VYosDY5uy+0z9pRGThSMbG4=";

  nativeBuildInputs = [ installShellFiles ];

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

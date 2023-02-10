{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, testers
, vsmtp
}:

rustPlatform.buildRustPackage rec {
  pname = "vsmtp";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "viridIT";
    repo = "vsmtp";
    rev = "v${version}";
    hash = "sha256-FI4BvU+83nTzRLJQZ1l1eOn41ZeA62Db+p3d//5o0Wk=";
  };

  cargoHash = "sha256-Qhhh0riM1qeD3/JZINvY0t5fEOj+prI0fyXagdR43sc=";

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

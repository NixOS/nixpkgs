{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, testers
, vsmtp
}:

rustPlatform.buildRustPackage rec {
  pname = "vsmtp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "viridIT";
    repo = "vsmtp";
    rev = "v${version}";
    hash = "sha256-uyu2NpHFDqJDcfQukG6TdRH7KuZnrYTULvLiABdvAog=";
  };

  cargoHash = "sha256-A0Q6ciZJL13VzJgZIWZalrRElSNGHUN/9b8Csj4Tdak=";

  nativeBuildInputs = [ installShellFiles ];

  # too many upstream failures
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

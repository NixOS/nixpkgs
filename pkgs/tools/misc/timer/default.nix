{ lib, buildGoModule, fetchFromGitHub, testers, timer }:

buildGoModule rec {
  pname = "timer";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "timer";
    rev = "v${version}";
    hash = "sha256-mA52lrtChPbEeZr7kh1RYJ8yTqe7PaShqQ/0aJ+o83E=";
  };

  vendorHash = "sha256-bLGP9xAs0V6ttaU2duQVeiX7TQi/TX7Kjawh9nmtsl4=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests.version = testers.testVersion { package = timer; };

  meta = with lib; {
    description = "`sleep` with progress";
    homepage = "https://github.com/caarlos0/timer";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq caarlos0 ];
    mainProgram = "timer";
  };
}

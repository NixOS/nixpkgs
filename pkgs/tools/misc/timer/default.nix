{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  timer,
}:

buildGoModule rec {
  pname = "timer";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "timer";
    rev = "v${version}";
    hash = "sha256-8BVzijAXsJ8Q8BhDmhzFbEQ23fUEBdmbUsCPxfpXyBA=";
  };

  vendorHash = "sha256-1n5vZKlOWoB2SFdDdv+pPWLybzCIJG/wdBYqLMatjNA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion { package = timer; };

  meta = with lib; {
    description = "A `sleep` with progress";
    homepage = "https://github.com/caarlos0/timer";
    license = licenses.mit;
    maintainers = with maintainers; [
      zowoq
      caarlos0
    ];
    mainProgram = "timer";
  };
}

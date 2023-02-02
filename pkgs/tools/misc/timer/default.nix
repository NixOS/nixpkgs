{ lib, buildGoModule, fetchFromGitHub, testers, timer }:

buildGoModule rec {
  pname = "timer";
  version = "unstable-2023-02-01";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "timer";
    rev = "1f437baceb1ca76b341fdc229fe45938b282f2aa";
    hash = "sha256-u+naemEiKufKYROuJB55u8QgiIgg4nLsB+FerUImtXs=";
  };

  vendorHash = "sha256-n4AjaojcDAYbgOIuaAJ4faVJqV+/0uby5OHRMsyL9Dg=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = timer;
  };

  meta = with lib; {
    description = "A `sleep` with progress";
    homepage = "https://github.com/caarlos0/timer";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}

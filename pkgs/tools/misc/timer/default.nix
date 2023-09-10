{ lib, buildGoModule, fetchFromGitHub, testers, timer }:

buildGoModule rec {
  pname = "timer";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "timer";
    rev = "v${version}";
    hash = "sha256-9p/L3Hj3VqlNiyY3lfUAhCjwTl1iSTegWxaVEGB4qHM=";
  };

  vendorHash = "sha256-j7Xik0te6GdjfhXHT7DRf+MwM+aKjfgTGvroxnlD3MM=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests.version = testers.testVersion { package = timer; };

  meta = with lib; {
    description = "A `sleep` with progress";
    homepage = "https://github.com/caarlos0/timer";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq caarlos0 ];
  };
}

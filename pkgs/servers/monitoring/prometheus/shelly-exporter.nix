{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "shelly_exporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aexel90";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L0TuBDq5eEahQvzqd1WuvmXuQbbblCM+Nvj15IybnVo=";
  };

  vendorHash = "sha256-BCrge2xLT4b4wpYA+zcsH64a/nfV8+HeZF7L49p2gEw=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) shelly;
  };

  meta = with lib; {
    description = "Shelly humidity sensor exporter for prometheus";
    mainProgram = "shelly_exporter";
    homepage = "https://github.com/aexel90/shelly_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ drupol ];
  };
}

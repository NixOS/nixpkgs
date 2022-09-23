{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "konf";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "SimonTheLeg";
    repo = "konf-go";
    rev = "v${version}";
    hash = "sha256-n8WJyihpbtci8Q6zUapwrpTrVZVAS53OpnwAsv6w1FY=";
  };

  vendorHash = "sha256-sB3j19HrTtaRqNcooqNy8vBvuzxxyGDa7MOtiGoVgN8=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Lightweight and blazing fast kubeconfig manager which allows to use different kubeconfigs at the same time";
    homepage = "https://github.com/SimonTheLeg/konf-go";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
  };
}

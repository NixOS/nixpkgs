{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nut-exporter";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "nut_exporter";
    rev = "v${version}";
    sha256 = "sha256-Y8G8nFhZ9Onxx40DJSTi0rnef8ulNTkj4bsPfqylOjQ=";
  };

  vendorHash = "sha256-DGCNYklINPPzC7kCdEUS7TqVvg2SnKFqe0qHs5RSmzY=";

  meta = with lib; {
    description = "Prometheus exporter for Network UPS Tools";
    homepage = "https://github.com/DRuggeri/nut_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ jhh ];
  };
}

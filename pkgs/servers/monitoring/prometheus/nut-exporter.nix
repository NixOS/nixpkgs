{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nut-exporter";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "nut_exporter";
    rev = "v${version}";
    sha256 = "sha256-izD2Ks29/4/FBsZoH0raFzqb0DgPR8hXRYBZQEvET+s=";
  };

  vendorHash = "sha256-DGCNYklINPPzC7kCdEUS7TqVvg2SnKFqe0qHs5RSmzY=";

  meta = with lib; {
    description = "Prometheus exporter for Network UPS Tools";
    mainProgram = "nut_exporter";
    homepage = "https://github.com/DRuggeri/nut_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ jhh ];
  };
}

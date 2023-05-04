{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "exhaustive";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "nishanths";
    repo = "exhaustive";
    rev = "v${version}";
    hash = "sha256-vMoFIyZcAdObeQD5bGcQHlGpJv/a8yl/2HUVc8aDiIA=";
  };

  vendorHash = "sha256-i3Cgefe4krvH99N233IeEWkVt9AhdzROkJ5JBeTIaAs=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Check exhaustiveness of switch statements of enum-like constants in Go code";
    homepage = "https://github.com/nishanths/exhaustive";
    license = licenses.bsd2;
    maintainers = with maintainers; [ meain ];
  };
}

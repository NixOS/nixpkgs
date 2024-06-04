{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "modemmanager-exporter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "modemmanager_exporter";
    rev = "v${version}";
    sha256 = "sha256-wQATmTjYsm1J2DicPryoa/jVpbLjXz+1TTQUH5yGV6w=";
  };

  vendorHash = "sha256-wGCRpFnt9bxc5Ygg6H1kI9sXB4mVFBdLeaahAFtvNbg=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) modemmanager; };

  meta = with lib; {
    homepage = "https://github.com/mdlayher/modemmanager_exporter";
    description = "Prometheus exporter for ModemManager and its devices";
    mainProgram = "modemmanager_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ mdlayher ];
  };
}

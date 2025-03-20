{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "eko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7gomafTMK8rk+QFw3Vm8KUgNFqiUDILeTwNFa7vdgAw=";
  };

  vendorHash = "sha256-GB/wVB97aV+CV9Xtv0EofQQR+qOmtwrBFBogU+2S+Po=";

  meta = with lib; {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    mainProgram = "pihole-exporter";
    homepage = "https://github.com/eko/pihole-exporter";
    license = licenses.mit;
    maintainers = [ ];
  };
}

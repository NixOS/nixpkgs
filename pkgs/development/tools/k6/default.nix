{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k6";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mSVU/0OdlEfGWxO6Gn/Ji7k2pMO5jWTfxFujN08bZjU=";
  };

  subPackages = [ "./" ];

  vendorSha256 = null;

  doCheck = true;
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/k6 version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "A modern load testing tool, using Go and JavaScript";
    homepage = "https://k6.io/";
    changelog = "https://github.com/grafana/k6/releases/tag/v${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ offline bryanasdev000 ];
  };
}

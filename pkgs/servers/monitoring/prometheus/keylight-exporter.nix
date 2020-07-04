{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "keylight-exporter";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "keylight_exporter";
    rev = "v${version}";
    sha256 = "141npawcnxj3sz2xqsnyf06r4x1azk3g55941i8gjr7pwcla34r7";
  };

  vendorSha256 = "0w065ls8dp687jmps4xdffcarss1wyls14dngr43g58xjw6519gb";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) keylight; };

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/keylight_exporter";
    description = "Prometheus exporter for Elgato Key Light devices.";
    license = licenses.mit;
    maintainers = with maintainers; [ mdlayher ];
  };
}

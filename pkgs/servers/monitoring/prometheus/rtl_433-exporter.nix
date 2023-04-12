{ lib, buildGoModule, fetchFromGitHub, bash, nixosTests }:

buildGoModule rec {
  pname = "rtl_433-exporter";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "mhansen";
    repo = "rtl_433_prometheus";
    rev = "v${version}";
    sha256 = "1998gvfa5310bxhi6kfv8bn99369dxph3pwrpp335997b25lc2w2";
  };

  postPatch = "substituteInPlace rtl_433_prometheus.go --replace /bin/bash ${bash}/bin/bash";

  vendorSha256 = "03mnmzq72844hzyw7iq5g4gm1ihpqkg4i9dgj2yln1ghwk843hq6";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) rtl_433; };

  meta = with lib; {
    description = "Prometheus time-series DB exporter for rtl_433 433MHz radio packet decoder";
    homepage = "https://github.com/mhansen/rtl_433_prometheus";
    license = licenses.mit;
    maintainers = with maintainers; [ zopieux ];
  };
}

{ lib, buildGoModule, fetchFromGitHub, bash, nixosTests }:

buildGoModule rec {
  pname = "rtl_433-exporter";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "mhansen";
    repo = "rtl_433_prometheus";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ggtGi1gnpTLGvZnfAW9vyYyU7ELbTRNhXyCMotx+KKU=";
=======
    sha256 = "1998gvfa5310bxhi6kfv8bn99369dxph3pwrpp335997b25lc2w2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = "substituteInPlace rtl_433_prometheus.go --replace /bin/bash ${bash}/bin/bash";

<<<<<<< HEAD
  vendorHash = "sha256-BsNB0OTwBUu9kK+lSN7EF8ZQH3kFx8P9h4QgcfCvtg4=";
=======
  vendorSha256 = "03mnmzq72844hzyw7iq5g4gm1ihpqkg4i9dgj2yln1ghwk843hq6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests = { inherit (nixosTests.prometheus-exporters) rtl_433; };

  meta = with lib; {
    description = "Prometheus time-series DB exporter for rtl_433 433MHz radio packet decoder";
    homepage = "https://github.com/mhansen/rtl_433_prometheus";
    license = licenses.mit;
    maintainers = with maintainers; [ zopieux ];
  };
}

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-9zoZKd/mubm64Pb95iUFZK622hTqm3A+U0OOX3uDtd8=";
  };

  vendorHash = "sha256-BQkQ6huTm3hI1MQvq2VffCrxCQyDJb/S7yxvPpfQaGI=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}

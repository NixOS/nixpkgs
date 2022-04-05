{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gox";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mitchellh";
    repo = "gox";
    rev = "v${version}";
    sha256 = "sha256-h+adnofY5v6ilAl1fs0Lb1fxNP7Qm3V+K8TO02BAcFY=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/mitchellh/gox";
    description = "A dead simple, no frills Go cross compile tool";
    license = licenses.mpl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}

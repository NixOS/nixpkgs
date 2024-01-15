{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-XWMv3H/NcEnX9+kCU6gzyrhpCtMWV3I+ZQ9Ia4XFpgY=";
  };

  vendorHash = "sha256-dTPKdDEK3xdvKUqI4fUDlUi0q0sMCw5Nfaj71IXit9M=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}

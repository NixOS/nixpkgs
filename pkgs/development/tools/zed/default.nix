{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BK4LB37jr/9O0sjYgFtnEkbFqTsp/1+hcmCNMFDPiPM=";
  };

  vendorSha256 = "sha256-oAkQRUaEP/RNjpDH4U8XFVokf7KiLk0OWMX+U7qny70=";

  subPackages = [ "cmd/zed" "cmd/zq" ];

  meta = with lib; {
    description = "A novel data lake based on super-structured data";
    homepage = "https://github.com/brimdata/zed";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
  };
}

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.15";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-h5uBkScWCBG/yvv43lykBoSdyuIAMbrsUpCNVCPgnx4=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-bkGlheOwy7SbH1cKPAQek2s6TZKc0jp/lGKxDRrxKas=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

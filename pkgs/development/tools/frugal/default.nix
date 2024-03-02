{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.17.6";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-N4XcU2D3HE/bQWA70T2XYR5QBsknEr1bgRnfTKgzMiY=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-KxDtSrtDloUozUKE7pPR5TZsal9TSyA7Ohoe7HC0/VU=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

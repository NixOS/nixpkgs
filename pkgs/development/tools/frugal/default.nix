{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.14.14";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1ie/pkg0pv8bJphQ8PXceRd2WALYaVxBAW1O/s4kKHA=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-vWqj2fRtaDextDstIb5GrdRn4nxQpCfjegYiVbPILuM=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

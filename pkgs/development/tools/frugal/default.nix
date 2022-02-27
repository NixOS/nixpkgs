{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.14.15";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7840HndsU5+mWKQ/HXLVYA2dV7L8NlM7so1nk8Zdc2c=";
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

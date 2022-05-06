{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EIHaCkqwCyRV1sX+9f39FbByRvhms4rJA9nQoKxxkm8=";
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

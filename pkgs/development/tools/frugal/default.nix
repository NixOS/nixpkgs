{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.14.13";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-apX4MFzeR7+5gWauw5HXPK0c7N4uTSqkE2vqnYB5LJs=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-4Ak+mh9ege38iO1QyxvGkYvRyU11QjphfLrit1qfu58=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

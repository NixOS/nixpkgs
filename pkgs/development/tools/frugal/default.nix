{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.15.4";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5Q5HPS5MOOJRRUA0sRZS+QURDz52OGKgwuFswhqQFAg=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-Nqfhrf8zX5F35W3B/XW11Sw7M+mmIL/dfXl+zXqBL0g=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

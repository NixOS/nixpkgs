{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.12";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kdy3bh76c2sgwAwSxzCs83jTVLJmnH0YcYtKH9UvJew=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-S45/wxwyoSBmHsttY+pQSE1Ipg7oH3RrCoBeuC1pxeo=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

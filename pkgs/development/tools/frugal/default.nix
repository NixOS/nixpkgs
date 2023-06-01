{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.21";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iNj3E5JtvOHAiEC+81KnAb32TWi+Zq8Av24oLm01ty4=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-29LwvekhevOn/1zrtQEZWqeQMEAN2xPxSRzas/5EhVM=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

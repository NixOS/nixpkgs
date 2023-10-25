{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.24";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DXdecPsxYE12YkOn6acuai+mbqNkzZUEXEw1+ZcJlt8=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-9ZWK5xw2onwm9F/o/upGuo080X6neXUrSF+0WR+FpCs=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

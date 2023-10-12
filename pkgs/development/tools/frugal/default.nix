{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.17.2";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7+8wjWxePU3OrIf9SLYzu6jAaaeB3MUzZ/H6tdFn3ts=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-vES8WGaurEW5X9PX+ILN4XUGoSEtayq7UAes+1URKzg=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

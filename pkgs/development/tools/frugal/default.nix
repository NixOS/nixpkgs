{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.23";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ofem3oSwas5X3D8zSzS5HpJANR6TNVSJ8hWb13hr0W4=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-wuT58Weyc8AB9i5bVe0696BGRWsl814Fz9bmnuJwgPM=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

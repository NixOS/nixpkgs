{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.17.8";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-R9v/qWR+XuirMT2wM6UR2LrSpehkEtoRG73bBlni03k=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-BC8G41SWWecNiqj/8iez3debvpU9+PWHUya8V77zKj8=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

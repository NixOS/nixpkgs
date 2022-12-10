{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.2";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zZ4CueyDugaOY62KCyTcbF2QVvp0N8pI/ChmQSscn1w=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-0pPSEYPGluuRsDuTa2wmDPY6PqG3+YeJG6mphf8X96M=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

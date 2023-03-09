{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.14";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6U4mYS5ukcOaxGeIiI2UFYlz0PpjKdtQH9cOshYRUg0=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-CbneZtwGab5dlGASZqa69Y70fXgt4PJzAODPJlcpJoA=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

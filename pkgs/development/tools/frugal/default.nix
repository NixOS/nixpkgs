{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.14.5";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Er9V6mSe4Pt/RzFAPa3ci3J7FQh5GLbh9CjYHx/HnYM=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-9M6SSxMQ8JMJ7ZNl8cjQuid/B0xc28/BuPozxftthe0=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8qzz9K1zBh5c7w3XAnUEtrNOoHnHxk8g+PfGF+ppyVo=";
  };

  vendorSha256 = "sha256-qp2LD5hwnEZzdtnbTqdwQT6vfQTAb9VoiMoaV92uxqc=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}

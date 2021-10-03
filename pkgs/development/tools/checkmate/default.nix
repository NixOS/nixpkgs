{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "15rf01q19q34qkafklpzig1x3c3p16fygswab1hnmzldg6jwaf3x";
  };

  vendorSha256 = "1n47k2ibamsv9ig84l2a4pri2pph3k0xlavbpmcv0lgbf4zd50z9";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}

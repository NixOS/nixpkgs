{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.27";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZHDx6xE/apYF05CXtGJxlp2AWfeEAkWi3zloTFFr78M=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-2+7GQ54AHEF8ukvn/xUAD1eGESo8jO6TlRFPwlEvZ6A=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

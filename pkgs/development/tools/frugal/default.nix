{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.17.0";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r7/ZcqabSmpvhr3JKgCXaSD5378q2JOEmZyOfeLN3Nw=";
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

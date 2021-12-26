{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.14.11";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XUG9Md6T0/+yn3KGqJO09FFlpuli2wJqOf/SEIVKXac=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-Z42t9dGlNbSwNy2N/ZoEejkbIEeUUk87mcYhkTnxhpc=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

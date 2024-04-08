{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.17.9";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VNzTrJ5sY6JHfUXLlY3LOQYfzoWPYltPQBZWx9FopSU=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-5o2r392gT5mNvO7mFVRgOGgoy5d+1K2kIitBo+dzhFQ=";

  meta = with lib; {
    description = "Thrift improved";
    mainProgram = "frugal";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

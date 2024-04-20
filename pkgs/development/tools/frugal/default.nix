{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.17.11";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SCbnLIoHYvbiY2Irx1ufMZTjmUJIucPMgEFobJNor/c=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-6yKyPocuahr9m5frhbhBlcWd7QZ1rH+f9KhQ83+oadY=";

  meta = with lib; {
    description = "Thrift improved";
    mainProgram = "frugal";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}

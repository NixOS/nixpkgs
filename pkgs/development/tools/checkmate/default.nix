{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oBX1MSniVwXvq4Cy9uR3YqxaeSxeWg38oBlCiBy6z/8=";
  };

  vendorSha256 = "sha256-+O0EQRbqLCMBlaI2mejAId2/KFdPWkJ/i7B81tQykzk=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}

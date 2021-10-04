{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0s2WyY17xk/tGIKMUoJYcpOm510PtZZMxLLFdYAZAmI=";
  };

  vendorSha256 = "sha256-AEjSuG5qmsyzkEubxKYF1/MTG91Nxdz83X0ucZmZQxU=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}

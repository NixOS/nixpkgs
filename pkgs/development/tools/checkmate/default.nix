{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x3R6xkfgFhmR3iGSAXLCUl5wPQ25TqEBI5z9p0I/GoY=";
  };

  vendorSha256 = "sha256-ulXilkDEkvpfCgdJ55gzb8qpcra3s8wSjcEupxWP+h8=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}

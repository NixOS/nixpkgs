{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lSAA1lWHGQr1tguBdBePdkN+CNKkxmLweI6oqzzOG6A=";
  };

  vendorSha256 = "sha256-1QG+IV2unyqfD1qL8AnLjHLL/Fv3fe7rwhySM4/tJok=";

  modRoot = ".";
  subPackages = [
    "cmd/mapcidr"
  ];

  meta = with lib; {
    description = "Small utility program to perform multiple operations for a given subnet/CIDR ranges";
    longDescription = ''
      mapCIDR is developed to ease load distribution for mass scanning
      operations, it can be used both as a library and as independent CLI tool.
    '';
    homepage = "https://github.com/projectdiscovery/mapcidr";
    license = licenses.mit;
    maintainers = with maintainers; [ hanemile ];
  };
}

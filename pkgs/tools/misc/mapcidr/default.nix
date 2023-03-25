{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HmX4C1DXPS/14TGxKFnw/sxxp2suU6c4GC5W7ZtzjZ8=";
  };

  vendorHash = "sha256-7cB+fDYWy1Qe3apEPaUMA2+6KmMpC7ANjEgIde00Pas=";

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

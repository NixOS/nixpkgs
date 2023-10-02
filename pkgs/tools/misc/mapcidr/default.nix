{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/DKUB7ylOUh1kj1l5C6TbhfgmagJcTBFCoqjQIsbWg4=";
  };

  vendorHash = "sha256-YQEXOxu2IPvXNvqw0bzHnx0ALC/W4x9sU4m1GgvVH+g=";

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
    changelog = "https://github.com/projectdiscovery/mapcidr/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hanemile ];
  };
}

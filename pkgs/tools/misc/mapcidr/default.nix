{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hlMIgSsSqvMx6Y7JnR7L9muTLWPfxDN5raJRezt99G0=";
  };

  vendorSha256 = "sha256-zp+XaSZgSMwJK+EEiTaJKBTPiKYaYpTtArnGBmHUGzE=";

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

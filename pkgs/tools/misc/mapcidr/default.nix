{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qfEm+DFnTmGwHV7Sb488qFmjT+7QSCmbT4n5JhtDo5g=";
  };

  vendorSha256 = "sha256-5XkBw/RBNcQyoKuWQuBGGRKawuKJtMOKG06lpIPBf+8=";

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

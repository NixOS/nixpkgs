{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cpNNStPgGnEtiiHgpiLUvEFu78NtyJIVgjrkh6N+dLU=";
  };

  vendorHash = "sha256-t6bTbgOTWNz3nz/Tgwkd+TCBhN++0UaV0LqaEsO9YCI=";

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

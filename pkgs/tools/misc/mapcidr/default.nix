{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.1.13";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ggfk9ceogvTP0Q1RzA6tZgEj+iVVuGa+MU0zSZfO2ZI=";
  };

  vendorHash = "sha256-wqbAOoRQEE7CDmaH5MRzsSKOdyrxwBY/1wDz3MCfsBc=";

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

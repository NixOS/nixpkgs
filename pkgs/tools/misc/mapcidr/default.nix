{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.1.16";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-O0HVlrLOz4+hxhf/BTSZs0qDCbYokbzmg5KbzUD1UHg=";
  };

  vendorHash = "sha256-j/3Z2KxbybJoE6/PXkwMLivzmTnZSi7tgO8IQKCoaEQ=";

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
    mainProgram = "mapcidr";
  };
}

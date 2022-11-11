{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "legitify";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Legit-Labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Sr6P5S5+DqbP0ihCj97l84739/NRAlYJLnXp4B5gHNE=";
  };

  vendorHash = "sha256-EJMXzWrOXFl7JFYBp/XAcHLcNyWCKbOBAyo/Yf2mh5s=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/Legit-Labs/legitify/internal/version.Version=${version}"
  ];

  meta = with lib; {
    description = "Tool to detect and remediate misconfigurations and security risks of GitHub assets";
    homepage = "https://github.com/Legit-Labs/legitify";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

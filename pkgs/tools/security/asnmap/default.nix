{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "asnmap";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-auVdBt8XT0qvEC9TfuROBbV/D6uQXBODZs/vrkJolwI=";
  };

  vendorHash = "sha256-6z40pIj6cgC7lXS2qDhkYec5zIrmjHzh2W0U5BDmSzU=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool to gather network ranges using ASN information";
    homepage = "https://github.com/projectdiscovery/asnmap";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

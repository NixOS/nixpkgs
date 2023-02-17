{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "asnmap";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AndX0PISGKhVmUFcJ2pCu8dqH67nVCe+25MIcF9d+8A=";
  };

  vendorHash = "sha256-+a6GgKHQ1D/hW9MEutyfbNbyDJuQGJ7Vd9Pz6w08lfo=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool to gather network ranges using ASN information";
    homepage = "https://github.com/projectdiscovery/asnmap";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

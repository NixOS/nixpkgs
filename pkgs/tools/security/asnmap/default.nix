{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "asnmap";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NdD1b/yHB1fizAl/5UsksQ5jrj1OW46Ff4eABPPam7w=";
  };

  vendorHash = "sha256-/L3fGDa3aJit9forggszIjpekowh4LbNhxiJjHhzARs=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool to gather network ranges using ASN information";
    homepage = "https://github.com/projectdiscovery/asnmap";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

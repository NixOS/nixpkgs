{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "asnmap";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-nkDa54+4bAMtQ/s/vn7x9hAt7p+ErKMOZ70MoH45CoM=";
  };

  vendorHash = "sha256-owpu0oANYipso33HOwwSqL8G0VDT53B9HeLQA/GvmxU=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool to gather network ranges using ASN information";
    homepage = "https://github.com/projectdiscovery/asnmap";
    changelog = "https://github.com/projectdiscovery/asnmap/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

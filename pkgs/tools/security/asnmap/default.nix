{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "asnmap";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7yKOeKSsexqLZ+ep7+mft6GlHrZiwv6OOCeERZu7gAE=";
  };

  vendorHash = "sha256-VmbmRkJB5jme8j/ONMkbsITJxg5inxYnb5AoKUR3Uzg=";

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

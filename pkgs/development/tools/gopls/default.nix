{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-+9NOQRu7cwEkRMB+HFEVrF7Z8y5UCxdUL005vZFPUHk=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-V5HQAKRFtHfJJzdQ8eutCpVmnOWe0yYKKnlGxphulAc=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 rski SuperSandro2000 zimbatm ];
  };
}

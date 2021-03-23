{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ginkgo";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
    sha256 = "sha256-lZ2PIfZSvBxVIAEpRgsLvTWPFRsh2ZpXkame6pk0Cio=";
  };
  vendorSha256 = "sha256:1nqam6y2dar8320yb5fg9chsvswq8fb1rrvr5kbcaf4mzmqpy7vw";
  doCheck = false;

  meta = with lib; {
    description = "BDD Testing Framework for Go";
    homepage = "https://github.com/onsi/ginkgo";
    license = licenses.mit;
    maintainers = with maintainers; [ saschagrunert ];
  };
}

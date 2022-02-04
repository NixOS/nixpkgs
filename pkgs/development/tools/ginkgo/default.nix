{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ginkgo";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
    sha256 = "sha256-GF96AOyQcVI01dP6yqMwyPmXMDRVxrScu1UL76jF2qA=";
  };
  vendorSha256 = "sha256-kMQ60HdsorZU27qoOY52DpwFwP+Br2bp8mRx+ZwnQlI=";
  doCheck = false;

  meta = with lib; {
    description = "BDD Testing Framework for Go";
    homepage = "https://github.com/onsi/ginkgo";
    license = licenses.mit;
    maintainers = with maintainers; [ saschagrunert ];
  };
}

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ginkgo";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
    sha256 = "sha256-a3AZ/7UfB9qjMK9yWHSaBRnDA/5FmIGGxXAvNhcfKCc=";
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

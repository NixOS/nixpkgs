{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ginkgo";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
    sha256 = "sha256-NvScoKnLr0herVrjEnij45yN0MxC/MoRJJHcy59rOuA=";
  };
  vendorSha256 = "sha256-xBa2n2BV+aXPCZ3G+rFIqHtjcXfs1rDjKbmRzjaDSb8=";
  doCheck = false;

  meta = with lib; {
    description = "BDD Testing Framework for Go";
    homepage = "https://github.com/onsi/ginkgo";
    license = licenses.mit;
    maintainers = with maintainers; [ saschagrunert ];
  };
}

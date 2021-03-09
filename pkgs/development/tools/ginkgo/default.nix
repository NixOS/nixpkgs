{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ginkgo";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
    sha256 = "sha256-w2eP8mDGHHZGYQUU7lOe7gp3tdr9VO/NP5fFBWOWt/A=";
  };
  vendorSha256 = "sha256-fB9/cf2VOMXWLHnnHJZDmOutIUvPleWBGCirJrypCts=";
  doCheck = false;

  meta = with lib; {
    description = "BDD Testing Framework for Go";
    homepage = "https://github.com/onsi/ginkgo";
    license = licenses.mit;
    maintainers = with maintainers; [ saschagrunert ];
  };
}

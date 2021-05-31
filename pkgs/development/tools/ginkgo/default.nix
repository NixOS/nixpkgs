{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ginkgo";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
    sha256 = "sha256-MDxDDZaNgjZz98lAoIIpWbIg7Cr/6kohSh+WL/1Ljyo=";
  };
  vendorSha256 = "sha256-tS8YCGVOsfQp02vY6brmE3pxi70GG9DYcp1JDkcVG9Y=";
  doCheck = false;

  meta = with lib; {
    description = "BDD Testing Framework for Go";
    homepage = "https://github.com/onsi/ginkgo";
    license = licenses.mit;
    maintainers = with maintainers; [ saschagrunert ];
  };
}

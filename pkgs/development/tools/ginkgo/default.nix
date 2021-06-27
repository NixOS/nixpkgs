{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ginkgo";
  version = "1.16.4";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
    sha256 = "sha256-p9kam1pRP0Am02o7vM+VzeAht+Qtn4DZ12NM8TaA/2Y=";
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

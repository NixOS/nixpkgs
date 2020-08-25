{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ginkgo";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
    sha256 = "0nwvz0pqk2jqscq88fhppad4flrr8avkxfgbci4xklbar4g8i32v";
  };
  vendorSha256 = "072amyw1ir18v9vk268j2y7dhw3lfwvxzvzsdqhnp50rxsa911bx";
  doCheck = false;

  meta = with stdenv.lib; {
    description = "BDD Testing Framework for Go";
    homepage = "https://github.com/onsi/ginkgo";
    license = licenses.mit;
    maintainers = with maintainers; [ saschagrunert ];
  };
}

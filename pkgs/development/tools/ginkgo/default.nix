{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ginkgo";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
    sha256 = "01nn33r1rg210zv0qmck0b16545gzr057w1kz8ca86l64qrwbcxx";
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

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ls-lint";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "loeffel-io";
    repo = "ls-lint";
    rev = "v${version}";
    sha256 = "sha256-twXaiPccc6DZdzKdvB+BzHbRuwgDy05C3jNg7Ur8yrA=";
  };

  vendorHash = "sha256-uyNOcIjrICr76Q8izXGRMhofDcjQrzbB/ISHTqRY5fI=";

  meta = with lib; {
    description = "An extremely fast file and directory name linter";
    homepage = "https://ls-lint.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}

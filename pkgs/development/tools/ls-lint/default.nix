{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ls-lint";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "loeffel-io";
    repo = "ls-lint";
    rev = "v${version}";
    sha256 = "sha256-blhb7+SmB3p6udGcbA8eCpSaqlTCca8J0Y/8riNRjW0=";
  };

  vendorHash = "sha256-qXx83jtkVzN+ydXjW4Nkz49rhSLbAS2597iuYUDsEo4=";

  meta = with lib; {
    description = "An extremely fast file and directory name linter";
    mainProgram = "ls_lint";
    homepage = "https://ls-lint.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}

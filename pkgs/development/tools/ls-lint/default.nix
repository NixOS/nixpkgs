{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ls-lint";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "loeffel-io";
    repo = "ls-lint";
    rev = "v${version}";
    sha256 = "sha256-JG3gDmPfeGyiiIsFX0jFN1Xi9lY4eednmEfJLdu0atA=";
  };

  vendorHash = "sha256-/6Y20AvhUShaE1sNTccB62x8YkVLLjhl6fg5oY4gL4I=";

  meta = with lib; {
    description = "An extremely fast file and directory name linter";
    homepage = "https://ls-lint.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}

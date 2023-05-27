{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ls-lint";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "loeffel-io";
    repo = "ls-lint";
    rev = "v${version}";
    sha256 = "sha256-eEP/l3vdObdxUYIp8eSSCn3W0ypcmykbwQTDP083MVE=";
  };

  vendorHash = "sha256-nSHhU6z3ItCKBZy8ENBcAkXqSVo3DU6hAyezQczKShM=";

  meta = with lib; {
    description = "An extremely fast file and directory name linter";
    homepage = "https://ls-lint.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}

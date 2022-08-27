{ lib, rustPlatform, fetchFromGitHub, testers, cbfmt }:

rustPlatform.buildRustPackage rec {
  pname = "cbfmt";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "lukas-reineke";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MOvTsyfKsBSog/0SpHJO9xiIc6/hmQVN4dqqytiiCgs=";
  };

  cargoSha256 = "sha256-Vu4bcw5WSwS2MB0sPumoQDhSdjnZyzrYF8eMPeVallA=";

  passthru.tests.version = testers.testVersion {
    package = cbfmt;
  };

  meta = with lib; {
    description = "A tool to format codeblocks inside markdown and org documents";
    homepage = "https://github.com/lukas-reineke/cbfmt";
    license = licenses.mit;
    maintainers = [ maintainers.stehessel ];
  };
}

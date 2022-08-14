{ lib, rustPlatform, fetchFromGitHub, testers, cbfmt }:

rustPlatform.buildRustPackage rec {
  pname = "cbfmt";
  version = "0.1.1-2";

  src = fetchFromGitHub {
    owner = "lukas-reineke";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wGMa3hJ3LUCh6YIdTq+7Bl37v40vCZpNFdviE23X/YI=";
  };

  cargoSha256 = "sha256-mWJKolWd6nf8OsU4BU2CituARImyC0E0y7851Q0OLN8=";

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

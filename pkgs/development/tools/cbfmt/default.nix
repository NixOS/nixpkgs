{ lib, rustPlatform, fetchFromGitHub, testers, cbfmt }:

rustPlatform.buildRustPackage rec {
  pname = "cbfmt";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "lukas-reineke";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cTX7eBcEZiTJm3b1d2Mwu7NdbtHjeF+dkc3YMede0cQ=";
  };

  cargoSha256 = "sha256-vEInZplfgrM4gD5wPATl7j5iTo9pSstElfd0Lq9giJw=";

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

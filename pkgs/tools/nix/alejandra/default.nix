{ lib
, rustPlatform
, fetchFromGitHub
, testers
, alejandra
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    sha256 = "sha256-A0ruEdPeKIzGYxyXNACnzaKtQUVc30s2ExTUzdFTcWM=";
  };

  cargoSha256 = "sha256-BmpFyVF2fxV3rExI7rpOQlVwHEJNlof44dnUshaO/no=";

  passthru.tests = {
    version = testers.testVersion { package = alejandra; };
  };

  meta = with lib; {
    description = "The Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    changelog = "https://github.com/kamadorueda/alejandra/blob/${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [ _0x4A6F kamadorueda ];
  };
}

{ lib
, rustPlatform
, fetchFromGitHub
, testers
, alejandra
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    sha256 = "sha256-0AolxQtKj3Oek0WSbODDpPVO5Ih8PXHOA3qXEKPB4dQ=";
  };

  cargoSha256 = "sha256-USI98hozlTaTj07tMbCQEWDgRkHsd4PFW1HUpKsNZJA=";

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

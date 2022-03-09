{ lib
, rustPlatform
, fetchFromGitHub
, testVersion
, alejandra
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    sha256 = "sha256-fJ/WHSU45bMJRDqz9yA3B2lwXtW5DKooU+Pzn13GyZI=";
  };

  cargoSha256 = "sha256-mIcTgpWI5iuMH03EsZalmAxjpme+bsIJU7kW9PavHEM=";

  passthru.tests = {
    version = testVersion { package = alejandra; };
  };

  meta = with lib; {
    description = "The Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    changelog = "https://github.com/kamadorueda/alejandra/blob/${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [ _0x4A6F kamadorueda ];
  };
}

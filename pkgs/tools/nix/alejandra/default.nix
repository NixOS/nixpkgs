{ lib
, rustPlatform
, fetchFromGitHub
, testVersion
, alejandra
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    sha256 = "sha256-35hEJuMvRswOPKb9lbB9ZuHVe0eJN6WJc4T8Frn0hYQ=";
  };

  cargoSha256 = "sha256-SsIpggbRQPjpCYgCG4sSJ022MmMV4bJJ8UAHcJR74O8=";

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

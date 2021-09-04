{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.14";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = pname;
    rev = "v${version}";
    sha256 = "03b6qxkn8sqv06gs4p6wg02arz0n9llc3z92zhfd5ipz8han83fd";
  };

  cargoSha256 = "13nkd4354siy8pr2032bxz2z5x8b378mccq6pnm71cpl9dl6w4ad";

  meta = with lib; {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C6BY+Ba5KQgi+jMUKRi7osZNEDMLMDOhA4TQlbqb9jY=";
  };

  cargoSha256 = "sha256-5ZBE7jbhO4j4FwGSXLIbYjmtmNxFpiME9JqXBqwHSUA=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "socks" ];

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}

{ lib, stdenv
, rustPlatform
, fetchFromGitHub
, IOKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "meilisearch";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "v${version}";
    sha256 = "00i5vsbcyrbsvhr5n1b3pxa87v0kfw6pg931i2kzyf4wh021k6sw";
  };

  cargoSha256 = "0803cjgaj6nlg6rfvzizzyrd97rq9yyrrz8az2czirvymmcaayfv";

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit Security ];

  meta = with lib; {
    description = "Ultra relevant and instant full-text search API";
    homepage = "https://meilisearch.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

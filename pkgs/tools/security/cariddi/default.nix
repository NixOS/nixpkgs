{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/ez2biYU8NnVny8v5Mu9pLq0oqzcIenpyEb3qkPd9v8=";
  };

  vendorSha256 = "sha256-zJ39tAq+ooROMHG1vC2m2rbq+wttxqYxAd2hLg5GtJM=";

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}

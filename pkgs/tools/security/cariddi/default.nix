{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zz9p35Wk5jwp5Cn4+FgJCwG2KKgBuOQsH4lJeAVhpCM=";
  };

  vendorHash = "sha256-s6aEq3LzCj9xzieLD1aC69KV3aeav+bQ5VUZ3TbFetw=";

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    changelog = "https://github.com/edoardottt/cariddi/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}

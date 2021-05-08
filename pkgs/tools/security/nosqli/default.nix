{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "nosqli";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "Charlie-belmer";
    repo = pname;
    rev = "v${version}";
    sha256 = "006z76v4a3pxzgnkj5nl0mrlsqmfgvg51w20dl118k2xa70zz63j";
  };

  vendorSha256 = "01spdh2gbzp6yg2jbiwfnyhqb5s605hyfxhs0f9h4ps4qbi1h9cv";

  meta = with lib; {
    description = "NoSql Injection tool for finding vulnerable websites using MongoDB";
    homepage = "https://github.com/Charlie-belmer/nosqli";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}

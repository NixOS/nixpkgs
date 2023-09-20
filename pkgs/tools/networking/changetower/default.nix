{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "changetower";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "Dc4ts";
    repo = "ChangeTower";
    rev = "v${version}";
    sha256 = "058ccn6d5f7w268hfqh85bz1xj6ysgfrmyj0b4asjiskq7728v9z";
  };

  vendorSha256 = "0hagskhwrdsl6s6hn27jriysbxhaz0pqq1h43j7v0ggnwd2s03bq";

  meta = with lib; {
    description = "Tools to watch for webppage changes";
    homepage = "https://github.com/Dc4ts/ChangeTower";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ChangeTower";
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-w9PoKGxZdP/sKdlTlnWBMqDPDLUvcYubkCyNHUm3AAc=";
  };

  vendorHash = "sha256-2an4xj1gqQqj9NrSdTAss7hn6SiWoiq3RQ2xxUlSuaE=";

  meta = with lib; {
    description = "A website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

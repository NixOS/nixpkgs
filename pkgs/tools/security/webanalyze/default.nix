{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "webanalyze";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "rverton";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-uDf0p4zw23+AVftMmrKfno+FbMZfGC1B5zvutj8qnPg=";
  };

  vendorHash = "sha256-XPOsC+HoLytgv1fhAaO5HYSvuOP6OhjLyOYTfiD64QI=";

  meta = with lib; {
    description = "Tool to uncover technologies used on websites";
    homepage = "https://github.com/rverton/webanalyze";
    changelog = "https://github.com/rverton/webanalyze/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "webanalyze";
  };
}

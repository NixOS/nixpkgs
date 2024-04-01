{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "refs/tags/v${version}";
    hash = "sha256-jShFLwoxZdUEHA+gd87n3R+faOdC6TboXuPvcZp89+Y=";
  };

  vendorHash = "sha256-kBk2KhPDVYBGIUQpXq4ANA7WX+JUOxz7/Ad+4h2CD1c=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}

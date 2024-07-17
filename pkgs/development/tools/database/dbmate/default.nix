{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "refs/tags/v${version}";
    hash = "sha256-crn2FSJm7CSBg5TOcB5bJOsWqBrlwDoik7OS3HiCIGw=";
  };

  vendorHash = "sha256-eFGQ59fdS+QQounT/byA0w9W+MK2Lhp+mlXAWWAtk6U=";

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

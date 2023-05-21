{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "refs/tags/v${version}";
    hash = "sha256-bWmRdrULXXVIaO5f3rntsVURnyojYFbhbZ43WvGzoZk=";
  };

  vendorHash = "sha256-m1Nbu1bE04iOXnxW5kJfI9W95FU87eRKkOzg+YVvRsg=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.unix;
  };
}

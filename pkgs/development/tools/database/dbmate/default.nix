{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "sha256-bWmRdrULXXVIaO5f3rntsVURnyojYFbhbZ43WvGzoZk=";
  };

  vendorHash = "sha256-m1Nbu1bE04iOXnxW5kJfI9W95FU87eRKkOzg+YVvRsg=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}

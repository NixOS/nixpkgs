{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.13.0";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "0rzx974cxsipbnggl3n4q6zsvm313svrg718gscydygk41m9nql9";
  };

  vendorSha256 = "1107syipynlfibzljyfgz81v1avi8axvsjpmrpj990pm83r9svc6";

  subPackages = [ "cmd/migrate" ];

  meta = with stdenv.lib; {
    homepage    = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with maintainers; [ offline ];
    license     = licenses.mit;
  };
}

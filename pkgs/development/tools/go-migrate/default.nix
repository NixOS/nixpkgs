{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.12.2";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "0vrc9y90aamj618sfipq2sgzllhdr4hmicj4yvl147klwb1rxlz6";
  };

  vendorSha256 = "0jpz5xvwsw4l7nmi7s1grvbfy4xjp50hrjycwicgv2ll719gz5v0";

  subPackages = [ "cmd/migrate" ];

  meta = with stdenv.lib; {
    homepage    = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with maintainers; [ offline ];
    license     = licenses.mit;
  };
}

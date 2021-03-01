{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgcenter";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner  = "lesovsky";
    repo   = "pgcenter";
    rev    = "v${version}";
    sha256 = "sha256-W/UUc0qwOvLSXYWepkCydst113BqR9EsZK0Es+6HSt8=";
  };

  vendorSha256 = "sha256-9hYiyZ34atmSL7JvuXyiGU7HR4E6qN7bGZlyU+hP+FU=";

  subPackages = [ "cmd" ];

  buildFlagsArray = [ "-ldflags=-w -s -X main.gitTag=${src.rev} -X main.gitCommit=${src.rev} -X main.gitBranch=master" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/pgcenter
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://pgcenter.org/";
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}

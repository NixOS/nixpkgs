{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgcenter";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner  = "lesovsky";
    repo   = "pgcenter";
    rev    = "v${version}";
    sha256 = "0l3da7migx1gprhlwc98x30qh6lmrn8hizanxgs3hxl0arbrn710";
  };

  vendorSha256 = "0mgq9zl56wlr37dxxa1sh53wfkhrl9ybjvxj5y9djspqkp4j45pn";

  subPackages = [ "cmd" ];

  buildFlagsArray = [ "-ldflags=-w -s -X main.gitTag=${src.rev} -X main.gitCommit=${src.rev} -X main.gitBranch=master" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/pgcenter
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://pgcenter.org/";
    changelog = "https://github.com/lesovsky/pgcenter/raw/v${version}/doc/Changelog";
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}

{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgcenter";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner  = "lesovsky";
    repo   = "pgcenter";
    rev    = "v${version}";
    sha256 = "1axwsclssxsg38ppdmd4v1lbs87ksrwj5z76ckjk8jjfni1xp9sr";
  };

  vendorSha256 = "1mzvpr12qh9668iz97p62zl4zhlrcyfgwr4a9zg9irj585pkb5x2";

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://pgcenter.org/";
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}

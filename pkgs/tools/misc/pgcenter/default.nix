{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgcenter";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner  = "lesovsky";
    repo   = "pgcenter";
    rev    = "v${version}";
    sha256 = "0p8ck4s5jj53nc638darhwbylcsslfmfz72bwy6wxby9iqi9kq6b";
  };

  vendorSha256 = "1mzvpr12qh9668iz97p62zl4zhlrcyfgwr4a9zg9irj585pkb5x2";

  meta = with stdenv.lib; {
    homepage = "https://pgcenter.org/";
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
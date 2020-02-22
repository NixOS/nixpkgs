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

  modSha256 = "0kassq52v07zmffs6l066g0d3kfv6wmrh9g5cgk79bmyq13clqjj";

  meta = with stdenv.lib; {
    homepage = https://pgcenter.org/;
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}

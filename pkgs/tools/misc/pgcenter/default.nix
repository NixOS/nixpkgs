{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgcenter";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner  = "lesovsky";
    repo   = "pgcenter";
    rev    = "v${version}";
    sha256 = "0mh0s83gkjhrm9ip5r1bb6y5n0nl1rlh99570yv7p3yvyhmh2292";
  };

  modSha256 = "0kassq52v07zmffs6l066g0d3kfv6wmrh9g5cgk79bmyq13clqjj";

  meta = with stdenv.lib; {
    homepage = https://pgcenter.org/;
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}

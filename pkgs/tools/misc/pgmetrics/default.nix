{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner  = "rapidloop";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "17rr6rjdxg8gdljf65zkn3bl1kmnlp2gkhiq7slxslh8n9iz4wjs";
  };

  modSha256 = "0llbx2sgcx95ym2q4l3334rdj3nkgr9z5jyp8406cp3k1ixi7gdb";

  meta = with stdenv.lib; {
    homepage = https://pgmetrics.io/;
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}

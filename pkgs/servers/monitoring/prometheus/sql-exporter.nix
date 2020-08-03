{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "sql_exporter";
  version = "0.3.0";

  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "justwatchcom";
    repo = "sql_exporter";
    rev = "v${version}";
    sha256 = "125brlxgwhkn3z5v0522gpm0sk6v905ghh05c4c3wf1hlm7bhnrc";
  };

  meta = with stdenv.lib; {
    description = "Flexible SQL exporter for Prometheus";
    homepage = "https://github.com/justwatchcom/sql_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ justinas ];
    platforms = platforms.unix;
  };
}

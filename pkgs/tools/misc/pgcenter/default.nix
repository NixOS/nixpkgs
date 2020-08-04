{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgcenter";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner  = "lesovsky";
    repo   = "pgcenter";
    rev    = "v${version}";
    sha256 = "03n1gn944z6rz5g643y68hvfxpxp65mip32w1zx43xr60x1vpf2v";
  };

  vendorSha256 = "1mzvpr12qh9668iz97p62zl4zhlrcyfgwr4a9zg9irj585pkb5x2";

  meta = with stdenv.lib; {
    homepage = "https://pgcenter.org/";
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}

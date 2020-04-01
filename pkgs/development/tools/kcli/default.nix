{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kcli";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "cswank";
    repo = "kcli";
    rev = version;
    sha256 = "0whijr2r2j5bvfy8jgmpxsa0zvwk5kfjlpnkw4za5k35q7bjffls";
  };

  modSha256 = "1wcqh3306q9wxb6pnl8cpk73vmy36bjv2gil03j7j4pajs1f2lwn";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A kafka command line browser";
    homepage = "https://github.com/cswank/kcli";
    license = licenses.mit;
    maintainers = with maintainers; [ cswank ];
  };
}

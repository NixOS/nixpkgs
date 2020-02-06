{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kcli";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "cswank";
    repo = "kcli";
    rev = version;
    sha256 = "1m9967f9wk1113ap2qmqinqg7gvpmg5y2g1ji0q818qbandzlh23";
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

{ rustPlatform, fetchFromGitHub, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "tre-command";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "tre";
    rev = "v${version}";
    sha256 = "1fm3fszy7fd0dgf5dwm35nb0ym0waw92iyx128lr2vlbyzln6ija";
  };

  cargoSha256 = "0sk4dn5rrqhkaxm76y1d7rsjsw6pdjdhb2xv7qqrlivfk6y5k31x";

  meta = with stdenv.lib; {
    description = "Tree command, improved";
    homepage = "https://github.com/dduan/tre";
    license = licenses.mit;
    maintainers = [ maintainers.dduan ];
    platforms = platforms.all;
  };
}

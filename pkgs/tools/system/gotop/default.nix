{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotop";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d08pi213nzvj4vhd2sbri39qlxa7iazc8bcrikhmmr0pghjfwhn";
  };

  vendorSha256 = "1ais548gii4q7xzysnw2ykjxyzb7azszsqdlp9hgiwp0bax9nj2n";

  meta = with stdenv.lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    license = licenses.agpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
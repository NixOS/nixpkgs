{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gotop-${version}";
  version = "2.0.1";

  goPackagePath = "github.com/cjbassi/gotop";

  src = fetchFromGitHub {
    repo = "gotop";
    owner = "cjbassi";
    rev = version;
    sha256 = "0xpm8nrn53kz65f93czflgdgr2a33qfi1w0gsgngrmaliq1vlpji";
  };

  meta = with stdenv.lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = https://github.com/cjbassi/gotop;
    license = licenses.agpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}

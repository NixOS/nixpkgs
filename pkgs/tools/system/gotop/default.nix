{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gotop";
  version = "3.0.0";

  goPackagePath = "github.com/cjbassi/gotop";

  src = fetchFromGitHub {
    owner = "cjbassi";
    repo = pname;
    rev = version;
    sha256 = "1kndj5qjaqgizjakh642fay2i0i1jmfjlk1p01gnjbh2b0yzvj1r";
  };

  meta = with stdenv.lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = https://github.com/cjbassi/gotop;
    license = licenses.agpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}

{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gotop-${version}";
  version = "1.5.0";

  goPackagePath = "github.com/cjbassi/gotop";

  src = fetchFromGitHub {
    repo = "gotop";
    owner = "cjbassi";
    rev = version;
    sha256 = "19kj7mziwkfcf9kkwph05jh5vlkfqpyrpxdk5gdf2swg07w1ld35";
  };

  meta = with stdenv.lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = https://github.com/cjbassi/gotop;
    license = licenses.agpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}

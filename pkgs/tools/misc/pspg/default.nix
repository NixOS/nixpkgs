{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig, readline }:

stdenv.mkDerivation rec {
  name = "pspg-${version}";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "pspg";
    rev = "${version}";
    sha256 = "0zz924fl0b99a09gi5l3vxv9dmxnkv1v679w6k9zf365b44z91ki";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnugrep ncurses readline ];

  preBuild = ''
    makeFlags="PREFIX=$out PKG_CONFIG=${pkgconfig}/bin/pkg-config"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/okbob/pspg;
    description = "Postgres Pager";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jlesquembre ];
  };
}

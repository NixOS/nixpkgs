{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mawk-1.3.4-20161120";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/mawk/${name}.tgz"
      "https://invisible-mirror.net/archives/mawk/${name}.tgz"
    ];
    sha256 = "07hc33g2ip7463dravsiz0zwfc8vy4y4jxqvp7rz3hb896xw27in";
  };

  meta = with stdenv.lib; {
    description = "Interpreter for the AWK Programming Language";
    homepage = http://invisible-island.net/mawk/mawk.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; unix;
  };
}

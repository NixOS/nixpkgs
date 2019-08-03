{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mawk-1.3.4-20171017";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/mawk/${name}.tgz"
      "https://invisible-mirror.net/archives/mawk/${name}.tgz"
    ];
    sha256 = "0nwyxhipn4jx7j695lih1xggxm6cp4fjk4wbgihd33ni3rfi25yv";
  };

  meta = with stdenv.lib; {
    description = "Interpreter for the AWK Programming Language";
    homepage = https://invisible-island.net/mawk/mawk.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; unix;
  };
}

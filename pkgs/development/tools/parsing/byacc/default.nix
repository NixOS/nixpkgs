{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "byacc-${version}";
  version = "20180510";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${name}.tgz"
      "https://invisible-mirror.net/archives/byacc/${name}.tgz"
    ];
    sha256 = "14ynlrcsc2hwny3gxng19blfvglhqd4m7hl597fwksf7zfzhv56h";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Berkeley YACC";
    homepage = http://invisible-island.net/byacc/byacc.html;
    license = licenses.publicDomain;
    platforms = platforms.unix;
  };
}

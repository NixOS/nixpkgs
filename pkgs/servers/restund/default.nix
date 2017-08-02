{ stdenv, fetchurl, zlib, openssl, libre, librem, mysql }:
stdenv.mkDerivation rec {
  version = "0.4.2";
  name = "restund-${version}";
  src=fetchurl {
    url = "http://www.creytiv.com/pub/restund-${version}.tar.gz";
    sha256 = "db5260939d40cb2ce531075bef02b9d6431067bdd52f3168a6f25246bdf7b9f2";
  };
  buildInputs = [ zlib openssl libre librem mysql.lib ];
  makeFlags = [
    "LIBRE_MK=${libre}/share/re/re.mk"
    "LIBRE_INC=${libre}/include/re"
    "LIBRE_SO=${libre}/lib"
    "LIBREM_PATH=${librem}"
    ''PREFIX=$(out)''
    "USE_MYSQL=1"
  ]
  ++ stdenv.lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.cc.libc}"
  ;
  NIX_LDFLAGS='' -L${stdenv.lib.getLib mysql.client}/lib/mysql '';
  meta = {
    homepage = http://www.creytiv.com/restund.html;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.bsd3;
    inherit version;
    downloadPage = "http://www.creytiv.com/pub/";
    updateWalker = true;
    downloadURLRegexp = "/restund-.*[.]tar[.]";
    broken = true; # probably due to glibc-2.20
  };
}

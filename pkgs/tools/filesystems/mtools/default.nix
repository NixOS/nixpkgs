{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtools-4.0.18";

  src = fetchurl {
    url = "mirror://gnu/mtools/${name}.tar.bz2";
    sha256 = "119gdfnsxc6hzicnsf718k0fxgy2q14pxn7557rc96aki20czsar";
  };

  # Prevents errors such as "mainloop.c:89:15: error: expected ')'"
  # Upstream issue https://lists.gnu.org/archive/html/info-mtools/2014-02/msg00000.html
  patches = stdenv.lib.optional stdenv.isDarwin ./UNUSED-darwin.patch;

  # fails to find X on darwin
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--without-x";

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/mtools/;
    description = "Utilities to access MS-DOS disks";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}

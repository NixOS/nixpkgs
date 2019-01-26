{ stdenv, fetchurl, ncurses, zlib
, openssl ? null
, sslSupport ? true
}:

with stdenv.lib;

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  name = "tinyfugue-${version}";
  version = "50b8";
  verUrl = "5.0%20beta%208";

  src = fetchurl {
    url = "mirror://sourceforge/project/tinyfugue/tinyfugue/${verUrl}/tf-${version}.tar.gz";
    sha256 = "12fra2fdwqj6ilv9wdkc33rkj343rdcf5jyff4yiwywlrwaa2l1p";
  };

  configureFlags = optional (!sslSupport) "--disable-ssl";

  buildInputs =
    [ ncurses zlib ]
    ++ optional sslSupport openssl;

  meta = {
    homepage = http://tinyfugue.sourceforge.net/;
    description = "A terminal UI, screen-oriented MUD client";
    longDescription = ''
      TinyFugue, aka "tf", is a flexible, screen-oriented MUD client, for use
      with any type of text MUD.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.KibaFox ];
  };
}

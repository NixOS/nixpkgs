{ lib, stdenv, fetchurl, ncurses, zlib
, openssl ? null
, sslSupport ? true
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  pname = "tinyfugue";
  version = "50b8";
  verUrl = "5.0%20beta%208";

  src = fetchurl {
    url = "mirror://sourceforge/project/tinyfugue/tinyfugue/${verUrl}/tf-${version}.tar.gz";
    sha256 = "12fra2fdwqj6ilv9wdkc33rkj343rdcf5jyff4yiwywlrwaa2l1p";
  };

  configureFlags = lib.optional (!sslSupport) "--disable-ssl";

  buildInputs =
    [ ncurses zlib ]
    ++ lib.optional sslSupport openssl;

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: world.o:/build/tf-50b8/src/socket.h:24: multiple definition of
  #     `world_decl'; command.o:/build/tf-50b8/src/socket.h:24: first defined here
  NIX_CFLAGS_COMPILE="-fcommon";

  meta = with lib; {
    homepage = "http://tinyfugue.sourceforge.net/";
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

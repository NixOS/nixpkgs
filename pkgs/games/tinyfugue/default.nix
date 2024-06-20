{ lib, stdenv, fetchurl, ncurses, zlib
, openssl ? null
, sslSupport ? true
}:

assert sslSupport -> openssl != null;

let
  inherit (lib)
    licenses
    maintainers
    optional
    platforms
    ;
in

stdenv.mkDerivation rec {
  pname = "tinyfugue";
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

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: world.o:/build/tf-50b8/src/socket.h:24: multiple definition of
  #     `world_decl'; command.o:/build/tf-50b8/src/socket.h:24: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = {
    homepage = "https://tinyfugue.sourceforge.net/";
    description = "Terminal UI, screen-oriented MUD client";
    mainProgram = "tf";
    longDescription = ''
      TinyFugue, aka "tf", is a flexible, screen-oriented MUD client, for use
      with any type of text MUD.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.KibaFox ];
  };
}

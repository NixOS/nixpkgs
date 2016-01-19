{ stdenv, musl, ... }:
stdenv.mkDerivation {
  name = "env-friendly-1.0.0";

  unpackPhase = ''
    cp -v ${./Makefile} Makefile
    cp -v ${./env.c} env.c
  '';

  CFLAGS = "-isystem ${musl}/include -B${musl}/lib -L${musl}/lib";
  LDFLAGS = "-static -Wl,--gc-sections";

  meta = with stdenv.lib; {
    description = "An environmentally friendly replacement for /usr/bin/env";
    license = licenses.cc0;
    maintainers = [ "Nathan Zadoks <nathan@nathan7.eu>" ];
    platforms = stdenv.lib.platforms.linux;
  };
}

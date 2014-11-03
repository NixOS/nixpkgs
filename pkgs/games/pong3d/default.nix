{stdenv, fetchurl, libX11}:

stdenv.mkDerivation {
  name = "3dpong-0.5";
  src = fetchurl {
    url = ftp://ftp.tuxpaint.org/unix/x/3dpong/src/3dpong-0.5.tar.gz;
    sha256 = "1ibb79sbzlbn4ra3n0qk22gqr6fg7q0jy6cm0wg2qj4z64c7hmdi";
  };

  buildInputs = [ libX11 ];

  preConfigure = ''
    sed -i s,/usr/local,$out, Makefile
    mkdir -p $out/bin
  '';

  meta = {
    homepage = http://www.newbreedsoftware.com/3dpong/;
    description = "One or two player 3d sports game based on Pong from Atari";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}

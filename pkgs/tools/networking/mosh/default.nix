{ stdenv, fetchurl, zlib, boost, protobuf, ncurses, pkgconfig, IOTty
, makeWrapper, perl, openssl }:

stdenv.mkDerivation rec {
  name = "mosh-1.2.4";

  src = fetchurl {
    url = "http://mosh.mit.edu/${name}.tar.gz";
    sha256 = "0inzfmqrab3n97m7rrmhd4xh3hjz0xva2sfl5m06w11668r0skg7";
  };

  buildInputs = [ boost protobuf ncurses zlib pkgconfig IOTty makeWrapper perl openssl ];

  postInstall = ''
      wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
  '';

  meta = {
    homepage = http://mosh.mit.edu/;
    description = "Mobile shell (ssh replacement)";
    longDescription = ''
      Remote terminal application that allows roaming, supports intermittent
      connectivity, and provides intelligent local echo and line editing of
      user keystrokes.

      Mosh is a replacement for SSH. It's more robust and responsive,
      especially over Wi-Fi, cellular, and long-distance links.
    '';
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.unix;
  };
}

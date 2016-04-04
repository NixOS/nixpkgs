{ stdenv, fetchurl, zlib, boost, protobuf, ncurses, pkgconfig, IOTty
, makeWrapper, perl, openssl, autoreconfHook, fetchpatch }:

stdenv.mkDerivation rec {
  name = "mosh-1.2.5";

  src = fetchurl {
    url = "http://mosh.mit.edu/${name}.tar.gz";
    sha256 = "1qsb0y882yfgwnpy6f98pi5xqm6kykdsrxzvaal37hs7szjhky0s";
  };

  buildInputs = [ autoreconfHook boost protobuf ncurses zlib pkgconfig IOTty makeWrapper perl openssl ];

  patches = [
    # remove automake detection macro patch on next release as it is already on mosh master
    (fetchpatch {
      name = "fix_automake_detection_macro.patch";
      url = "https://github.com/mobile-shell/mosh/commit/a47917b97606a03f6bbf0cafd1fcd495b0229790.patch";
      sha256 = "0ib200ffvbnns125xd58947fyxdx31m06rmnzqmxpxcnjza7k404";
    })
  ];

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

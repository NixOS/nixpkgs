{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dtach-0.8";

  src = fetchurl {
    url = "mirror://sourceforge/project/dtach/dtach/0.8/dtach-0.8.tar.gz";
    sha256 = "16614ebddf8ab2811d3dc0e7f329c7de88929ac6a9632d4cb4aef7fe11b8f2a9";
  };

  installPhase = ''
    ensureDir $out/bin
    cp dtach $out/bin/dtach
  '';

  meta = {
    homepage = http://dtach.sourceforge.net/;
    description = "A program that emulates the detach feature of screen";

    longDescription = ''dtach is a tiny program that emulates the
      detach feature of screen, allowing you to run a program in an
      environment that is protected from the controlling terminal and
      attach to it later. dtach does not keep track of the contents of
      the screen, and thus works best with programs that know how to
      redraw themselves.'';

    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}

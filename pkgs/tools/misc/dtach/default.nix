{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "dtach";
  version = "0.9";

  src = fetchurl {
    url = "mirror://sourceforge/project/dtach/dtach/${version}/${pname}-${version}.tar.gz";
    sha256 = "1wwj2hlngi8qn2pisvhyfxxs8gyqjlgrrv5lz91w8ly54dlzvs9j";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp dtach $out/bin/dtach
  '';

  meta = {
    homepage = "https://dtach.sourceforge.net/";
    description = "A program that emulates the detach feature of screen";

    longDescription = ''
      dtach is a tiny program that emulates the detach feature of
      screen, allowing you to run a program in an environment that is
      protected from the controlling terminal and attach to it later.
      dtach does not keep track of the contents of the screen, and
      thus works best with programs that know how to redraw
      themselves.
    '';

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "dtach";
  };
}

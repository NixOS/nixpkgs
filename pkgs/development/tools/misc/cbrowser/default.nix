{ fetchurl, stdenv, cscope, tk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "cbrowser-0.8";

  src = fetchurl {
    url = "mirror://sourceforge/cbrowser/cbrowser-0.8.tar.gz";
    sha256 = "1050mirjab23qsnq3lp3a9vwcbavmh9kznzjm7dr5vkx8b7ffcji";
  };

  patches = [ ./backslashes-quotes.diff ];

  buildInputs = [ tk makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/${name}
    cp -R * $out/share/${name}/

    makeWrapper $out/share/${name}/cbrowser $out/bin/cbrowser \
      --prefix PATH : ${tk}/bin
  '';

  meta = {
    description = "Tcl/Tk GUI front-end to cscope";

    license = stdenv.lib.licenses.gpl2Plus;

    homepage = http://sourceforge.net/projects/cbrowser/;

    maintainers = with stdenv.lib.maintainers; [viric];

    platforms = with stdenv.lib.platforms; linux;
  };
}

{ fetchurl, lib, stdenv, tk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "cbrowser-0.8";

  src = fetchurl {
    url = "mirror://sourceforge/cbrowser/cbrowser-0.8.tar.gz";
    sha256 = "1050mirjab23qsnq3lp3a9vwcbavmh9kznzjm7dr5vkx8b7ffcji";
  };

  patches = [ ./backslashes-quotes.diff ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ tk ];

  installPhase = ''
    mkdir -p $out/bin $out/share/${name}
    cp -R * $out/share/${name}/

    makeWrapper $out/share/${name}/cbrowser $out/bin/cbrowser \
      --prefix PATH : ${tk}/bin
  '';

  meta = {
    description = "Tcl/Tk GUI front-end to cscope";

    license = lib.licenses.gpl2Plus;

    homepage = "https://sourceforge.net/projects/cbrowser/";

    maintainers = with lib.maintainers; [viric];

    platforms = with lib.platforms; linux;
  };
}

{stdenv, fetchurl, libX11, libXaw}:

let
  name = "autocutsel-0.9.0";
in
stdenv.mkDerivation {
  inherit name;
 
  src = fetchurl {
    url = "mirror://savannah/autocutsel/${name}.tar.gz";
    sha256 = "0hp335qq57l0kp58pfwb0bk930zx5497frq8y0lzr4icvk1fpw5y";
  };
 
  buildInputs = [ libX11 libXaw ];
  installPhase = ''
    mkdir -p $out/bin
    cp autocutsel $out/bin/
  '';

  meta = {
    homepage = "http://www.nongnu.org/autocutsel/";
    description = "Tracks changes in the server's cutbuffer and CLIPBOARD selection";
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; all;
  };
}

{stdenv, fetchurl, libX11, libXaw}:

let
  name = "autocutsel-0.9.0";
in
stdenv.mkDerivation {
  inherit name;
 
  src = fetchurl {
    url = "http://savannah.nongnu.org/download/autocutsel/${name}.tar.gz";
    sha256 = "0hp335qq57l0kp58pfwb0bk930zx5497frq8y0lzr4icvk1fpw5y";
  };
 
  buildInputs = [ libX11 libXaw ];
  installPhase = ''
   mkdir -p $out/bin
   cp autocutsel $out/bin/
   '';

  meta = {
    homepage = "http://www.nongnu.org/autocutsel/";
    description = "Autocutsel tracks changes in the server's cutbuffer and CLIPBOARD selection.";
    license = "GNU/GPL";
    maintainers = with stdenv.lib.maintainers; [];
    platforms = with stdenv.lib.platforms; all;
  };
}

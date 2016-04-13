{ stdenv, fetchurl }:

let version = "0.2"; in
stdenv.mkDerivation {
  name = "regionset-${version}";

  src = fetchurl {
    url = "http://linvdr.org/download/regionset/regionset-${version}.tar.gz";
    sha256 = "1fgps85dmjvj41a5bkira43vs2aiivzhqwzdvvpw5dpvdrjqcp0d";
  };

  installPhase = ''
    install -Dm755 {.,$out/bin}/regionset
    install -Dm644 {.,$out/share/man/man8}/regionset.8
  '';

  meta = with stdenv.lib; {
    inherit version;
    homepage = http://linvdr.org/projects/regionset/;
    descriptions = "Tool for changing the region code setting of DVD players";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}

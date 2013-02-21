{ stdenv, fetchurl, libX11, libXxf86vm, libXext }:

stdenv.mkDerivation rec {
  name = "xcalib-0.8";

  src = fetchurl {
    url = "mirror://sourceforge/xcalib/xcalib-source-0.8.tar.gz";
    sha256 = "8a112ee710e5446f6c36e62345b2066f10639d500259db8c48bf1716caea06e6";
  };

  buildInputs = [ libX11 libXxf86vm libXext ];

  installPhase = ''
    mkdir -p $out/bin
    cp xcalib $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = http://xcalib.sourceforge.net/;
    description = "A tiny monitor calibration loader for X and MS-Windows";
    license = licenses.gpl2;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}

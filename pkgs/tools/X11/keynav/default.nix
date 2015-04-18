{ stdenv, fetchurl, pkgconfig, libX11, xextproto, libXtst, libXi, libXext
, libXinerama, glib, cairo, xdotool }:

stdenv.mkDerivation rec {
  name = "keynav-0.20110708.0";

  src = fetchurl {
    url = "https://semicomplete.googlecode.com/files/${name}.tar.gz";
    sha256 = "1gizjhji3yspxxxvb90js3z1bv18rbf5phxg8rciixpj3cccff8z";
  };

  buildInputs = [ pkgconfig libX11 xextproto libXtst libXi libXext libXinerama
                  glib cairo xdotool ];

  installPhase =
    ''
      mkdir -p $out/bin $out/share/keynav/doc
      cp keynav $out/bin
      cp keynavrc $out/share/keynav/doc
    '';

  meta = with stdenv.lib; {
    description = "Generate X11 mouse clicks from keyboard";
    homepage = http://www.semicomplete.com/projects/keynav/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}

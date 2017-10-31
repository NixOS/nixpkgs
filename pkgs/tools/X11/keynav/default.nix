{ stdenv, fetchFromGitHub, pkgconfig, libX11, xextproto, libXtst, libXi, libXext
, libXinerama, glib, cairo, xdotool }:

let release = "20150730"; in
stdenv.mkDerivation rec {
  name = "keynav-0.${release}.0";

  src = fetchFromGitHub {
    owner = "jordansissel";
    repo = "keynav";
    rev = "4ae486db6697877e84b66583a0502afc7301ba16";
    sha256 = "0v1m8w877fcrk918p6b6q3753dsz8i1f4mb9bi064cp11kh85nq5";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 xextproto libXtst libXi libXext libXinerama
                  glib cairo xdotool ];

  patchPhase = ''
    echo >>VERSION MAJOR=0
    echo >>VERSION RELEASE=${release}
    echo >>VERSION REVISION=0
  '';

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

{ stdenv, fetchFromGitHub, pkgconfig, libX11, xorgproto, libXtst, libXi, libXext
, libXinerama, libXrandr, glib, cairo, xdotool }:

let release = "20180821"; in
stdenv.mkDerivation rec {
  name = "keynav-0.${release}.0";

  src = fetchFromGitHub {
    owner = "jordansissel";
    repo = "keynav";
    rev = "78f9e076a5618aba43b030fbb9344c415c30c1e5";
    sha256 = "0hmc14fj612z5h7gjgk95zyqab3p35c4a99snnblzxfg0p3x2f1d";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 xorgproto libXtst libXi libXext libXinerama libXrandr
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
    homepage = https://www.semicomplete.com/projects/keynav/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}

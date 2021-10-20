{ stdenv, lib, fetchurl, fpc, lazarus, atk, cairo, gdk-pixbuf, glib, gtk2, libX11, pango }:

let
  versionBase = "0.4";
  versionSuffix = "alpha4";
in stdenv.mkDerivation rec {
  pname = "ddrescueview";
  version = "${versionBase}${versionSuffix}";

  src = fetchurl {
    name = "ddrescueview-${versionBase}${versionSuffix}.tar.xz";
    url = "mirror://sourceforge/ddrescueview/ddrescueview-source-${versionBase}~${versionSuffix}.tar.xz";
    sha256 = "0v159nlc0lrqznbbwi7zda619is5h2rjk55gz6cl807j0kd19ycc";
  };
  sourceRoot = "ddrescueview-source-${versionBase}~${versionSuffix}/source";

  nativeBuildInputs = [ fpc lazarus ];

  buildInputs = [ atk cairo gdk-pixbuf glib gtk2 libX11 pango ];

  NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath buildInputs}";

  buildPhase = ''
    lazbuild --lazarusdir=${lazarus}/share/lazarus ddrescueview.lpi
  '';

  installPhase = ''
    install -Dt $out/bin ddrescueview
    cd ../resources/linux
    mkdir -p "$out/share"
    cp -ar applications icons man $out/share
  '';

  meta = with lib; {
    description = "A tool to graphically examine ddrescue mapfiles";
    homepage = "https://sourceforge.net/projects/ddrescueview/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}

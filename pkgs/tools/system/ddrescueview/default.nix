{ stdenv, lib, fetchurl, fpc, lazarus, atk, cairo, gdk-pixbuf, glib, gtk2, libX11, pango }:

stdenv.mkDerivation rec {
  name = "ddrescueview-0.4alpha3";

  src = fetchurl {
    name = "${name}.tar.xz";
    url = "mirror://sourceforge/ddrescueview/ddrescueview-source-0.4%7Ealpha3.tar.xz";
    sha256 = "0603jisxkswfyh93s3i20f8ns4yf83dmgmy0lg5001rvaw9mkw9j";
  };

  nativeBuildInputs = [ fpc lazarus ];

  buildInputs = [ atk cairo gdk-pixbuf glib gtk2 libX11 pango ];

  sourceRoot = "source";

  NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath buildInputs}";

  buildPhase = ''
    lazbuild --lazarusdir=${lazarus}/share/lazarus ddrescueview.lpi
  '';

  installPhase = ''
    install -Dt $out/bin ddrescueview
    cd ../resources/linux
    install -Dt $out/share/applications ddrescueview.desktop
    install -Dt $out/share/icons/hicolor/32x32/apps ddrescueview.xpm
    install -Dt $out/share/man/man1 ddrescueview.1
  '';

  meta = with lib; {
    description = "A tool to graphically examine ddrescue mapfiles";
    homepage = https://sourceforge.net/projects/ddrescueview/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}

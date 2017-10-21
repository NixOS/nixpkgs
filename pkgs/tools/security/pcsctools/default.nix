{ stdenv, lib, fetchurl, makeWrapper, pkgconfig, udev, dbus_libs, pcsclite
, wget, coreutils
, perl, pcscperl, Glib, Gtk2, Pango, Cairo
}:

let deps = lib.makeBinPath [ wget coreutils ];

in stdenv.mkDerivation rec {
  name = "pcsc-tools-1.4.25";

  src = fetchurl {
    url = "http://ludovic.rousseau.free.fr/softwares/pcsc-tools/${name}.tar.gz";
    sha256 = "0iqcy28pb963ds4pjrpi37577vm6nkgf3i0b3rr978jy9qi1bix9";
  };

  buildInputs = [ udev dbus_libs perl pcsclite ];

  makeFlags = [ "DESTDIR=$(out)" ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  postInstall = ''
    wrapProgram $out/bin/scriptor \
      --set PERL5LIB "${lib.makePerlPath [ pcscperl ]}"
    wrapProgram $out/bin/gscriptor \
      --set PERL5LIB "${lib.makePerlPath [ pcscperl Glib Gtk2 Pango Cairo ]}"
    wrapProgram $out/bin/ATR_analysis \
      --set PERL5LIB "${lib.makePerlPath [ pcscperl ]}"
    wrapProgram $out/bin/pcsc_scan \
      --set PATH "$out/bin:${deps}"
  '';

  meta = with lib; {
    description = "Tools used to test a PC/SC driver, card or reader";
    homepage = http://ludovic.rousseau.free.fr/softwares/pcsc-tools/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
  };
}

{ stdenv, lib, fetchurl, makeWrapper, pkgconfig, udev, dbus, pcsclite
, wget, coreutils, perlPackages
}:

let deps = lib.makeBinPath [ wget coreutils ];

in stdenv.mkDerivation rec {
  name = "pcsc-tools-1.5.5";

  src = fetchurl {
    url = "http://ludovic.rousseau.free.fr/softwares/pcsc-tools/${name}.tar.bz2";
    sha256 = "01251m8hf7by8rw8fayhjxmcqvi6dp150680fpf89bqycha2vgqv";
  };

  buildInputs = [ udev dbus perlPackages.perl pcsclite ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  postInstall = ''
    wrapProgram $out/bin/scriptor \
      --set PERL5LIB "${with perlPackages; makePerlPath [ pcscperl ]}"
    wrapProgram $out/bin/gscriptor \
      --set PERL5LIB "${with perlPackages; makePerlPath [ pcscperl Glib Gtk2 Pango Cairo ]}"
    wrapProgram $out/bin/ATR_analysis \
      --set PERL5LIB "${with perlPackages; makePerlPath [ pcscperl ]}"
    wrapProgram $out/bin/pcsc_scan \
      --set PATH "$out/bin:${deps}"
  '';

  meta = with lib; {
    description = "Tools used to test a PC/SC driver, card or reader";
    homepage = http://ludovic.rousseau.free.fr/softwares/pcsc-tools/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

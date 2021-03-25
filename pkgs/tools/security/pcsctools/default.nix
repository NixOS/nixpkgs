{ stdenv, lib, fetchurl, makeWrapper, pkg-config, udev, dbus, pcsclite
, wget, coreutils, perlPackages
}:

let deps = lib.makeBinPath [ wget coreutils ];

in stdenv.mkDerivation rec {
  name = "pcsc-tools-1.5.7";

  src = fetchurl {
    url = "http://ludovic.rousseau.free.fr/softwares/pcsc-tools/${name}.tar.bz2";
    sha256 = "17b9jxvcxmn007lavan20l25v4jvm6dqc4x9dlqzbg6mjs28zsp0";
  };

  buildInputs = [ udev dbus perlPackages.perl pcsclite ];

  nativeBuildInputs = [ makeWrapper pkg-config ];

  postInstall = ''
    wrapProgram $out/bin/scriptor \
      --set PERL5LIB "${with perlPackages; makePerlPath [ pcscperl ]}"
    wrapProgram $out/bin/gscriptor \
      --set PERL5LIB "${with perlPackages; makePerlPath [ pcscperl GlibObjectIntrospection Glib Gtk3 Pango Cairo CairoGObject ]}"
    wrapProgram $out/bin/ATR_analysis \
      --set PERL5LIB "${with perlPackages; makePerlPath [ pcscperl ]}"
    wrapProgram $out/bin/pcsc_scan \
      --set PATH "$out/bin:${deps}"
  '';

  meta = with lib; {
    description = "Tools used to test a PC/SC driver, card or reader";
    homepage = "http://ludovic.rousseau.free.fr/softwares/pcsc-tools/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

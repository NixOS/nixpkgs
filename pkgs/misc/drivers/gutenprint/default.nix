# this package was called gimp-print in the past
{ stdenv, lib, fetchurl, pkgconfig
, ijs, makeWrapper
, gimp2Support ? true, gimp
, cupsSupport ? true, cups, libusb, perl
}:

stdenv.mkDerivation rec {
  name = "gutenprint-5.2.11";

  src = fetchurl {
    url = "mirror://sourceforge/gimp-print/${name}.tar.bz2";
    sha256 = "1yadw96rgp1z0jv1wxrz6cds36nb693w3xlv596xw9r5w394r8y1";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs =
    [ ijs ]
    ++ lib.optionals gimp2Support [ gimp.gtk gimp ]
    ++ lib.optionals cupsSupport [ cups libusb perl ];

  configureFlags = lib.optionals cupsSupport [
    "--disable-static-genppd" # should be harmless on NixOS
  ];

  enableParallelBuilding = true;

  # Testing is very, very long.
  # doCheck = true;

  installFlags =
    lib.optionals cupsSupport [ "cups_conf_datadir=$(out)/share/cups" "cups_conf_serverbin=$(out)/lib/cups" "cups_conf_serverroot=$(out)/etc/cups" ]
    ++ lib.optionals gimp2Support [ "gimp2_plug_indir=$(out)/${gimp.name}-plugins" ];

  meta = with stdenv.lib; {
    description = "Ghostscript and cups printer drivers";
    homepage = http://sourceforge.net/projects/gimp-print/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

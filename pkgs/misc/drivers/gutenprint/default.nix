# this package was called gimp-print in the past
{ stdenv, lib, fetchurl, pkgconfig
, ijs, makeWrapper
, gimp2Support ? false, gimp
, cupsSupport ? true, cups, libusb, perl
}:

stdenv.mkDerivation rec {
  name = "gutenprint-5.2.13";

  src = fetchurl {
    url = "mirror://sourceforge/gimp-print/${name}.tar.bz2";
    sha256 = "0hi7s0y59306p4kp06sankfa57k2805khbknkvl9d036hdfp9afr";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs =
    [ ijs ]
    ++ lib.optionals gimp2Support [ gimp.gtk gimp ]
    ++ lib.optionals cupsSupport [ cups libusb perl ];

  configureFlags = lib.optionals cupsSupport [
    "--disable-static-genppd" # should be harmless on NixOS
  ];

  # FIXME: hacky because we modify generated configure, but I haven't found a better way.
  # makeFlags doesn't change this everywhere (e.g. in cups-genppdupdate).
  preConfigure = lib.optionalString cupsSupport ''
    sed -i \
      -e "s,cups_conf_datadir=.*,cups_conf_datadir=\"$out/share/cups\",g" \
      -e "s,cups_conf_serverbin=.*,cups_conf_serverbin=\"$out/lib/cups\",g" \
      -e "s,cups_conf_serverroot=.*,cups_conf_serverroot=\"$out/etc/cups\",g" \
      configure
  '' + lib.optionalString gimp2Support ''
    sed -i \
      -e "s,gimp2_plug_indir=.*,gimp2_plug_indir=\"$out/lib/gimp/${gimp.majorVersion}\",g" \
      configure
  '';

  enableParallelBuilding = true;

  # Testing is very, very long.
  # doCheck = true;

  meta = with stdenv.lib; {
    description = "Ghostscript and cups printer drivers";
    homepage = https://sourceforge.net/projects/gimp-print/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

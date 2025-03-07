# this package was called gimp-print in the past
{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  pkg-config,
  ijs,
  zlib,
  gimp2Support ? false,
  gimp,
  cupsSupport ? true,
  cups,
  libusb1,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "gutenprint";
  version = "5.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/gimp-print/gutenprint-${version}.tar.bz2";
    sha256 = "0s0b14hjwvbxksq7af5v8z9g2rfqv9jdmxd9d81m57f5mh6rad0p";
  };

  strictDeps = true;
  nativeBuildInputs =
    [
      makeWrapper
      pkg-config
    ]
    ++ lib.optionals cupsSupport [
      cups
      perl
    ]; # for cups-config
  buildInputs =
    [
      ijs
      zlib
    ]
    ++ lib.optionals gimp2Support [
      gimp.gtk
      gimp
    ]
    ++ lib.optionals cupsSupport [
      cups
      libusb1
      perl
    ];

  configureFlags = lib.optionals cupsSupport [
    "--disable-static-genppd" # should be harmless on NixOS
  ];

  # FIXME: hacky because we modify generated configure, but I haven't found a better way.
  # makeFlags doesn't change this everywhere (e.g. in cups-genppdupdate).
  preConfigure =
    lib.optionalString cupsSupport ''
      sed -i \
        -e "s,cups_conf_datadir=.*,cups_conf_datadir=\"$out/share/cups\",g" \
        -e "s,cups_conf_serverbin=.*,cups_conf_serverbin=\"$out/lib/cups\",g" \
        -e "s,cups_conf_serverroot=.*,cups_conf_serverroot=\"$out/etc/cups\",g" \
        configure
    ''
    + lib.optionalString gimp2Support ''
      sed -i \
        -e "s,gimp2_plug_indir=.*,gimp2_plug_indir=\"$out/lib/gimp/${gimp.majorVersion}\",g" \
        configure
    '';

  enableParallelBuilding = true;

  # Testing is very, very long.
  # doCheck = true;

  meta = with lib; {
    description = "Ghostscript and cups printer drivers";
    homepage = "https://sourceforge.net/projects/gimp-print/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    isGutenprint = true;
  };
}

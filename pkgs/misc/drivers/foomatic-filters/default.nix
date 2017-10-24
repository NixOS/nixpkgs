{ stdenv, fetchpatch, fetchurl, pkgconfig, perl, cups, dbus, enscript }:

stdenv.mkDerivation rec {
  name = "foomatic-filters-4.0.17";

  src = fetchurl {
    url = "http://www.openprinting.org/download/foomatic/${name}.tar.gz";
    sha256 = "1qrkgbm5jay2r7sh9qbyf0aiyrsl1mdc844hxf7fhw95a0zfbqm2";
  };

  buildInputs = [ pkgconfig perl cups dbus enscript ];

  patches = [
    # for CVE-2015-8327 & CVE-2015-8560
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/collab-maint/foomatic-filters.git/plain/debian/patches/0500-r7406_also_consider_the_back_tick_as_an_illegal_shell_escape_character.patch";
      sha256 = "055nwi3sjf578nk40bqsch3wx8m2h65hdih0wmxflb6l0hwkq4p4";
    })
  ];

  preConfigure =
    ''
      substituteInPlace foomaticrip.c --replace /bin/bash /bin/sh
    '';

  installTargets = "install-cups";

  installFlags =
    ''
      CUPS_FILTERS=$(out)/lib/cups/filter
      CUPS_BACKENDS=$(out)/lib/cups/backend
    '';

  meta = {
    description = "Foomatic printing filters";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}

{ lib, stdenv, fetchpatch, fetchurl, pkg-config, perl, cups, dbus, enscript }:

stdenv.mkDerivation rec {
  pname = "foomatic-filters";
  version = "4.0.17";

  src = fetchurl {
    url = "https://www.openprinting.org/download/foomatic/foomatic-filters-${version}.tar.gz";
    sha256 = "1qrkgbm5jay2r7sh9qbyf0aiyrsl1mdc844hxf7fhw95a0zfbqm2";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ perl cups dbus enscript ];

  patches = [
    (fetchpatch {
      name = "CVE-2015-8327+CVE-2015-8560.patch";
      url = "https://salsa.debian.org/debian/foomatic-filters/raw/a3abbef2d2f8c7e62d2fe64f64afe294563fdf8f/debian/patches/0500-r7406_also_consider_the_back_tick_as_an_illegal_shell_escape_character.patch";
      sha256 = "055nwi3sjf578nk40bqsch3wx8m2h65hdih0wmxflb6l0hwkq4p4";
    })
  ];

  preConfigure =
    ''
      substituteInPlace foomaticrip.c --replace /bin/bash ${stdenv.shell}
    '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: foomatic_rip-options.o:/build/foomatic-filters-4.0.17/options.c:49: multiple definition of
  #     `cupsfilter'; foomatic_rip-foomaticrip.o:/build/foomatic-filters-4.0.17/foomaticrip.c:158: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  installTargets = [ "install-cups" ];

  installFlags = [
    "CUPS_FILTERS=$(out)/lib/cups/filter"
    "CUPS_BACKENDS=$(out)/lib/cups/backend"
  ];

  meta = {
    description = "Foomatic printing filters";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}

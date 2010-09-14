{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "dmidecode-2.10";

  src = fetchurl {
    url = "http://www.very-clever.com/download/nongnu/dmidecode/${name}.tar.bz2";
    sha256 = "1h72r5scrpvgw60hif5msjg6vw2x0jd6z094lhbh6cjk6gls6x2d";
  };

  # Taken from gentoo, to build with gnumake 3.82
  # http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/sys-apps/dmidecode/dmidecode-2.10.ebuild?r1=1.5&r2=1.6
  patchPhase = ''
    sed -i -e '/^PROGRAMS !=/d' Makefile
  '';

  makeFlags = "prefix=$(out)";

  meta = {
    homepage = http://www.nongnu.org/dmidecode/;
    description = "A tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
  };
}

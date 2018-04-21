{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "acpid-2.0.29";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/${name}.tar.xz";
    sha256 = "1zq38al07z92r2md18zivrzgjqnn7m2wahdpgri6wijwjwkknl2q";
  };

  meta = with stdenv.lib; {
    homepage = http://tedfelix.com/linux/acpid-netlink.html;
    description = "A daemon for delivering ACPI events to userspace programs";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}

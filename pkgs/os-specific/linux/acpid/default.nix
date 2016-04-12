{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "acpid-2.0.27";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/${name}.tar.xz";
    sha256 = "05m6scbdzi2fb8zzi01c11a10pr0qb1gzccz4bbxj4fcacz24342";
  };

  preBuild = ''
    makeFlagsArray=(BINDIR=$out/bin SBINDIR=$out/sbin MAN8DIR=$out/share/man/man8)
  '';

  meta = {
    homepage = http://tedfelix.com/linux/acpid-netlink.html;
    description = "A daemon for delivering ACPI events to userspace programs";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "acpid-2.0.27";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/${name}.tar.xz";
    sha256 = "05m6scbdzi2fb8zzi01c11a10pr0qb1gzccz4bbxj4fcacz24342";
  };

  meta = with stdenv.lib; {
    homepage = http://tedfelix.com/linux/acpid-netlink.html;
    description = "A daemon for delivering ACPI events to userspace programs";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}

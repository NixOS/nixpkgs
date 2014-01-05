{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "acpid-2.0.20";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/${name}.tar.xz";
    sha256 = "0l7pzjcpf1935bn44kzgc16h00clbx73cjm2dlyhzvvb5ksvl7ka";
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

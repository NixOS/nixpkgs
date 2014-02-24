{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "acpid-2.0.21";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/${name}.tar.xz";
    sha256 = "0vv3zz8p3wxhlp35aqgqvzn6lda595wzn7php3k47jwci1cpxrn4";
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

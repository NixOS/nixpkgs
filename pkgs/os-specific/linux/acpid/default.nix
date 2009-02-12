{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "acpid-1.0.8";
  
  src = fetchurl {
    url = mirror://sourceforge/acpid/acpid-1.0.8.tar.gz;
    sha256 = "1cdp4vql8ya073b42mjpzpzzn1py00baazq91837vhrq5hqfaynm";
  };

  preBuild = ''
    makeFlagsArray=(BINDIR=$out/bin SBINDIR=$out/sbin MAN8DIR=$out/share/man/man8)
  '';

  meta = {
    homepage = http://acpid.sourceforge.net/;
    description = "A daemon for delivering ACPI events to userspace programs";
    license = "GPLv2+";
  };
}

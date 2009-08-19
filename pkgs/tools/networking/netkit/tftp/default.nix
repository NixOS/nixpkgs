{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "netkit-tftp-0.17";

  src = fetchurl {
    url = "ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${name}.tar.gz";
    sha256 = "0kfibbjmy85r3k92cdchha78nzb6silkgn1zaq9g8qaf1l0w0hrs";
  };

  preInstall = "
    ensureDir $out/man/man{1,8} $out/sbin $out/bin
  ";

  meta = {
    description = "Netkit TFTP client and server";
    homepage = "ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/";
    license = "BSD";
  };
}

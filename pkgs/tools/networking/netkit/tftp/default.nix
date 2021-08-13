{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "netkit-tftp";
  version = "0.17";

  src = fetchurl {
    urls = [
      "mirror://ubuntu/pool/universe/n/netkit-tftp/netkit-tftp_${version}.orig.tar.gz"
      "ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/netkit-tftp-${version}.tar.gz"
      "https://ftp.cc.uoc.gr/mirrors/linux/ubuntu/packages/pool/universe/n/netkit-tftp/netkit-tftp_${version}.orig.tar.gz"
    ];
    sha256 = "0kfibbjmy85r3k92cdchha78nzb6silkgn1zaq9g8qaf1l0w0hrs";
  };

  preInstall = "
    mkdir -p $out/man/man{1,8} $out/sbin $out/bin
  ";

  meta = {
    description = "Netkit TFTP client and server";
    homepage = "ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}

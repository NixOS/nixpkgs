{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "acpid-2.0.17";

  src = fetchurl {
    url = "http://tedfelix.com/linux/${name}.tar.xz";
    sha256 = "0gksl6z3sb6yyk7bdmldxsrncvprd3rny0i8ggl4m95nvv3x5drn";
  };

  preBuild = ''
    makeFlagsArray=(BINDIR=$out/bin SBINDIR=$out/sbin MAN8DIR=$out/share/man/man8)
  '';

  meta = {
    homepage = http://tedfelix.com/linux/acpid-netlink.html;
    description = "A daemon for delivering ACPI events to userspace programs";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}

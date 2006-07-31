{stdenv, fetchurl, hotplugSupport ? false}:

assert hotplugSupport -> stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "sane-backends-1.0.18";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.sane-project.org/pub/sane/sane-backends-1.0.18/sane-backends-1.0.18.tar.gz;
    md5 = "7ca7e2908e24721471de92cf40c75e60";
  };
  udevSupport = hotplugSupport;
}

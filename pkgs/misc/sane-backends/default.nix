{stdenv, fetchurl, hotplugSupport ? false}:

assert hotplugSupport -> stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "sane-backends-1.0.17";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp3.sane-project.org/pub/sane/sane-backends-1.0.17/sane-backends-1.0.17.tar.gz;
    md5 = "b51c10da8a81a04e1bae88c9e6556df2";
  };
  inherit hotplugSupport;
}

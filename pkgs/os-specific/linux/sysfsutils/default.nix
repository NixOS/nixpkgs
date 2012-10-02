{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sysfsutils-2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/linux-diag/${name}.tar.gz";
    sha256 = "e865de2c1f559fff0d3fc936e660c0efaf7afe662064f2fb97ccad1ec28d208a";
  };

  meta = {
    homepage = http://linux-diag.sourceforge.net/Sysfsutils.html;
    longDescription =
      ''
        These are a set of utilites built upon sysfs, a new virtual
        filesystem in Linux kernel versions 2.5+ that exposes a system's
        device tree.
      '';
    license = "GPL-v2 / LGPL-v2.1";
  };
}

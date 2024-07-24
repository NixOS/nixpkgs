{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "sysfsutils";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/linux-diag/sysfsutils-${version}.tar.gz";
    sha256 = "e865de2c1f559fff0d3fc936e660c0efaf7afe662064f2fb97ccad1ec28d208a";
  };

  meta = {
    homepage = "https://linux-diag.sourceforge.net/Sysfsutils.html";
    longDescription =
      ''
        These are a set of utilites built upon sysfs, a new virtual
        filesystem in Linux kernel versions 2.5+ that exposes a system's
        device tree.
      '';
    license = with lib.licenses; [ gpl2Plus lgpl21 ];
    platforms = lib.platforms.linux;
  };
}

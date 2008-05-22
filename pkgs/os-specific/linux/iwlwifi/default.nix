{stdenv, fetchurl, kernel}:

let version = "1.2.25"; in

stdenv.mkDerivation rec {
  name = "iwlwifi-${version}-${kernel.version}";

  src = fetchurl {
    url = "http://www.intellinuxwireless.org/iwlwifi/downloads/iwlwifi-${version}.tgz";
    sha256 = "09fjy0swcyd77fdp8x2825wj5cd73hwbzl8mz9sy2ha21p1qwq1d";
  };

  preBuild = ''
    substituteInPlace scripts/generate_compatible \
      --replace '/usr/bin/env /bin/bash' $shell
    substituteInPlace Makefile \
      --replace /sbin/depmod true

    # Urgh, we need the complete kernel sources for some header
    # files.  So unpack the original kernel source tarball and copy
    # the configured include directory etc. on top of it.
    kernelVersion=$(cd ${kernel}/lib/modules && ls)
    kernelBuild=$(echo ${kernel}/lib/modules/$kernelVersion/source)
    tar xvfj ${kernel.src}
    kernelSource=$(echo $(pwd)/linux-*)
    cp -prd $kernelBuild/* $kernelSource

    makeFlags=KSRC=$kernelSource
    make $makeFlags || true
    make $makeFlags

    installFlags=KMISC=$out/lib/modules/$kernelVersion/misc
  ''; # */

  meta = {
    description = "Intel Wireless WiFi Link drivers for Linux";
    homepage = http://www.intellinuxwireless.org/;
    license = "GPLv2";
  };
}

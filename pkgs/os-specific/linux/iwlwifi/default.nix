{stdenv, fetchurl, kernel}:

stdenv.mkDerivation {
  name = "iwlwifi-1.2.23";

  src = fetchurl {
    url = http://www.intellinuxwireless.org/iwlwifi/downloads/iwlwifi-1.2.23.tgz;
    sha256 = "0a4szjgg5b2jj4ax85lakqa951ph6pw5wpwlrw3mnmvcda5ayiip";
  };

  preBuild = ''
    substituteInPlace scripts/generate_compatible \
      --replace '/usr/bin/env /bin/bash' $shell
    substituteInPlace Makefile \
      --replace /sbin/depmod true

    # Urgh, we need the complete kernel sources for some header
    # files.  So unpack the original kernel source tarball and copy
    # the configured include directory etc. on top of it.
    kernelBuild=$(echo ${kernel}/lib/modules/2.6.*/source)
    tar xvfj ${kernel.src}
    kernelSource=$(echo $(pwd)/linux-*)
    cp -prd $kernelBuild/* $kernelSource

    makeFlags=KSRC=$kernelSource
    make $makeFlags || true
    make $makeFlags

    installFlags=KMISC=$out
  ''; # */

  meta = {
    description = "Intel Wireless WiFi Link drivers for Linux";
    homepage = http://www.intellinuxwireless.org/;
  };
}

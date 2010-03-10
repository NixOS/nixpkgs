{stdenv, fetchurl, enableStatic ? false}:

let
  basicConfigure = ''
    make defconfig
    sed -i 's,.*CONFIG_PREFIX.*,CONFIG_PREFIX="'$out'",' .config
    sed -i 's,.*CONFIG_INSTALL_NO_USR.*,CONFIG_INSTALL_NO_USR=y,' .config
  '' +
    (if enableStatic then ''
      sed -i 's,.*CONFIG_STATIC.*,CONFIG_STATIC=y,' .config
    '' else "");

in

stdenv.mkDerivation {
  name = "busybox-1.16.0";

  src = fetchurl {
    url = http://busybox.net/downloads/busybox-1.16.0.tar.bz2;
    sha256 = "1n738zk01yi2sjrx2y36hpzxbslas8b91vzykcifr0p1j7ym0lim";
  };

  configurePhase = basicConfigure;

  crossAttrs = {
    configurePhase = basicConfigure + ''
      sed -i 's,.*CONFIG_CROSS_COMPILER_PREFIX.*,CONFIG_CROSS_COMPILER_PREFIX="'$crossConfig-'",' .config
    '' +
      (if (stdenv.cross.platform.kernelMajor == "2.4") then ''
        sed -i 's,.*CONFIG_IONICE.*,CONFIG_IONICE=n,' .config
      '' else "");
  };
}

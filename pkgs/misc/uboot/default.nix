{ stdenv, fetchurl, bc, dtc
, toolsOnly ? false
, defconfig ? "allnoconfig"
, targetPlatforms
, filesToInstall
}:

let
  platform = stdenv.platform;
  crossPlatform = stdenv.cross.platform;
  makeTarget = if toolsOnly then "tools NO_SDL=1" else "all";
  installDir = if toolsOnly then "$out/bin" else "$out";
  buildFun = kernelArch:
    ''
      if test -z "$crossConfig"; then
          make ${makeTarget}
      else
          make ${makeTarget} ARCH=${kernelArch} CROSS_COMPILE=$crossConfig-
      fi
    '';
in

stdenv.mkDerivation rec {
  name = "uboot-${defconfig}-${version}";
  version = "2015.10";

  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
    sha256 = "0m8r08izci0lzzjn5c5g5manp2rc7yc5swww0lxr7bamjigqvimx";
  };

  patches = [ ./vexpress-Use-config_distro_bootcmd.patch ];

  nativeBuildInputs = [ bc dtc ];

  configurePhase = ''
    make ${defconfig}
  '';

  buildPhase = assert (platform ? kernelArch);
    buildFun platform.kernelArch;

  installPhase = ''
    mkdir -p ${installDir}
    cp ${stdenv.lib.concatStringsSep " " filesToInstall} ${installDir}
  '';

  dontStrip = !toolsOnly;

  crossAttrs = {
    buildPhase = assert (crossPlatform ? kernelArch);
      buildFun crossPlatform.kernelArch;
  };

  meta = with stdenv.lib; {
    homepage = "http://www.denx.de/wiki/U-Boot/";
    description = "Boot loader for embedded systems";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = targetPlatforms;
  };
}

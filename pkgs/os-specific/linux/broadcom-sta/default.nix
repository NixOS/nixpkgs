{ stdenv, fetchurl, kernel }:
let
  version = "6.30.223.248";
in
stdenv.mkDerivation {
  name = "broadcom-sta-${version}-${kernel.version}";

  src = if stdenv.system == "i686-linux" then (
    fetchurl {
      url = http://www.broadcom.com/docs/linux_sta/hybrid-v35-nodebug-pcoem-6_30_223_248.tar.gz;
      sha256 = "1bd13pq5hj4yzp32rx71sg1i5wkzdsg1s32xsywb48lw88x595mi";
    } ) else (
    fetchurl {
      url = http://www.broadcom.com/docs/linux_sta/hybrid-v35_64-nodebug-pcoem-6_30_223_248.tar.gz;
      sha256 = "08ihbhwnqpnazskw9rlrk0alanp4x70kl8bsy2vg962iq334r69x";
    }
  );

  patches = [
    ./license.patch
    ./cfg80211_ibss_joined-channel-parameter.patch
    ./netdev-3.17.patch
  ];

  makeFlags = "KBASE=${kernel.dev}/lib/modules/${kernel.modDirVersion}";

  unpackPhase = ''
      sourceRoot=broadcom-sta
      mkdir "$sourceRoot"
      tar xvf "$src" -C "$sourceRoot"
  '';

  installPhase =
    ''
      binDir="$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
      docDir="$out/share/doc/broadcom-sta/"
      mkdir -p "$binDir" "$docDir"
      cp wl.ko "$binDir"
      cp lib/LICENSE.txt "$docDir"
    '';

  meta = {
    description = "Kernel module driver for some Broadcom's wireless cards";
    homepage = http://www.broadcom.com/support/802.11/linux_sta.php;
    license = stdenv.lib.licenses.unfreeRedistributable;
    maintainers = with stdenv.lib.maintainers; [ phreedom vcunat ];
    platforms = stdenv.lib.platforms.linux;
  };
}

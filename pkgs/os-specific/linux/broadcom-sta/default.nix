{ stdenv, fetchurl, kernel }:
let
  version = "6_30_223_141";
in
stdenv.mkDerivation {
  name = "broadcom-sta-${version}-${kernel.version}";

  src = if stdenv.system == "i686-linux" then (
    fetchurl {
      url = "http://www.broadcom.com/docs/linux_sta/hybrid-v35-nodebug-pcoem-${version}.tar.gz";
      sha256 = "19wra62dpm0x0byksh871yxr128b4v13kzkzqv56igjfpzv36z6m";
    } ) else (
    fetchurl {
      url = "http://www.broadcom.com/docs/linux_sta/hybrid-v35_64-nodebug-pcoem-${version}.tar.gz";
      sha256 = "0jlvch7d3khmmg5kp80x4ka33hidj8yykqjcqq6j56z2g6wb4dsz";
    }
  );

  patches = [
    ./linux-recent.patch
    ./license.patch
    ./cfg80211_ibss_joined-channel-parameter.patch
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
    license = "unfree-redistributable";
    maintainers = with stdenv.lib.maintainers; [ phreedom vcunat ];
    platforms = stdenv.lib.platforms.linux;
  };
}

# The firmware bundle as packaged by Debian. This should be "all" firmware that is not shipped
# as part of the kernel itself.
# You can either install the complete bundle, or write a separate package for individual
# devices that copies the firmware from this package.

{ stdenv, fetchurl, buildEnv, dpkg }:

let
  version = "0.36";


  packages = [
    { name = "linux-nonfree"; sha256 = "668d262dfcf18ffef2fe2a0b853b81bf5855f49fd2133203cbda097b1507c953"; }
    { name = "atheros"; sha256 = "27cbd2099ce28c742f42833b09a61bdc7fb5b2ebcf5b35a52e750160ea1001b6"; }
    { name = "bnx2"; sha256 = "32730fdeb0fb15a36e0ca046bde69e1a6fece8561af57afc7d9f1cf978fd25ab"; }
    { name = "bnx2x"; sha256 = "22f23f4abb4aa2dac22718f12cf3bbd3fd2d63870b13e81c8401e6f841a719e8"; }
    { name = "brcm80211"; sha256 = "17055c4199cc7e2aaa7d1d76dd5e718d24dbebb84020bb2d95ffab03bcfc7e8a"; }
    { name = "intelwimax"; sha256 = "cc1b894990d3074e93b3f79b2b617614aab554b5e832d34993b5a16f64bdb84a"; }
    { name = "ipw2x00"; sha256 = "2ef0810e2e037f7d536b24cc35527c456ff13b7aa5fd2df607b7035227553c9d"; }
    { name = "ivtv"; sha256 = "7bf30e142679d53ad376002f29026bbe28de51e1cb71bcc3ec5c5f5f119a7118"; }
    { name = "iwlwifi"; sha256 = "46ce0915583674ec10bfde3840b66ff450237edf604804ff51b9872fe767c1bb"; }
    { name = "libertas"; sha256 = "c5d370d244f1c3a42f0a0280ed0cab067dbf36fa2926d387c9d10cf4ccd1b000"; }
    { name = "linux"; sha256 = "e19bedc2cacf2cd7a1fc38e25820effe9e58fdc56608e9f7c320c85b80cba6ea"; }
    { name = "myricom"; sha256 = "038bd618c00e852206a8a1443ba47ea644c04052bd8f10af9392c716ebf16b3c"; }
    { name = "netxen"; sha256 = "29e3c1707dab6439f391318a223e5d4b6508d493c8d8bad799aef4f35b4704e7"; }
    { name = "qlogic"; sha256 = "cc43c6016f2b7661d39e1d678ac0e8ca70081be8a0c76c2ec4d2e71493afa7d8"; }
    { name = "ralink"; sha256 = "4db8dc6b98821c59f008c8bf7464317443b031cebf6d7e56c06f0824e69e3922"; }
    { name = "realtek"; sha256 = "c39e65e5a589325ceb365d11b9ea10b0244134b7e5b3b05fd91fe6ad66b2f093"; }
  ];

  fetchPackage =
    { name, sha256 }: fetchurl {
      url = "mirror://debian/pool/non-free/f/firmware-nonfree/firmware-${name}_${version}_all.deb";
      inherit sha256;
    };

  srcs = map fetchPackage packages;

in stdenv.mkDerivation {
  name = "firmware-linux-nonfree-${version}";
  inherit srcs;

  unpackPhase = ''
    ensureDir "./firmware"
  '';

  buildPhase = ''
    for src in $srcs; do
      dpkg-deb -W $src
      dpkg-deb -x $src .
    done
  '';

  buildInputs = [ dpkg ];

  installPhase = ''
    mkdir -p "$out/"
    cp -r lib/firmware/* "$out/"
  '';

  meta = {
    description = "Binary firmware collection packaged by Debian";
    homepage = "http://packages.debian.org/sid/firmware-linux-nonfree";
    license = "unfree-redistributable-firmware";
    priority = 10; # low priority so that other packages can override this big package
  };
}

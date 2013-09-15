# The firmware bundle as packaged by Debian. This should be "all" firmware that is not shipped
# as part of the kernel itself.
# You can either install the complete bundle, or write a separate package for individual
# devices that copies the firmware from this package.

{ stdenv, fetchurl, dpkg }:

let
  version = "0.40";

  packages = [
    { name = "adi"; sha256 = "0wwks9ff4n772435s57z1fjrffi4xl9nxnfn3v7xfcwdjb395d88"; }
    { name = "atheros"; sha256 = "1gj7hfnyclzgyq06scynaclnfajhs6lw5i51j1w1hikv4yh20djz"; }
    { name = "bnx2"; sha256 = "15qjj0sfjin5cbkpby29r5czn11xyiyyc4fmhwlqvgfgrnbp0aqk"; }
    { name = "bnx2x"; sha256 = "08nvbln94ff47b2q0avxj1aa2wx4qih8sq8knbq54lp46kjf3k0h"; }
    { name = "brcm80211"; sha256 = "1ndsw3s6xkr1n39nf9ig1xhnaglx5qvvvm8rh6ah41v644lzha79"; }
    { name = "intelwimax"; sha256 = "1qwxmykh90v92asn4ivq0fak761hs7hd2zmz1dpkjidwsycrfyqn"; }
    { name = "ipw2x00"; sha256 = "0a2nb17b5n3k1b6y4dbi5i8k1fm19ba2abq2jh2hjjmyyl3y388m"; }
    { name = "ivtv"; sha256 = "1239gsjq16f4kd1yn77iq3ar8ndx3pzd16kpqafr1h2y0zwh452r"; }
    { name = "iwlwifi"; sha256 = "03kmh5szd02pkbm1nlyz99fr2njhg88wiv73f1fz485m9rvgga43"; }
    { name = "libertas"; sha256 = "0qjziwmwqbp83hxrjw7x3ralxg4ib9y23bcbn1g8yb5b6m84ca6b"; }
    { name = "linux"; sha256 = "0ypidsrrfx4kvbfisdpgx2fzbil7g2jixgqhnv960iy5l348amrl"; }
    { name = "linux-nonfree"; sha256 = "0p9ql3cdxljflh48r6z40kpyisbzp3s3g1qjb9f64n6cppllwjfr"; }
    { name = "myricom"; sha256 = "12spfaq7z2bb93cy15zldlic1wx2v6h9sn7ny09nkzy4m26zds4q"; }
    { name = "netxen"; sha256 = "03gmda16bdqw8a4x8x11ph41ksjh48hxydv0f0z3gi3czgbh7sn3"; }
    { name = "qlogic"; sha256 = "1ah8rrwzi44p1l4q8qkql18djmn5kihsiinpy204xklm1csf3vs1"; }
    { name = "ralink"; sha256 = "005549jk0wnyfnb247awv2wncsx5is05m1hdwcd33iq0dlbmm39b"; }
    { name = "realtek"; sha256 = "1ai1klzrql8qxmb7945xiqlkfkyz8admrpb10b3r4ixvclkrvfi2"; }
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
    mkdir -p ./firmware
  '';

  buildPhase = ''
    for src in $srcs; do
      dpkg-deb -W $src
      dpkg-deb -x $src .
    done
  '';

  buildInputs = [ dpkg ];

  installPhase = ''
    mkdir -p $out/share $out/lib/firmware
    cp -r lib/firmware/* "$out/lib/firmware/"
    cp -r usr/share/doc $out/share/
    find $out/share -name changelog.gz | xargs rm
  '';

  meta = {
    description = "Binary firmware collection packaged by Debian";
    homepage = http://packages.debian.org/sid/firmware-linux-nonfree;
    license = stdenv.lib.licenses.unfreeRedistributableFirmware;
    platforms = stdenv.lib.platforms.linux;
  };
}

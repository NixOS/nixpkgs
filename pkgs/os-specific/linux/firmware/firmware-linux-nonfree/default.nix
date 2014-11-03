# The firmware bundle as packaged by Debian. This should be "all" firmware that is not shipped
# as part of the kernel itself.
# You can either install the complete bundle, or write a separate package for individual
# devices that copies the firmware from this package.

{ stdenv, fetchurl, dpkg }:

let
  version = "0.43";

  packages = [
    { name = "adi"; sha256 = "13cwnbispivpd73k928l1i818ylhpahp6xh7d6pw59sswrsx6inw"; }
    { name = "atheros"; sha256 = "0sw9d52k3ynx1cxg7cq49pmm8y6vlqyhb9843hbyf6nbmjqj72bx"; }
    { name = "bnx2"; sha256 = "1r8scys27qj5shdbgl8ag9vi4hiidx4bp8yw4n4dcp288d9x7bbh"; }
    { name = "bnx2x"; sha256 = "03jx4vnn8irlwswydf4h3ya1kf064jkaj67jry2hr6qwpd4l8pgq"; }
    { name = "brcm80211"; sha256 = "01mkmjkg16kdd26pwlg4a1s1717fh0j602mwqhwh46k8zakg2lkh"; }
    { name = "intelwimax"; sha256 = "1avls6sx0pbsffrcs267r2r2rqlx2xrv8j9znc7ix1bi8g4fx91v"; }
    { name = "ipw2x00"; sha256 = "19zqc30hsz7snw020izm81qbap3xsygggnmbspxndw7jihz0amjs"; }
    { name = "ivtv"; sha256 = "1f2004lpw5nr9rxj3cl4ba0jdm51wkvsrbiy4drakawpjwh5y4qw"; }
    { name = "iwlwifi"; sha256 = "1538r751mx8nhg3xibnnrhnflvf3kl5y9rnm7rpl4wyrfgx61amd"; }
    { name = "libertas"; sha256 = "0svkqlsiqgmh970r38nh0c1pjx41zdfql2k2k5djw99fscjklacd"; }
    { name = "linux"; sha256 = "0j62v6vbh2287j3x5c9i0xspmhyh5k1z8dyajgix7k37xi4jvpy2"; }
    { name = "linux-nonfree"; sha256 = "1f5x72rzicivwm0sn9l6wjkx7z9a0b8n6c9m60xrqg36ly7mizzp"; }
    { name = "myricom"; sha256 = "17cdl885jlnja5m60l35xr2f84hv8z4cvg3d25vpp171s1vf1ks1"; }
    { name = "netxen"; sha256 = "122nava9ld1v8gcnqbdpx0kffv0rxm9glp4xg09ssvldy4myfgl7"; }
    { name = "qlogic"; sha256 = "02pgmprz1qwij7lw1lgmb8clgxj8v3mx0fyy1l4z7bffnpvip863"; }
    { name = "ralink"; sha256 = "0yw9gf9gm3jxmsndr8kcsf6829smm88kshfb4c8jn0n6f4yy9l7x"; }
    { name = "realtek"; sha256 = "0gay9x47pimdqj665sr1416l3bdyca9grsqpj0s9n6k1lmywrqx1"; }
    { name = "ti-connectivity"; sha256 = "1m6yk0827991hs46l8pp8iiwh1ms0rwlmwn64k2wr725k5yzg29b"; }
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

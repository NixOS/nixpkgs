# The firmware bundle as packaged by Debian. This should be "all" firmware that is not shipped
# as part of the kernel itself.
# You can either install the complete bundle, or write a separate package for individual
# devices that copies the firmware from this package.

{ stdenv, fetchurl, buildEnv, dpkg }:

let
  version = "0.38";

  packages = [
    { name = "ipw2x00"; sha256 = "1bdial90l1928sfw3j1fz5cbsav8lz9riv38d02bawq9rzvb5dx0"; }
    { name = "bnx2x"; sha256 = "1a8jwwa6yldj2pgnsghhdkb8c0s64wzg0vx8y3cj11lhbh2ag2i7"; }
    { name = "linux-nonfree"; sha256 = "0dr91sswvkh0lk80d6byxjavkqcsickqf8xqhdd82j9mm7bjg7ld"; }
    { name = "intelwimax"; sha256 = "1156c7a301lk2a4d699dmvwzh4k3rfbxl4fx4raafy8a15lbw8mn"; }
    { name = "iwlwifi"; sha256 = "1q6gl2x4lj83hn8acamlj7s4j8vjd02798a6i52f4r7x0042f58a"; }
    { name = "bnx2"; sha256 = "0rpsrmywh97azqmsx4qgxyqcvdn5414m9cg92pd7h9xfmm38nscd"; }
    { name = "qlogic"; sha256 = "02438jzzybicg0bvl2jc3qnn0r4f1pfpyxbf70cmas9sfxb7s3az"; }
    { name = "libertas"; sha256 = "0b8n1igx6hpxlav73xs8r6qs2v95r9hx4lqqzy0h5iy7md9xs9y4"; }
    { name = "ivtv"; sha256 = "1vb1jbxdggy2vj1xlncfzyynpra1y62bb3n30ybafjnx88p6f2hi"; }
    { name = "linux"; sha256 = "0ijd49rf7cg0lniqm9sqz2g4i9jmc9vyz6wv9jlwrvnbl8hhy5vy"; }
    { name = "netxen"; sha256 = "19d5d3ibhb22p4mh22lnl441v8xyb1pyfi5h36vsjpccivzkgd2f"; }
    { name = "myricom"; sha256 = "0vq2rvc71j96q684r1bh0528xnrxa1xzh2sdhqfrgip9ihdsp3ml"; }
    { name = "atheros"; sha256 = "04zy5j48b83garmnfxiqgmm3yv1pfpbldxp69zm24pfxcwyvx3hm"; }
    { name = "brcm80211"; sha256 = "0kgw6q18i46npmjxv4ymww8dr7nn140xrrqjrbnfhzgha3y2yylg"; }
    { name = "ralink"; sha256 = "0kbzbc4vpn6mvvkm4q7mfqg0bsj6akfpypxk98s7kbidmyj577q2"; }
    { name = "realtek"; sha256 = "1ac9vlrzprp0j2mdmp1zi47wg2i76vmi288sm3vwlvp4s6ymm077"; }
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

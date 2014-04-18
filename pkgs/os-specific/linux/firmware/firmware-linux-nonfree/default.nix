# The firmware bundle as packaged by Debian. This should be "all" firmware that is not shipped
# as part of the kernel itself.
# You can either install the complete bundle, or write a separate package for individual
# devices that copies the firmware from this package.

{ stdenv, fetchurl, dpkg }:

let
  version = "0.41";

  packages = [
    { name = "adi"; sha256 = "19dm96djp34g6l84g9shwbmqbmfd15c24frcy1zh5nz8x12phgm4"; }
    { name = "atheros"; sha256 = "0vrdyxiq7nx89h6ykdrs8s3l9frn3hmcfb9vsz68i12975y8ib5n"; }
    { name = "bnx2"; sha256 = "12l3l54q69n1ky8lp7bmzscfqysabjrgmswwj57ryc6l82s7081y"; }
    { name = "bnx2x"; sha256 = "10m9p479dq2ylpj5mw6d5vyfh9hybmh5xgs5sxma065v7r3c3v31"; }
    { name = "brcm80211"; sha256 = "0l2lg5pshb1kb829hfq9w791scwa8biikrfzsx9wvlvkyxfdh187"; }
    { name = "intelwimax"; sha256 = "13jqm8ik0mm8vnsskbbp63idpjqazzp2x4gaq7786jg5yj3zh1cf"; }
    { name = "ipw2x00"; sha256 = "1hvxrzqbc75phxdbmqfh7ky36m0qna2pncwxpfdircy9i6fx7ipy"; }
    { name = "ivtv"; sha256 = "0ckw1ynzfqnkwlmwpzfbdfx4s6bsl4nwp097g8khaavqxk94n88v"; }
    { name = "iwlwifi"; sha256 = "1djazi2qsi5z6q0izirprxgfpg8vh55skab2nijyfl66drlcha72"; }
    { name = "libertas"; sha256 = "1yj9dd9pwd98gknx5mvblfcbr6k347xzi8l6bk0pr4570j8ss8y3"; }
    { name = "linux"; sha256 = "0vc4cbrq73y5hibx5k3gbfqaqxvaa3g8rv9kzwks2zl3hdxm6xaq"; }
    { name = "linux-nonfree"; sha256 = "05vv8yq7kix5cw9s4agz4vgya6i3ff88jp3rxln1ssznhvzrjzx9"; }
    { name = "myricom"; sha256 = "1idfvdfw7z4jbbjyq40hd2bpllvw7jz0ah7k3iwljxp8l2lf2nmf"; }
    { name = "netxen"; sha256 = "0fdgllv8i7j9qbk5hi14zvw6fcn4nd1isr1486d8fv7nf2bf1mxx"; }
    { name = "qlogic"; sha256 = "12w1qnqhs24am2psdfmv0ligczzxh9crllmp7r4y3vqghyvwax7i"; }
    { name = "ralink"; sha256 = "1ryplg9shi7nam79zd86z7a0qzp0f9m7q89nq989z57qiysbrra4"; }
    { name = "realtek"; sha256 = "1l867724qrw7nwksdv4k0hkz7nrjjs9vq2s3937wyaa0r2r66mg6"; }
    { name = "ti-connectivity"; sha256 = "00cl9gyxa7795a57zwcvl26kxfl4qzppi4z8ksg5friv3db8sm1p"; }
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

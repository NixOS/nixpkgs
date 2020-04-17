# Based on: https://github.com/tokiclover/bar-overlay/tree/ddd118f571a63160c0517e7108aefcbba79d969e/net-print/cnijfilter

{
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libtool,
  pkg-config,
  glib,
  gtk2,
  popt,
  libxml2
}:
let
  mkDriverPackage = import ./generic.nix
    { inherit stdenv autoconf automake libtool glib; };
in {
  cnijfilter_3_80 = mkDriverPackage [
    { id = "401"; model = "mp230"; }
    { id = "402"; model = "mg2200"; }
    { id = "403"; model = "e510"; }
    { id = "404"; model = "mg3200"; }
    { id = "405"; model = "mg4200"; }
    { id = "406"; model = "ip7200"; }
    { id = "407"; model = "mg5400"; }
    { id = "408"; model = "mg6300"; }
  ] {
    version = "3.80";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/3/0100004693/01/cnijfilter-source-3.80-1.tar.gz";
      sha256 = "1ac6n2lm6bw2xq13zpbg33n8npj512m33z78br31j7qr327l0vcb";
    };
    patches = [
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.20-4-libpng15.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-3.80-5-abi_x86_32.patch
      ./patches/cnijfilter-3.80-1-cups-1.6.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.80-6-cups-1.6.patch
      ./patches/cnijfilter-3.70-6-headers.patch
      ./patches/cnijfilter-3.70-6-cups-1.6.patch
    ];
    buildInputs = [ gtk2 pkg-config popt libxml2 ];
  };
}

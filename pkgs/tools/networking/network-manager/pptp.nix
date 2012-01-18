{ stdenv, fetchurl, networkmanager, pptp, ppp, intltool, pkgconfig }:

let
  pn = "networkmanager-pptp";
  gnome_pn = "NetworkManager-pptp";
  major = "0.9";
  version = "0.9.0";
  src = fetchurl {
    url = "mirror://gnome/sources/${gnome_pn}/${major}/${gnome_pn}-${version}.tar.xz";
    sha256 = "1mfbavcnc871sxkisisnic472am0qmkgw7caj0b86sdir2q83nlp";
  };
in

stdenv.mkDerivation rec {
  name = "${pn}-${version}";

  inherit src;

  buildInputs = [ networkmanager pptp ppp ];

  buildNativeInputs = [ intltool pkgconfig ];

  configureFlags = "--without-gnome --disable-nls";
}

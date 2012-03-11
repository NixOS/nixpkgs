{ stdenv, fetchurl, networkmanager, pptp, ppp, intltool, pkgconfig
, withGnome ? false, gtk, libgnome_keyring }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-pptp";
  version = "0.9.2.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/0.9/${pname}-${version}.tar.xz";
    sha256 = "1fj2v8pjc17m9calckgc2jm8wbimwga8if4r21walf9xysvhsd1b";
  };

  buildInputs = [ networkmanager pptp ppp ]
    ++ stdenv.lib.optionals withGnome [ gtk libgnome_keyring ];

  buildNativeInputs = [ intltool pkgconfig ];

  configureFlags =
    if withGnome then "--with-gnome --with-gtkver=2" else "--without-gnome";

  meta = {
    description = "PPtP plugin for NetworkManager";
    inherit (networkmanager.meta) maitainers platforms;
  };
}

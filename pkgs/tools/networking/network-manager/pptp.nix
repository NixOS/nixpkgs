{ stdenv, fetchurl, networkmanager, pptp, ppp, intltool, pkgconfig, substituteAll
, withGnome ? false, gtk, libgnome_keyring }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-pptp";
  version = "0.9.4.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/0.9/${pname}-${version}.tar.xz";
    sha256 = "0p93in5dn8m6dp9qs2ppfmazwqlklp5hwp9pjqr7jwvjbac75dvg";
  };

  buildInputs = [ networkmanager pptp ppp ]
    ++ stdenv.lib.optionals withGnome [ gtk libgnome_keyring ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags =
    if withGnome then "--with-gnome --with-gtkver=2" else "--without-gnome";

  patches =
    [ ( substituteAll {
        src = ./pptp-purity.patch;
        inherit ppp pptp;
      })
    ];

  meta = {
    description = "PPtP plugin for NetworkManager";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

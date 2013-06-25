{ stdenv, fetchurl, networkmanager, pptp, ppp, intltool, pkgconfig, substituteAll
, withGnome ? false, gtk, libgnome_keyring }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-pptp";
  version = "0.9.8.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/0.9/${pname}-${version}.tar.xz";
    sha256 = "1j4wczf0lv2c58pgdfxg2qsva5v0r1w99x6l1p78m56qc8a9il1l";
  };

  buildInputs = [ networkmanager pptp ppp ]
    ++ stdenv.lib.optionals withGnome [ gtk libgnome_keyring ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags =
    if withGnome then "--with-gnome --with-gtkver=2" else "--without-gnome";

  postConfigure = "sed 's/-Werror//g' -i Makefile */Makefile";

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

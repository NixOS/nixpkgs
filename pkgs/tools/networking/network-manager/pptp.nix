{ stdenv, fetchurl, networkmanager, pptp, ppp, intltool, pkgconfig, substituteAll
, withGnome ? true, gnome3, networkmanagerapplet, libsecret }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-pptp";
  version = networkmanager.version;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/0.9/${pname}-${version}.tar.xz";
    sha256 = "564b16c9b2821a1d2ede06f56f4db5cb0d62ccb35f87c92ad6c636ed48e0af58";
  };

  buildInputs = [ networkmanager pptp ppp libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome_keyring networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags =
    if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome";

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

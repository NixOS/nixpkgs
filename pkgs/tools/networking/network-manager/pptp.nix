{ stdenv, fetchurl, networkmanager, pptp, ppp, intltool, pkgconfig
, libsecret, withGnome ? true, gnome3 }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-pptp";
  version = networkmanager.version;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/1.0/${pname}-${version}.tar.xz";
    sha256 = "1gn1f8r32wznk4rsn2lg2slw1ccli00svz0fi4bx0qiylimlbyln";
  };

  buildInputs = [ networkmanager pptp ppp libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome_keyring
                                        gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  postPatch = ''
    sed -i -e 's%"\(/usr/sbin\|/usr/pkg/sbin\|/usr/local/sbin\)/[^"]*",%%g' ./src/nm-pptp-service.c

    substituteInPlace ./src/nm-pptp-service.c \
      --replace /sbin/pptp ${pptp}/bin/pptp \
      --replace /sbin/pppd ${ppp}/bin/pppd
  '';

  configureFlags =
    if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome";

  postConfigure = "sed 's/-Werror//g' -i Makefile */Makefile";

  meta = {
    description = "PPtP plugin for NetworkManager";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

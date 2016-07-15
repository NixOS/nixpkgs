{ stdenv, fetchurl, networkmanager, pptp, ppp, intltool, pkgconfig
, libsecret, withGnome ? true, gnome3 }:

stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname   = "NetworkManager-pptp";
  version = networkmanager.version;

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${networkmanager.major}/${pname}-${version}.tar.xz";
    sha256 = "a72cb88ecc0a9edec836e8042c592d68b8b290c0d78082e6b25cf08b46c6be5d";
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

  meta = {
    description = "PPtP plugin for NetworkManager";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

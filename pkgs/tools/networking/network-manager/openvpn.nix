{ stdenv, fetchurl, openvpn, intltool, pkgconfig, networkmanager
, withGnome ? true, gtk2, libgnome_keyring }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-openvpn";
  version = "0.9.4.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/0.9/${pname}-${version}.tar.xz";
    sha256 = "1q436v2vlyxjj2b89jr3zny640xdjpslbrjb39ks1lrc1jqp0j6h";
  };

  buildInputs = [ openvpn networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gtk2 libgnome_keyring ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "${if withGnome then "--with-gnome --with-gtkver=2" else "--without-gnome"}"
  ];

  preBuild = ''
     sed -i 's/-Wstrict-prototypes//' auth-dialog/Makefile
     sed -i 's/-Werror//' auth-dialog/Makefile
     sed -i 's/-Wstrict-prototypes//' properties/Makefile
     sed -i 's/-Werror//' properties/Makefile
  '';

  postInstall = ''
   # ln -s $out/NetworkManager/VPN /etc/NetworkManager/VPN
  '';

  meta = {
    description = "TODO";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

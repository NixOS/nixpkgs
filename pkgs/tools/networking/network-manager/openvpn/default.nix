{ stdenv, fetchurl, substituteAll, openvpn, intltool, libxml2, pkgconfig, networkmanager, libsecret
, withGnome ? true, gnome3, kmod }:

let
  pname = "NetworkManager-openvpn";
  version = "1.8.4";
in stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0gyrv46h9k17qym48qacq4zpxbap6hi17shn921824zm98m2bdvr";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openvpn;
    })
  ];

  buildInputs = [ openvpn networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk libsecret gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig libxml2 ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-openvpn";
    };
  };

  meta = with stdenv.lib; {
    description = "NetworkManager's OpenVPN plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}

{ stdenv, fetchurl, substituteAll, openvpn, intltool, libxml2, pkgconfig, file, networkmanager, libsecret
, gtk3, withGnome ? true, gnome3, kmod, libnma }:

let
  pname = "NetworkManager-openvpn";
  version = "1.8.12";
in stdenv.mkDerivation {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "062kh4zj7jfbwy4zzcwpq2m457bzbpm3l18s0ysnw3mgia3siz8f";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openvpn;
    })
  ];

  buildInputs = [ openvpn networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gtk3 libsecret libnma ];

  nativeBuildInputs = [ intltool pkgconfig file libxml2 ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
    "--enable-absolute-paths"
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

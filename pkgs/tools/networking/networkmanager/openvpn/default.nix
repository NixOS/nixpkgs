{ lib, stdenv, fetchurl, substituteAll, openvpn, intltool, libxml2, pkg-config, file, networkmanager, libsecret
, gtk3, withGnome ? true, gnome, kmod, libnma }:

let
  pname = "NetworkManager-openvpn";
  version = "1.8.12";
in stdenv.mkDerivation {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "062kh4zj7jfbwy4zzcwpq2m457bzbpm3l18s0ysnw3mgia3siz8f";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openvpn;
    })
  ];

  buildInputs = [ openvpn networkmanager ]
    ++ lib.optionals withGnome [ gtk3 libsecret libnma ];

  nativeBuildInputs = [ intltool pkg-config file libxml2 ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-openvpn";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "NetworkManager's OpenVPN plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}

{ stdenv, fetchurl, substituteAll, openvpn, intltool, libxml2, pkgconfig, networkmanager, libsecret
, withGnome ? true, gnome3, procps, kmod }:

let
  pname   = "NetworkManager-openvpn";
  version = "1.8.2";
in stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0p9pjk81h1j1dk9jkkvvk17cq21wyq5kfa4j49fmx9b9yg8syqc8";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openvpn;
    })
  ];

  buildInputs = [ openvpn networkmanager libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome-keyring
                                        gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig libxml2 ];

  configureFlags = [
    "${if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome"}"
    "--disable-static"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-openvpn";
    };
  };

  meta = {
    description = "NetworkManager's OpenVPN plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

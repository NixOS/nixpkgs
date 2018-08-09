{ stdenv, fetchurl, substituteAll, openconnect, intltool, pkgconfig, networkmanager, libsecret
, withGnome ? true, gnome3, kmod }:

let
  pname   = "NetworkManager-openconnect";
  version = "1.2.4";
in stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "15j98wwspv6mcmy91w30as5qc1bzsnhlk060xhjy4qrvd37y0xx1";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openconnect;
    })
  ];

  buildInputs = [ openconnect networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk libsecret ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-openconnect";
    };
  };

  meta = with stdenv.lib; {
    description = "NetworkManager's OpenConnect plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}

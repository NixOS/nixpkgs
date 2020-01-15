{ stdenv, fetchurl, substituteAll, vpnc, intltool, pkgconfig, networkmanager, libsecret
, gtk3, withGnome ? true, gnome3, kmod, file }:
let
  pname = "NetworkManager-vpnc";
  version = "1.2.6";
in stdenv.mkDerivation {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1js5lwcsqws4klgypfxl4ikmakv7v7xgddij1fj6b0y0qicx0kyy";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit vpnc kmod;
    })
  ];

  buildInputs = [ vpnc networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gtk3 libsecret gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig file ];

  configureFlags = [
    "--without-libnm-glib"
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-vpnc";
    };
  };

  meta = with stdenv.lib; {
    description = "NetworkManager's VPNC plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}

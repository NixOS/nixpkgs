{ lib, stdenv, fetchurl, substituteAll, vpnc, intltool, pkg-config, networkmanager, libsecret
, gtk3, withGnome ? true, gnome, glib, kmod, file, fetchpatch, libnma }:
let
  pname = "NetworkManager-vpnc";
  version = "1.2.6";
in stdenv.mkDerivation {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1js5lwcsqws4klgypfxl4ikmakv7v7xgddij1fj6b0y0qicx0kyy";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit vpnc kmod;
    })
    # Don't use etc/dbus-1/system.d
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/NetworkManager-vpnc/merge_requests/5.patch";
      sha256 = "0z0x5vqmrsap3ynamhya7gh6c6k5grhj2vqpy76alnv9xns8dzi6";
    })
  ];

  buildInputs = [ vpnc networkmanager glib ]
    ++ lib.optionals withGnome [ gtk3 libsecret libnma ];

  nativeBuildInputs = [ intltool pkg-config file ];

  configureFlags = [
    "--without-libnm-glib"
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-vpnc";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "NetworkManager's VPNC plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}

{ stdenv
, lib
, fetchurl
, file
, glib
, gnome
, gtk3
, gtk4
, gettext
, libnma
, libnma-gtk4
, libsecret
, networkmanager
, pkg-config
, ppp
, sstp
, withGnome ? true
}:

stdenv.mkDerivation rec {
  pname = "NetworkManager-sstp";
  version = "1.3.1";
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "fQMSawiaCk/2ZeMHVVcM7PaFEKbP7bUS9Lh+htrGHX0=";
  };

  nativeBuildInputs = [
    file
    gettext
    pkg-config
  ];

  buildInputs = [
    sstp
    networkmanager
    glib
    ppp
  ] ++ lib.optionals withGnome [
    gtk3
    gtk4
    libsecret
    libnma
    libnma-gtk4
  ];

  postPatch = ''
    sed -i 's#/sbin/pppd#${ppp}/bin/pppd#' src/nm-sstp-service.c
    sed -i 's#/sbin/sstpc#${sstp}/bin/sstpc#' src/nm-sstp-service.c
  '';

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--with-gtk4=${if withGnome then "yes" else "no"}"
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-sstp";
    };
    networkManagerPlugin = "VPN/nm-sstp-service.name";
  };

  meta = with lib; {
    description = "NetworkManager's sstp plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}

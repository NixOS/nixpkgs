{ stdenv
, lib
, fetchFromGitLab
, autoreconfHook
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
  version = "unstable-2023-03-09";
  name = "${pname}${lib.optionalString withGnome "-gnome"}-${version}";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "network-manager-sstp";
    rev = "852db07dc7d19c37e398d831410bd94c8659a210";
    hash = "sha256-DxgcuTza2G5a7F2mBtDaEuynu7F1Ex9pnAESAjyoRq8=";
  };

  nativeBuildInputs = [
    autoreconfHook
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
    "--with-pppd-plugin-dir=$(out)/lib/pppd/2.5.0"
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

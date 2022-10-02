{ stdenv
, lib
, substituteAll
, fetchFromGitHub
, autoreconfHook
, pkg-config
, gtk3
, gtk4
, networkmanager
, ppp
, xl2tpd
, strongswan
, libsecret
, withGnome ? true
, libnma
, libnma-gtk4
, glib
, openssl
, nss
}:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-l2tp";
  version = "1.20.4";

  src = fetchFromGitHub {
    owner = "nm-l2tp";
    repo = "network-manager-l2tp";
    rev = version;
    sha256 = "VoqPjMQILBYemRE5VD/XwhWi9zL9QxxHZJ2JKtGglFo=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit strongswan xl2tpd;
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    networkmanager
    ppp
    glib
    openssl
    nss
  ] ++ lib.optionals withGnome [
    gtk3
    gtk4
    libsecret
    libnma
    libnma-gtk4
  ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--with-gtk4=${if withGnome then "yes" else "no"}"
    "--localstatedir=/var"
    "--enable-absolute-paths"
  ];

  enableParallelBuilding = true;

  passthru = {
    networkManagerPlugin = "VPN/nm-l2tp-service.name";
  };

  meta = with lib; {
    description = "L2TP plugin for NetworkManager";
    inherit (networkmanager.meta) platforms;
    homepage = "https://github.com/nm-l2tp/network-manager-l2tp";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar obadz ];
  };
}

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
  name = "${pname}${lib.optionalString withGnome "-gnome"}-${version}";
  pname = "NetworkManager-l2tp";
  version = "1.20.10";

  src = fetchFromGitHub {
    owner = "nm-l2tp";
    repo = "network-manager-l2tp";
    rev = version;
    hash = "sha256-EfWvh4uSzWFadZAHTqsKa3un2FQ6WUbHLoHo9gSS7bE=";
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

{ lib, stdenv, substituteAll, fetchFromGitHub, autoreconfHook, libtool, intltool, pkg-config
, file, findutils
, gtk3, networkmanager, ppp, xl2tpd, strongswan, libsecret
, withGnome ? true, libnma, glib }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-l2tp";
  version = "1.2.12";

  src = fetchFromGitHub {
    owner = "nm-l2tp";
    repo = "network-manager-l2tp";
    rev = version;
    sha256 = "0cq07kvlm98s8a7l4a3zmqnif8x3307kv7n645zx3f1r7x72b8m4";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit strongswan xl2tpd;
    })
  ];

  buildInputs = [ networkmanager ppp glib ]
    ++ lib.optionals withGnome [ gtk3 libsecret libnma ];

  nativeBuildInputs = [ autoreconfHook libtool intltool pkg-config file findutils ];

  preConfigure = ''
    intltoolize -f
  '';

  configureFlags = [
    "--without-libnm-glib"
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--localstatedir=/var"
    "--sysconfdir=$(out)/etc"
    "--enable-absolute-paths"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "L2TP plugin for NetworkManager";
    inherit (networkmanager.meta) platforms;
    homepage = "https://github.com/nm-l2tp/network-manager-l2tp";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar obadz ];
  };
}

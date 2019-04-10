{ stdenv, substituteAll, fetchFromGitHub, autoreconfHook, libtool, intltool, pkgconfig
, file, findutils
, gtk3, networkmanager, ppp, xl2tpd, strongswan, libsecret, openssl, nss
, withGnome ? true, gnome3, networkmanagerapplet }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-l2tp";
  version = "1.7.0-dev";

  src = fetchFromGitHub {
    owner = "nm-l2tp";
    repo = "network-manager-l2tp";
    rev = "8a72e8f57f61083a8e0663103bb8c1394d93439a";
    sha256 = "1d2q041n9sbcnnvkdwngkr0mwj99qdjarn14n3zh6i4jzpmmqy5a";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit strongswan xl2tpd;
    })
  ];

  buildInputs = [ networkmanager ppp openssl nss ]
    ++ stdenv.lib.optionals withGnome [ gtk3 libsecret networkmanagerapplet ];

  nativeBuildInputs = [ autoreconfHook libtool intltool pkgconfig file findutils ];

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

  meta = with stdenv.lib; {
    description = "L2TP plugin for NetworkManager";
    inherit (networkmanager.meta) platforms;
    homepage = https://github.com/nm-l2tp/network-manager-l2tp;
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar obadz ];
  };
}

{ stdenv, fetchFromGitHub, autoreconfHook, libtool, intltool, pkgconfig
, networkmanager, ppp, xl2tpd, strongswan, libsecret
, withGnome ? true, gnome3, networkmanagerapplet }:

stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname   = "NetworkManager-l2tp";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner  = "nm-l2tp";
    repo   = "network-manager-l2tp";
    rev    = "${version}";
    sha256 = "ca39414a0282a2f3457df952bc2a5b386c21b4bd21582bbc6c48dadd5fb5dfff";
  };

  buildInputs = [ networkmanager ppp libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome_keyring networkmanagerapplet ];

  nativeBuildInputs = [ autoreconfHook libtool intltool pkgconfig ];

  postPatch = ''
    sed -i -e 's%"\(/usr/sbin\|/usr/pkg/sbin\|/usr/local/sbin\)/[^"]*",%%g' ./src/nm-l2tp-service.c

    substituteInPlace ./src/nm-l2tp-service.c \
      --replace /sbin/ipsec  ${strongswan}/bin/ipsec \
      --replace /sbin/xl2tpd ${xl2tpd}/bin/xl2tpd
  '';

  preConfigure = ''
    intltoolize -f
  '';

  configureFlags =
    if withGnome then "--with-gnome" else "--without-gnome";

  meta = with stdenv.lib; {
    description = "L2TP plugin for NetworkManager";
    inherit (networkmanager.meta) platforms;
    homepage = https://github.com/seriyps/NetworkManager-l2tp;
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar obadz ];
  };
}

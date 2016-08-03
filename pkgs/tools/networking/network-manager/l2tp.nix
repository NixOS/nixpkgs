{ stdenv, fetchFromGitHub, automake, autoconf, libtool, intltool, pkgconfig
, networkmanager, ppp, xl2tpd, strongswan, libsecret
, withGnome ? true, gnome3, networkmanagerapplet }:

stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname   = "NetworkManager-l2tp";
  version = networkmanager.version;

  src = fetchFromGitHub {
    owner  = "nm-l2tp";
    repo   = "network-manager-l2tp";
    rev    = "c0cedda5e2a0ded695b497c361eaf577068520cb";
    sha256 = "01f39ghc37vw4n4i7whyikgqz8vzxf41q9fsv2gfw1g501cny1j2";
  };

  buildInputs = [ networkmanager ppp libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome_keyring networkmanagerapplet ];

  nativeBuildInputs = [ automake autoconf libtool intltool pkgconfig ];

  postPatch = ''
    sed -i -e 's%"\(/usr/sbin\|/usr/pkg/sbin\|/usr/local/sbin\)/[^"]*",%%g' ./src/nm-l2tp-service.c

    substituteInPlace ./src/nm-l2tp-service.c \
      --replace /sbin/ipsec  ${strongswan}/bin/ipsec \
      --replace /sbin/xl2tpd ${xl2tpd}/bin/xl2tpd
  '';

  preConfigure = "./autogen.sh";

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

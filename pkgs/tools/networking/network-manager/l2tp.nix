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
    sha256 = "110157dpamgr7r5kb8aidi0a2ap9z2m52bff94fb4nhxacz69yv8";
  };

  buildInputs = [ networkmanager ppp libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome-keyring networkmanagerapplet ];

  nativeBuildInputs = [ autoreconfHook libtool intltool pkgconfig ];

  postPatch = ''
    sed -i -e 's%"\(/usr/sbin\|/usr/pkg/sbin\|/usr/local/sbin\)/[^"]*",%%g' ./src/nm-l2tp-service.c

    substituteInPlace ./Makefile.am \
      --replace '$(sysconfdir)/dbus-1/system.d' "$out/etc/dbus-1/system.d"

    substituteInPlace ./src/nm-l2tp-service.c \
      --replace /sbin/ipsec  ${strongswan}/bin/ipsec \
      --replace /sbin/xl2tpd ${xl2tpd}/bin/xl2tpd
  '';

  preConfigure = ''
    intltoolize -f
  '';

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--localstatedir=/var"
    "--sysconfdir=$(out)/etc"
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

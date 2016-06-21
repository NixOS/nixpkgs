{ stdenv, fetchFromGitHub, automake, autoconf, libtool, intltool, pkgconfig
, networkmanager, ppp, xl2tpd, strongswan
, withGnome ? true, gnome3 }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-l2tp";
  version = "0.9.8.7";

  src = fetchFromGitHub {
    owner  = "seriyps";
    repo   = "NetworkManager-l2tp";
    rev    = version;
    sha256 = "07gl562p3f6l2wn64f3vvz1ygp3hsfhiwh4sn04c3fahfdys69zx";
  };

  buildInputs = [ networkmanager ppp ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome_keyring ];

  nativeBuildInputs = [ automake autoconf libtool intltool pkgconfig ];

  postPatch = ''
    sed -i -e 's%"\(/usr/sbin\|/usr/pkg/sbin\|/usr/local/sbin\)/[^"]*",%%g' ./src/nm-l2tp-service.c

    substituteInPlace ./src/nm-l2tp-service.c \
      --replace /sbin/ipsec  ${strongswan}/bin/ipsec \
      --replace /sbin/xl2tpd ${xl2tpd}/bin/xl2tpd

    # Workaround https://github.com/xelerance/xl2tpd/issues/108
    substituteInPlace ./src/nm-l2tp-service.c --replace 'write_config_option (pppopt_fd, "lock\n");' ""
  '';

  preConfigure = "./autogen.sh";

  configureFlags =
    if withGnome then "--with-gnome" else "--without-gnome";

  postConfigure = "sed 's/-Werror//g' -i Makefile */Makefile";

  meta = with stdenv.lib; {
    description = "L2TP plugin for NetworkManager";
    inherit (networkmanager.meta) platforms;
    homepage = https://github.com/seriyps/NetworkManager-l2tp;
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar obadz ];
  };
}

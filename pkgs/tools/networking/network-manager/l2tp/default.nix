{ stdenv, substituteAll, fetchFromGitHub, autoreconfHook, libtool, intltool, pkgconfig
, networkmanager, ppp, xl2tpd, strongswan, libsecret
, withGnome ? true, gnome3, networkmanagerapplet }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-l2tp";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "nm-l2tp";
    repo = "network-manager-l2tp";
    rev = "${version}";
    sha256 = "1vm004nj2n5abpywr7ji6r28scf7xs45zw4rqrm8jn7mysf96h0x";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit strongswan xl2tpd;
    })
  ];

  buildInputs = [ networkmanager ppp ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk libsecret networkmanagerapplet ];

  nativeBuildInputs = [ autoreconfHook libtool intltool pkgconfig ];

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

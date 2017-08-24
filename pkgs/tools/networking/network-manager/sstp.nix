{ stdenv, fetchFromGitHub, networkmanager, sstp-client, ppp, intltool
, pkgconfig, libsecret, withGnome ? true, gnome3 }:

stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname   = "NetworkManager-sstp";
  major   = "1.2";
  version = "${major}.2";

  src = fetchFromGitHub {
    owner  = "enaess";
    repo   = "network-manager-sstp";
    rev    = "${version}";
    sha256 = "4449b09c7debaf6b086ca020052b55beb86753ad6b22180db1b8dde824b7340d";
  };

  buildInputs = [ networkmanager sstp-client ppp libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome_keyring
                                        gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  postPatch = ''
    sed -i -e 's%"\(/usr/sbin\|/usr/pkg/sbin\|/usr/local/sbin\)/[^"]*",%%g' ./src/nm-sstp-service.c

    substituteInPlace ./src/nm-sstp-service.c \
      --replace /sbin/sstp-client ${sstp-client}/bin/sstp-client \
      --replace /sbin/pppd ${ppp}/bin/pppd
  '';

  configureFlags =
    if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome";

  meta = {
    description = "SSTP plugin for NetworkManager";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

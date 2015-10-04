{ stdenv, fetchgit, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl }:

stdenv.mkDerivation rec {
  name = "tinc-1.1pre-2015-09-25";

  src = fetchgit {
    url = "git://tinc-vpn.org/tinc";
    rev = "73068238436d8a22abb86e67b08f573b09fd04e1";
    sha256 = "1j8bvvzvciy21s24jdpi089svy7wipg9pm84s98xjlp2plchj5dj";
  };

  nativeBuildInputs = [ autoreconfHook texinfo ];
  buildInputs = [ ncurses readline zlib lzo openssl ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  meta = with stdenv.lib; {
    description = "VPN daemon with full mesh routing";
    longDescription = ''
      tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
      encryption to create a secure private network between hosts on the
      Internet.  It features full mesh routing, as well as encryption,
      authentication, compression and ethernet bridging.
    '';
    homepage="http://www.tinc-vpn.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}

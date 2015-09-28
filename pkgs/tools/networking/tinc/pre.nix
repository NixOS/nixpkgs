{ stdenv, fetchgit, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl }:

stdenv.mkDerivation rec {
  name = "tinc-1.1pre-2015-07-22";

  src = fetchgit {
    url = "git://tinc-vpn.org/tinc";
    rev = "56a8b90d863171d62e0a337b5635fbfc53a67fb0";
    sha256 = "081z4xs5l988g1s0yr7fvnysajd05bx6s54sh84jvq7ij8af71dm";
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

{ stdenv, fetchgit, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl }:

stdenv.mkDerivation rec {
  name = "tinc-1.1pre-2015-05-15";

  src = fetchgit {
    url = "git://tinc-vpn.org/tinc";
    rev = "613c121cdceec0199dc4d056857be021ed1d21de";
    sha256 = "1l99bvqmb35hwb63fcy9gbjxasxnrgqw3i9f14f26dq3sz2j035l";
  };

  buildInputs = [ autoreconfHook texinfo ncurses readline zlib lzo openssl ];

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

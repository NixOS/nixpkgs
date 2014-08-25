{ stdenv, fetchgit, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl }:

stdenv.mkDerivation rec {
  name = "tinc-1.1pre38d7e73";

  src = fetchgit {
    url = "git://tinc-vpn.org/tinc";
    rev = "38d7e730e619a8b86dfbf68d77773564595f12a1";
    sha256 = "0xac1jm6x9lkybd6sz8lfcdrb8h69kh1ckg35ag1rssr45hxikbz";
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

{ stdenv, fetchgit, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl }:

stdenv.mkDerivation rec {
  name = "tinc-1.1pre-2015-02-24";

  src = fetchgit {
    url = "git://tinc-vpn.org/tinc";
    rev = "4b2ddded2c8ae1a1a5930637552eeb48f30d6530";
    sha256 = "037yl4qvy053a7jsp9dhj9bak6knnqxx2wsqq282dv032584sh46";
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

{ stdenv, fetchgit, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl }:

stdenv.mkDerivation rec {
  version = "1.1pre78bf82c";
  name = "tinc-${version}";

  src = fetchgit {
    url = "git://tinc-vpn.org/tinc";
    rev = "78bf82cf332327889f0f61388b73053850d8e59b";
    sha256 = "0azjy78qrzpk16b5jm08kx01ln2j9q0q69g86ah60fms525w1xjk";
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

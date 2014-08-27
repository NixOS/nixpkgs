{ stdenv, fetchgit, libtool, lzo, openssl, zlib, ncurses, readline, autoconf, automake, gcc, gettext, texinfo}:

stdenv.mkDerivation rec {
  version = "1.1-git";
  name = "tinc-${version}";

  src = fetchgit {
    url = "https://github.com/gsliepen/tinc.git";
    rev = "ac11a79ba7d56e8c770b3dd4c503b9243c4ea4e3";
    sha256 = "28aa626feaa44fd0aec8b4a7d99288475e278730c92003553eb54f22bd5e228a";
  };

  buildInputs = [ ncurses zlib libtool lzo readline openssl autoconf automake gcc gettext texinfo];

  preConfigure = ''
    autoreconf -fsi
  '';

  configureFlags = ''
    --localstatedir=/var
    --sysconfdir=/etc
  '';

  meta = {
    description = "VPN daemon with full mesh routing";
    longDescription = ''
      tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
      encryption to create a secure private network between hosts on the
      Internet.  It features full mesh routing, as well as encryption,
      authentication, compression and ethernet bridging.
    '';
    homepage="http://www.tinc-vpn.org/";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}

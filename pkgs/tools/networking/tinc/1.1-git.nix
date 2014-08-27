{ stdenv, fetchgit, libtool, lzo, openssl, zlib, ncurses, readline, autoconf, automake, gcc, gettext, texinfo}:

stdenv.mkDerivation rec {
  version = "1.1-git";
  name = "tinc-${version}";

  src = fetchgit {
    url = "https://github.com/gsliepen/tinc.git";
    rev = "09e000ba54fd4a4ffe3e5c15ee7aeadac35d6996";
    sha256 = "7f56b7a026776966ca9e7ebabde3659168fde305ad3af5b8605adc4e066000f6";
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

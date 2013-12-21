{ stdenv, fetchgit, libtool, lzo, openssl, zlib, ncurses, readline, autoconf, automake, gcc, gettext, texinfo}:

stdenv.mkDerivation rec {
  version = "1.1-git";
  name = "tinc-${version}";

  src = fetchgit {
  	url = "https://github.com/gsliepen/tinc.git";
  	rev = "ef8efdfff1de2b18092f9d4f383e3f2898bf86cd";
  };

  buildInputs = [ ncurses zlib libtool lzo readline openssl autoconf automake gcc gettext texinfo];

  preConfigure = ''
    sed -i -e "s/AM_PATH_LIBGCRYPT/#AM_PATH_LIBGCRYPT/g" configure.ac
    sed -i -e "s/@LIBGCRYPT_LIBS@/#/g" src/Makefile.am
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

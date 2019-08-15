{stdenv, fetchurl, lzo, openssl, zlib}:

stdenv.mkDerivation rec {
  version = "1.0.35";
  pname = "tinc";

  src = fetchurl {
    url = "https://www.tinc-vpn.org/packages/tinc-${version}.tar.gz";
    sha256 = "0pl92sdwrkiwgll78x0ww06hfljd07mkwm62g8x17qn3gha3pj0q";
  };

  buildInputs = [ lzo openssl zlib ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

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
    platforms = stdenv.lib.platforms.unix;
  };
}

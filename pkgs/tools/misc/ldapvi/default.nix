{ stdenv, fetchgit, openldap, openssl, popt, glib, ncurses, readline, pkgconfig, cyrus_sasl, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "ldapvi-${version}";
  version = "0lz1sb5r0y9ypy8d7hm0l2wfa8l69f8ll0i5c78c0apz40nyjqkg";

  # use latest git, it includes some important patches since 2007 release
  src = fetchgit {
    url = "http://www.lichteblau.com/git/ldapvi.git";
    sha256 = "3ef3103030ecb04d7fe80180e3fd490377cf81fb2af96782323fddabc3225030";
  };

  buildInputs = [ openldap openssl popt glib ncurses readline pkgconfig cyrus_sasl autoconf automake ];

  setSourceRoot = ''
    sourceRoot=git-export/ldapvi
  '';
 
  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "ldapvi is an interactive LDAP client for Unix terminals. Using it, you can update LDAP entries with a text editor";
    homepage = http://www.lichteblau.com/ldapvi/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ iElectric ];
    platforms = stdenv.lib.platforms.linux;
  };
}

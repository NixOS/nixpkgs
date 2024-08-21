{ lib, stdenv, fetchgit, openldap, openssl, popt, glib, libxcrypt, ncurses, readline, pkg-config, cyrus_sasl, autoconf, automake }:

stdenv.mkDerivation {
  pname = "ldapvi";
  version = "unstable-2012-04-28";

  # use latest git, it includes some important patches since 2007 release
  src = fetchgit {
    url = "http://www.lichteblau.com/git/ldapvi.git";
    rev = "f1d42bad66cc4623d1ff21fbd5dddbf5009d3e40";
    sha256 = "3ef3103030ecb04d7fe80180e3fd490377cf81fb2af96782323fddabc3225030";
  };

  nativeBuildInputs = [ pkg-config autoconf automake ];
  buildInputs = [ openldap openssl popt glib libxcrypt ncurses readline cyrus_sasl ];

  preConfigure = ''
    cd ldapvi
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Interactive LDAP client for Unix terminals";
    longDescription = ''
      ldapvi is an interactive LDAP client for Unix terminals. Using it, you
      can update LDAP entries with a text editor.
    '';
    homepage = "http://www.lichteblau.com/ldapvi/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "ldapvi";
  };
}

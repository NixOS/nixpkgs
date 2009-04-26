{stdenv, fetchurl, pam, autoconf, automake, libtool, pkgconfig, glib, bison, flex}:

let

  # Configure script borrowed from the good folks at Gentoo 
  # (http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/sys-auth/pam_console/files/pam_console-configure.ac).
  configure = ./configure.ac;

in
   
stdenv.mkDerivation {
  name = "pam_console-0.99.5";
   
  src = fetchurl {
    url = http://cvs.fedora.redhat.com/repo/dist/pam/pam-redhat-0.99.5-1.tar.bz2/e2edde7861c48195728bc531e5a277e0/pam-redhat-0.99.5-1.tar.bz2;
    sha256 = "077xdhwspc785fas4yfw50mpy92rdfh35kq9awlrpbzq1fnapsfs";
  };

  buildInputs = [pam autoconf automake libtool pkgconfig glib bison flex];

  makeFlags = "LEX=flex";

  preConfigure = "
    cd pam_console
    cp ${configure} configure.ac
    touch NEWS AUTHORS ChangeLog
    # Don't try to create /var/run/console.
    substituteInPlace Makefile.am --replace 'mkdir -m $(LOCKMODE) -p -p $(DESTDIR)$(LOCKDIR)' ''
    autoreconf --install
  ";
}

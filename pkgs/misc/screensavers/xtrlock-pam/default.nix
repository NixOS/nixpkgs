{ stdenv, fetchgit, python, pkgconfig, x11, pam }:

stdenv.mkDerivation {
  name = "xtrlock-pam-3.4-post-20150909";

  src = fetchgit {
    url = "https://github.com/aanatoly/xtrlock-pam";
    rev = "6f4920fcfff54791c0779057e9efacbbbbc05df6";
    sha256 = "fa8aeedfa2a4e1d813f8cad562bafdd4e2c5130df0a7cde7b2f956a32044e9f8";
  };

  buildInputs = [ python pkgconfig x11 pam ];

  configurePhase = ''
    substituteInPlace .config/options.py --replace /usr/include/security/pam_appl.h ${pam}/include/security/pam_appl.h
    substituteInPlace src/xtrlock.c --replace system-local-login xscreensaver
    python configure --prefix=$out
  '';

  meta = {
    homepage = https://github.com/aanatoly/xtrlock-pam;
    description = "PAM based X11 screen locker";
    license = "unknown";
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
    platforms = with stdenv.lib.platforms; linux;
  };
}

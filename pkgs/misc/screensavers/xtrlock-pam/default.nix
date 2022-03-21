{ lib, stdenv, fetchgit, python2, pkg-config, xlibsWrapper, pam }:

stdenv.mkDerivation {
  pname = "xtrlock-pam";
  version = "3.4-post-20150909";

  src = fetchgit {
    url = "https://github.com/aanatoly/xtrlock-pam";
    rev = "6f4920fcfff54791c0779057e9efacbbbbc05df6";
    sha256 = "1z2wlhi5d05b18pvwz146kp0lkcc6z2mnilk01mk19hzbziyqmsc";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ python2 xlibsWrapper pam ];

  configurePhase = ''
    substituteInPlace .config/options.py --replace /usr/include/security/pam_appl.h ${pam}/include/security/pam_appl.h
    substituteInPlace src/xtrlock.c --replace system-local-login xscreensaver
    python configure --prefix=$out
  '';

  meta = {
    homepage = "https://github.com/aanatoly/xtrlock-pam";
    description = "PAM based X11 screen locker";
    license = "unknown";
    maintainers = with lib.maintainers; [ tstrobel ];
    platforms = with lib.platforms; linux;
  };
}

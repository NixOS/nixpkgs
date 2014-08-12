{ stdenv, fetchurl, pam, openssl, openssh, shadow }:

stdenv.mkDerivation {
  name = "shellinabox-2.14";

  src = fetchurl {
    url = "https://shellinabox.googlecode.com/files/shellinabox-2.14.tar.gz";
    sha1 = "9e01f58c68cb53211b83d0f02e676e0d50deb781";
  };

  buildInputs = [pam openssl openssh];

  patches = [ ./shellinabox-minus.patch ];

  # Disable GSSAPIAuthentication errors as well as correct hardcoded path. Take /usr/games's place. 
  preConfigure = ''
    substituteInPlace ./shellinabox/service.c --replace "-oGSSAPIAuthentication=no" ""
    substituteInPlace ./shellinabox/launcher.c --replace "/usr/games" "${openssh}/bin"
    substituteInPlace ./shellinabox/service.c --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace ./shellinabox/launcher.c --replace "/bin/login" "${shadow}/bin/login"
    '';
  meta = {
    homepage = https://code.google.com/p/shellinabox;
    description = "Web based AJAX terminal emulator";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.tomberek];
    platforms = stdenv.lib.platforms.linux;
  };
}

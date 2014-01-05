{ stdenv, fetchurl, pam, openssl, openssh }:

stdenv.mkDerivation {
  name = "shellinabox-2.14";

  src = fetchurl {
    url = "https://shellinabox.googlecode.com/files/shellinabox-2.14.tar.gz";
    sha1 = "9e01f58c68cb53211b83d0f02e676e0d50deb781";
  };
  buildInputs = [pam openssl openssh];

  # Disable GSSAPIAuthentication errors as well as correct hardcoded path. Take /usr/games's place. 
  preConfigure = ''
    substituteInPlace ./shellinabox/service.c --replace "-oGSSAPIAuthentication=no" ""
    substituteInPlace ./shellinabox/launcher.c --replace "/usr/games" "${openssh}/bin"
    '';
  meta = {
    homepage = https://code.google.com/p/shellinabox;
    description = "Web based AJAX terminal emulator";
    license = "GPLv2";
    maintainers = [stdenv.lib.maintainers.tomberek];
    platforms = stdenv.lib.platforms.linux;
  };
}

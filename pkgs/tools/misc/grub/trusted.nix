{stdenv, fetchgit, autoconf, automake, buggyBiosCDSupport ? true}:

stdenv.mkDerivation {
  name = "trustedGRUB-1.1.5";

  src = fetchgit {
     url = "https://github.com/ts468/TrustedGRUB";
     rev = "954941c17e14c8f7b18e6cd3043ef5f946866f1c";
     sha256 = "30c21765dc44f02275e66220d6724ec9cd45496226ca28c6db59a9147aa22685";
  };

  # Autoconf/automake required for the splashimage patch.
  buildInputs = [autoconf automake];

  preConfigure = ''
    autoreconf
  '';

  meta = {
    homepage = "http://sourceforge.net/projects/trustedgrub/";
    repositories.git = https://github.com/ts468/TrustedGRUB;
    description = "Legacy GRUB bootloader extended with TCG support";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "pixiewps-${version}";
  version = "1.2.2";
  src = fetchFromGitHub {
    owner = "wiire";
    repo = "pixiewps";
    rev = "v${version}";
    sha256 = "09znnj7p8cks7zxzklkdm4zy2qnp92vhngm9r0zfgawnl2b4r2aw";
  };

  preBuild = ''
    cd src
    substituteInPlace Makefile --replace "\$(DESTDIR)/usr" "$out"
    substituteInPlace Makefile --replace "/local" ""
  '';
  
  meta = {
    description = "An offline WPS bruteforce utility";
    homepage = https://github.com/wiire/pixiewps;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
    platforms = stdenv.lib.platforms.linux;
  };
}

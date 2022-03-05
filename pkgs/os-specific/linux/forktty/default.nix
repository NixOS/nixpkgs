{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "forktty";
  version = "1.3";

  src = fetchurl {
    url = "http://sunsite.unc.edu/pub/linux/utils/terminal/forktty-${version}.tgz";
    sha256 = "sha256-6xc5eshCuCIOsDh0r2DizKAeypGH0TRRotZ4itsvpVk=";
  };

  preBuild = ''
    sed -e s@/usr/bin/ginstall@install@g -i Makefile
  '';

  preInstall = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man8"
  '';

  makeFlags = [ "prefix=$(out)" "manprefix=$(out)/share/" ];

  meta = with lib; {
    description = "Tool to detach from controlling TTY and attach to another";
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}

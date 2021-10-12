{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "hd-idle";
  version = "1.05";

  src = fetchurl {
    url = "mirror://sourceforge/project/hd-idle/hd-idle-${version}.tgz";
    sha256 = "031sm996s0rhy3z91b9xvyimsj2yd2fhsww2al2hxda5s5wzxzjf";
  };

  prePatch = ''
    substituteInPlace Makefile \
      --replace "-g root -o root" ""
  '';

  installFlags = [ "TARGET_DIR=$(out)" ];

  meta = with lib; {
    description = "Spins down external disks after a period of idle time";
    homepage = "http://hd-idle.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.rycee ];
  };
}

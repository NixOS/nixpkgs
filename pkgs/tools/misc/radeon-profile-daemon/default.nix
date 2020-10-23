{ lib, stdenv, fetchFromGitHub
, qtbase, qtcharts, qmake, libXrandr, libdrm
}:

stdenv.mkDerivation rec {
  pname = "radeon-profile-daemon";
  version = "20190603";

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtcharts libXrandr libdrm ];

  src = (fetchFromGitHub {
    owner  = "marazmista";
    repo   = "radeon-profile-daemon";
    rev    = version;
    sha256 = "06qxq2hv3l9shna8x5d9awbdm9pbwlc6vckcr63kf37rrs8ykk0j";
  }) + "/radeon-profile-daemon";

  preConfigure = ''
    substituteInPlace radeon-profile-daemon.pro \
      --replace "/usr/" "$out/"
  '';

  meta = with lib; {
    description = "Application to read current clocks of AMD Radeon cards";
    homepage    = "https://github.com/marazmista/radeon-profile";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
  };
}

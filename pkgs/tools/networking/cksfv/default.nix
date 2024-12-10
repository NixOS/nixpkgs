{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "cksfv";
  version = "1.3.15";

  src = fetchurl {
    url = "https://zakalwe.fi/~shd/foss/cksfv/files/cksfv-${version}.tar.bz2";
    sha256 = "0k06aq94cn5xp4knjw0p7gz06hzh622ql2xvnrlr3q8rcmdvwwx1";
  };

  meta = with lib; {
    homepage = "https://zakalwe.fi/~shd/foss/cksfv/";
    description = "A tool for verifying files against a SFV checksum file";
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    mainProgram = "cksfv";
  };
}

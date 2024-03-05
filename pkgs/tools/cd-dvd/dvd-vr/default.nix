{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dvd-vr";
  version = "0.9.7";
  src = fetchurl {
    url = "https://www.pixelbeat.org/programs/dvd-vr/dvd-vr-${version}.tar.gz";
    sha256 = "13wkdia3c0ryda40b2nzpb9vddimasgc4w95hvl0k555k9k8bl0r";
  };
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://www.pixelbeat.org/programs/dvd-vr/";
    downloadPage = "https://www.pixelbeat.org/programs/dvd-vr/";
    description = "A utility to identify and optionally copy recordings from a DVD-VR format disc";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "dvd-vr";
  };
}


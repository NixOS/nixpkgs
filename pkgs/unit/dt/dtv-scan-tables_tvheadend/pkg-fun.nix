{ lib
, stdenv
, fetchFromGitHub
, v4l-utils
}:

stdenv.mkDerivation rec {
  pname = "dtv-scan-tables";
  version = "20221027-tvheadend";

  src = fetchFromGitHub {
    owner = "tvheadend";
    repo = "dtv-scan-tables";
    rev = "2a3dbfbab129c00d3f131c9c2f06b2be4c06fec6";
    hash = "sha256-bJ+naUs3TDFul4PmpnWYld3j1Se+1X6U9jnECe3sno0=";
  };

  nativeBuildInputs = [
    v4l-utils
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  allowedReferences = [ ];

  meta = with lib; {
    description = "Digital TV (DVB) channel/transponder scan tables";
    homepage = "https://github.com/tvheadend/dtv-scan-tables";
    license = with licenses; [ gpl2Only lgpl21Only ];
    longDescription = ''
      When scanning for dvb channels,
      most applications require an initial set of
      transponder coordinates (frequencies etc.).
      These coordinates differ, depending of the
      receiver's location or on the satellite.
      The package delivers a collection of transponder
      tables ready to be used by software like "dvbv5-scan".
      The package at hand is maintained and used by tvheadend,
      it is a fork of the original one hosted by linuxtv.org.
    '';
    maintainers = with maintainers; [ ];
  };
}

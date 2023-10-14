{ fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "digitemp";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "bcl";
    repo = "digitemp";
    rev = "v${version}";
    sha256 = "19zka5fcdxhhginaspak76l984iqq9v2j6qrwvi5mvca7bcj8f72";
  };

  enableParallelBuilding = true;

  makeFlags = [
    "LOCK=no"
    "ds9097"
    "ds9097u"
  ];

  installPhase = ''
    runHook preInstall
    install -D -m555 -t $out/bin digitemp_*
    install -D -m444 -t $out/share/doc/${pname} FAQ README
    runHook postInstall
  '';

  meta = with lib; {
    description = "Temperature logging and reporting using Maxim's iButtons and 1-Wire protocol";
    longDescription = ''
      DigiTemp is a command line application used for reading 1-wire sensors like
      the DS18S20 temperature sensor, or DS2438 battery monitor. DigiTemp supports
      the following devices:

        DS18S20 (and older DS1820) Temperature Sensor
        DS18B20 Temperature Sensor
        DS1822 Temperature Sensor
        DS2438 Battery monitor
        DS2409 1-wire coupler (used in 1-wire hubs)
        DS2422 Counter
        DS2423 Counter

      The output format can be customized and all settings are stored in a
      configuration file (.digitemprc) in the current directory. DigiTemp can
      repeatedly read the sensors and output to stdout and/or to a logfile.
    '';
    homepage = "https://www.digitemp.com";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.fogti ];
    platforms = platforms.unix;
  };
}

{ stdenv, fetchurl, autoreconfHook
, IOKit ? null , ApplicationServices ? null }:

let
  version = "6.6";

  dbrev = "4548";
  drivedbBranch = "RELEASE_${builtins.replaceStrings ["."] ["_"] version}_DRIVEDB";
  driverdb = fetchurl {
    url    = "http://sourceforge.net/p/smartmontools/code/${dbrev}/tree/branches/${drivedbBranch}/smartmontools/drivedb.h?format=raw";
    sha256 = "0nwk4ir0c40b01frqm7a0lvljh5k9yhslc3j4485zjsx3v5w269f";
    name   = "smartmontools-drivedb.h";
  };

in stdenv.mkDerivation rec {
  name = "smartmontools-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "0m1hllbb78rr6cxkbalmz1gqkl0psgq8rrmv4gwcmz34n07kvx2i";
  };

  patches = [ ./smartmontools.patch ];
  postPatch = "cp -v ${driverdb} drivedb.h";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [IOKit ApplicationServices];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tools for monitoring the health of hard drives";
    homepage    = http://smartmontools.sourceforge.net/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti ];
    platforms   = with platforms; linux ++ darwin;
  };
}

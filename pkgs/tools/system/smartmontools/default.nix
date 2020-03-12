{ stdenv, fetchurl, autoreconfHook
, IOKit ? null , ApplicationServices ? null }:

let
  version = "7.1";

  dbrev = "5033";
  drivedbBranch = "RELEASE_7_0_DRIVEDB";
  driverdb = fetchurl {
    url    = "https://sourceforge.net/p/smartmontools/code/${dbrev}/tree/branches/${drivedbBranch}/smartmontools/drivedb.h?format=raw";
    sha256 = "029j118lwiazn56vg6d3i7ayv73wrpv1fypw3ff4nd4hgs2mlcrg";
    name   = "smartmontools-drivedb.h";
  };

in stdenv.mkDerivation rec {
  pname = "smartmontools";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${pname}-${version}.tar.gz";
    sha256 = "0imqb7ka4ia5573w8rnpck571pjjc9698pdjcapy9cfyk4n4swrz";
  };

  patches = [ ./smartmontools.patch ];
  postPatch = "cp -v ${driverdb} drivedb.h";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [IOKit ApplicationServices];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tools for monitoring the health of hard drives";
    homepage    = https://www.smartmontools.org/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti Frostman ];
    platforms   = with platforms; linux ++ darwin;
  };
}

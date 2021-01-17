{ lib, stdenv, fetchurl, autoreconfHook
, mailutils, inetutils
, IOKit, ApplicationServices }:

let
  version = "7.2";

  dbrev = "5164";
  drivedbBranch = "RELEASE_7_2_DRIVEDB";
  driverdb = fetchurl {
    url    = "https://sourceforge.net/p/smartmontools/code/${dbrev}/tree/branches/${drivedbBranch}/smartmontools/drivedb.h?format=raw";
    sha256 = "1vj0sv3bgcd0lwk5x450brfyxksa5fn1mjgvmj994ab8spmicc43";
    name   = "smartmontools-drivedb.h";
  };

in stdenv.mkDerivation rec {
  pname = "smartmontools";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${pname}-${version}.tar.gz";
    sha256 = "1mlc25sd5rgj5xmzcllci47inmfdw7cp185fday6hc9rwqkqmnaw";
  };

  patches = [ ./smartmontools.patch ];
  postPatch = "cp -v ${driverdb} drivedb.h";

  configureFlags = [
    "--with-scriptpath=${lib.makeBinPath [ mailutils inetutils ]}"
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [] ++ lib.optionals stdenv.isDarwin [IOKit ApplicationServices];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tools for monitoring the health of hard drives";
    homepage    = "https://www.smartmontools.org/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti Frostman ];
    platforms   = with platforms; linux ++ darwin;
  };
}

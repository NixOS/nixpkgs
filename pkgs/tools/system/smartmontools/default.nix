{ lib, stdenv, fetchurl, autoreconfHook
, mailutils, enableMail ? true
, inetutils
, IOKit, ApplicationServices }:

let
  version = "7.2";

  dbrev = "5171";
  drivedbBranch = "RELEASE_7_2_DRIVEDB";
  driverdb = fetchurl {
    url    = "https://sourceforge.net/p/smartmontools/code/${dbrev}/tree/branches/${drivedbBranch}/smartmontools/drivedb.h?format=raw";
    sha256 = "0vncr98xagbcfsxgfgxsip2qrl9q3y8va19qhv6yknlwbdfap4mn";
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
    "--with-scriptpath=${lib.makeBinPath ([ inetutils ] ++ lib.optional enableMail mailutils)}"
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

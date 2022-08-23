{ lib
, stdenv
, fetchurl
, autoreconfHook
, enableMail ? false
, gnused
, mailutils
, inetutils
, IOKit
, ApplicationServices
}:

let
  dbrev = "5388";
  drivedbBranch = "RELEASE_7_3_DRIVEDB";
  driverdb = fetchurl {
    url = "https://sourceforge.net/p/smartmontools/code/${dbrev}/tree/branches/${drivedbBranch}/smartmontools/drivedb.h?format=raw";
    sha256 = "sha256-0dtLev4JjeHsS259+qOgg19rz4yjkeX4D3ooUgS4RTI=";
    name = "smartmontools-drivedb.h";
  };

in
stdenv.mkDerivation rec {
  pname = "smartmontools";
  version = "7.3";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${pname}-${version}.tar.gz";
    sha256 = "sha256-pUT4gI0MWM+w50JMoYQcuFipdJIrA11QXU5MJIvjois=";
  };

  patches = [
    # fixes darwin build
    ./smartmontools.patch
  ];
  postPatch = ''
    cp -v ${driverdb} drivedb.h
  '';

  configureFlags = lib.optional enableMail "--with-scriptpath=${lib.makeBinPath [ gnused inetutils mailutils ]}";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ApplicationServices ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tools for monitoring the health of hard drives";
    homepage = "https://www.smartmontools.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ Frostman ];
    platforms = with platforms; linux ++ darwin;
    mainProgram = "smartctl";
  };
}

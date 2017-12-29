{ stdenv, fetchurl, autoreconfHook
, IOKit ? null , ApplicationServices ? null }:

let
  version = "6.5";

  dbrev = "4394";
  drivedbBranch = "RELEASE_${builtins.replaceStrings ["."] ["_"] version}_DRIVEDB";
  driverdb = fetchurl {
    url = "http://sourceforge.net/p/smartmontools/code/${dbrev}/tree/branches/${drivedbBranch}/smartmontools/drivedb.h?format=raw";
    sha256 = "1kdpgbl1az0xhqn7j613cx366n7amra8xz3391jpzzrd3vlga393";
    name = "smartmontools-drivedb.h";
  };

in stdenv.mkDerivation rec {
  name = "smartmontools-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "1g25r6sx85b5lay5n6sbnqv05qxzj6xsafsp93hnrg1h044bps49";
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

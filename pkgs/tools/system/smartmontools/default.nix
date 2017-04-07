{ stdenv, fetchurl, IOKit ? null , ApplicationServices ? null }:

let

  version = "6.5";

  dbrev = "4391";
  drivedbBranch = "RELEASE_${builtins.replaceStrings ["."] ["_"] version}_DRIVEDB";
  driverdb = fetchurl {
    url = "http://sourceforge.net/p/smartmontools/code/${dbrev}/tree/branches/${drivedbBranch}/smartmontools/drivedb.h?format=raw";
    sha256 = "1da99m81wr0rjdhcz2xx0sbbrqxkxffja2kllg4srmhih7fps5p1";
    name = "smartmontools-drivedb.h";
  };

in

stdenv.mkDerivation rec {
  name = "smartmontools-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "1g25r6sx85b5lay5n6sbnqv05qxzj6xsafsp93hnrg1h044bps49";
  };

  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [IOKit ApplicationServices];

  patches = [ ./smartmontools.patch ];
  postPatch = "cp -v ${driverdb} drivedb.h";

  meta = with stdenv.lib; {
    description = "Tools for monitoring the health of hard drives";
    homepage = http://smartmontools.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.peti ];
  };
}

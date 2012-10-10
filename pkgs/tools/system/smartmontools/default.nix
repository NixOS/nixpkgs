{ stdenv, fetchurl }:

let
  driverdb = fetchurl {
    url = "http://smartmontools.svn.sourceforge.net/viewvc/smartmontools/branches/RELEASE_5_43_DRIVEDB/smartmontools/drivedb.h?revision=3605";
    sha256 = "1kibx5aal903hcpy6mjmfik6n9j142i3q3vvrcp1wmz10mfsqj8f";
  };
in
stdenv.mkDerivation rec {
  name = "smartmontools-6.0";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "9fe4ff2b7bcd00fde19db82bba168f5462ed6e857d3ef439495e304e3231d3a6";
  };

  # patchPhase = "cp ${driverdb} drivedb.h";

  meta = {
    description = "Tools for monitoring the health of hard drivers";
    homepage = "http://smartmontools.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}

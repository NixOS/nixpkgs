{ stdenv, fetchurl }:

let
  dbrev = "3849";
  driverdb = fetchurl {
    url = "http://sourceforge.net/p/smartmontools/code/${dbrev}/tree/trunk/smartmontools/drivedb.h?format=raw";
    sha256 = "06c1cl0x4sq64l3rmd5rk8wsbggjixphpgj0kf4awqhjgsi102xz";
    name = "smartmontools-drivedb.h";
  };
in
stdenv.mkDerivation rec {
  name = "smartmontools-6.2";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "0nq6jvfh8nqwfrvp6fb6qs2rdydi3i9xgpi7p7vb83xvg42ncvs8";
  };

  prePatch = ''
    : cp ${driverdb} drivedb.h
    sed -i -e 's@which which >/dev/null || exit 1@alias which="type -p"@' update-smart-drivedb.in
  '';

  patches = [ ./no-dates-in-binary.patch ];

  # This package does not handle useFakeTime well
  # useFakeTime = 1;

  meta = {
    description = "Tools for monitoring the health of hard drivers";
    homepage = "http://smartmontools.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}

{ stdenv, fetchurl }:

let
  driverdb = fetchurl {
    url = "http://smartmontools.svn.sourceforge.net/viewvc/smartmontools/trunk/smartmontools/drivedb.h?revision=3797";
    sha256 = "01ycm3vffxpfvfga9vp1d38jy3lqpkpxnxf78pidc8q1nn8bpdyz";
    name = "smartmontools-drivedb.h";
  };
in
stdenv.mkDerivation rec {
  name = "smartmontools-6.1";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "01yfv6hqsqandg6x8mnwa4g42hhqvc7dfxnfb3v849n8rj5kn059";
  };

  patchPhase = ''
    cp ${driverdb} drivedb.h
    sed -i -e 's@which which >/dev/null || exit 1@alias which="type -p"@' update-smart-drivedb.in
  '';

  meta = {
    description = "Tools for monitoring the health of hard drivers";
    homepage = "http://smartmontools.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}

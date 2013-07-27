{ stdenv, fetchurl }:

let
  driverdb = fetchurl {
    url = "http://smartmontools.svn.sourceforge.net/viewvc/smartmontools/trunk/smartmontools/drivedb.h?revision=3812";
    sha256 = "1x22ammjwlb7p3cmd13shqq1payb7nr9pgfa9xifs19qyr77mrwp";
    name = "smartmontools-drivedb.h";
  };
in
stdenv.mkDerivation rec {
  name = "smartmontools-6.2";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "0nq6jvfh8nqwfrvp6fb6qs2rdydi3i9xgpi7p7vb83xvg42ncvs8";
  };

  patchPhase = ''
    : cp ${driverdb} drivedb.h
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

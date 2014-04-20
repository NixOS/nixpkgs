{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtools-4.0.18";

  src = fetchurl {
    url = "mirror://gnu/mtools/${name}.tar.bz2";
    sha256 = "119gdfnsxc6hzicnsf718k0fxgy2q14pxn7557rc96aki20czsar";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/mtools/;
    description = "GNU mtools, utilities to access MS-DOS disks";
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
    maintainers = [ ];
  };
}

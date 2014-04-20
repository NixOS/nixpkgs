{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "pv-1.5.2";

  src = fetchurl {
    url = "http://www.ivarch.com/programs/sources/${name}.tar.bz2";
    sha256 = "1sz5ishd66xliwnhv0x3vr48fbp7id4xd8fsrbm66y7f5mfd7qp2";
  };

  meta = {
    homepage = http://www.ivarch.com/programs/pv;
    description = "Tool for monitoring the progress of data through a pipeline";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}

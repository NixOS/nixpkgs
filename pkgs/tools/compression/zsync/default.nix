{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "zsync";
  version = "0.6.2";

  src = fetchurl {
    url = "http://zsync.moria.org.uk/download/${pname}-${version}.tar.bz2";
    sha256 = "1wjslvfy76szf0mgg2i9y9q30858xyjn6v2acc24zal76d1m778b";
  };

  makeFlags = [ "AR=${stdenv.cc.bintools.targetPrefix}ar" ];

  meta = with lib; {
    homepage = "http://zsync.moria.org.uk/";
    description = "File distribution system using the rsync algorithm";
    license = licenses.artistic2;
    maintainers = with maintainers; [ viric ];
    platforms = with platforms; all;
  };
}

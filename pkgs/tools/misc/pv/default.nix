{ lib, stdenv, fetchurl } :

stdenv.mkDerivation rec {
  pname = "pv";
  version = "1.6.6";

  src = fetchurl {
    url = "https://www.ivarch.com/programs/sources/pv-${version}.tar.bz2";
    sha256 = "1wbk14xh9rfypiwyy68ssl8dliyji30ly70qki1y2xx3ywszk3k0";
  };

  meta = {
    homepage = "http://www.ivarch.com/programs/pv";
    description = "Tool for monitoring the progress of data through a pipeline";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; all;
  };
}

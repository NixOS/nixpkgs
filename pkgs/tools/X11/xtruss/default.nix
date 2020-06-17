{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "xtruss";
  version = "20181001.82973f5";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/xtruss/${pname}-${version}.tar.gz";
    sha256 = "1mm8k92zc318jk71wlf2r4rb723nd9lalhjl0pf48raiajb5ifgd";
  };

  meta = with stdenv.lib; {
    description = "easy-to-use X protocol tracing program";
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/xtruss";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

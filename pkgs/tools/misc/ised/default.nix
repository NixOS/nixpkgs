{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ised";
  version = "2.7.1";
  src = fetchurl {
    url = "mirror://sourceforge/project/ised/${pname}-${version}.tar.bz2";
    sha256 = "0fhha61whkkqranqdxg792g0f5kgp5m3m6z1iqcvjh2c34rczbmb";
  };

  meta = {
    description = "Numeric sequence editor";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = with lib.platforms; linux;
    license = lib.licenses.gpl3Plus;
    mainProgram = "ised";
  };
}

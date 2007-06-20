{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "units-1.86";

  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/units/units-1.86.tar.gz;
    sha256 = "1syc4d3x1wb03hcxnz7rkgapk96biazfk2qqn2wfyx54bq829lhi";
  };
}

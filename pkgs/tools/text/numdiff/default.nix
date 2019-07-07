{ stdenv, fetchurl }:


stdenv.mkDerivation rec {
  name = "numdiff-${version}";
  version = "5.9.0";

  src = fetchurl {
    url = "mirror://savannah/numdiff/numdiff-${version}.tar.gz";
    sha256 = "1vzmjh8mhwwysn4x4m2vif7q2k8i19x8azq7pzmkwwj4g48lla47";
  };
  meta = with stdenv.lib; {
    description = ''
      A little program that can be used to compare putatively similar files
      line by line and field by field, ignoring small numeric differences
      or/and different numeric formats
    '';
    homepage = https://www.nongnu.org/numdiff/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ndowens ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}

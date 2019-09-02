{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libdsk";
  version = "1.5.10";

  src = fetchurl {
    url = "https://www.seasip.info/Unix/LibDsk/${pname}-${version}.tar.gz";
    sha256 = "0ndkwyf8dp252v4yhqphvi32gmz9m5kkdqwv0aw92cz7mfbnp36g";
  };

  meta = with stdenv.lib; {
    description = "A library for accessing discs and disc image files";
    homepage = http://www.seasip.info/Unix/LibDsk/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}

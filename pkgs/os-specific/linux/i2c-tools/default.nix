{ stdenv, fetchurl, perl, read-edid }:

stdenv.mkDerivation rec {
  pname = "i2c-tools";
  version = "4.2";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/utils/i2c-tools/${pname}-${version}.tar.xz";
    sha256 = "1mmc1n8awl3winyrp1rcxg94vjsx9dc1y7gj7y88blc2f2ydmwip";
  };

  buildInputs = [ perl ];

  postPatch = ''
    substituteInPlace eeprom/decode-edid --replace "/usr/sbin/parse-edid" "${read-edid}/bin/parse-edid"
    substituteInPlace stub/i2c-stub-from-dump --replace "/sbin/" ""
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    rm -rf $out/include # Installs include/linux/i2c-dev.h that conflics with kernel headers
  '';

  meta = with stdenv.lib; {
    description = "Set of I2C tools for Linux";
    homepage = "https://i2c.wiki.kernel.org/index.php/I2C_Tools";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}

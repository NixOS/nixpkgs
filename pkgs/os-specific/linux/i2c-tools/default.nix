{ stdenv, fetchurl, perl, read-edid }:

stdenv.mkDerivation rec {
  name = "i2c-tools-${version}";
  version = "4.0";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/utils/i2c-tools/${name}.tar.xz";
    sha256 = "1mi8mykvl89y6liinc9jv1x8m2q093wrdc2hm86a47n524fcl06r";
  };

  buildInputs = [ perl ];

  patchPhase = ''
    substituteInPlace eeprom/decode-edid --replace "/usr/sbin/parse-edid" "${read-edid}/bin/parse-edid"
    substituteInPlace stub/i2c-stub-from-dump --replace "/sbin/" ""
  '';

  installPhase = ''
    make install prefix=$out
    rm -rf $out/include # Installs include/linux/i2c-dev.h that conflics with kernel headers
  '';

  meta = with stdenv.lib; {
    description = "Set of I2C tools for Linux";
    homepage = http://www.lm-sensors.org/wiki/I2CTools;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}

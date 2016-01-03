{ stdenv, fetchurl, perl, read-edid }:

stdenv.mkDerivation rec {
  name = "i2c-tools-${version}";
  version = "3.1.1";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/i/i2c-tools/i2c-tools_${version}.orig.tar.bz2";
    sha256 = "000pvg995qy1b15ks59gd0klri55hb33kqpg5czy84hw1pbdgm0l";
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

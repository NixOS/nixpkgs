{
  lib,
  stdenv,
  fetchzip,
  perl,
  read-edid,
}:

stdenv.mkDerivation rec {
  pname = "i2c-tools";
  version = "4.3";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/i2c-tools/i2c-tools.git/snapshot/i2c-tools-v${version}.tar.gz";
    sha256 = "sha256-HlmIocum+HZEKNiS5BUwEIswRfTMUhD1vCPibAuAK0Q=";
  };

  buildInputs = [ perl ];

  postPatch = ''
    substituteInPlace eeprom/decode-edid \
      --replace "/usr/sbin/parse-edid" "${read-edid}/bin/parse-edid"

    substituteInPlace stub/i2c-stub-from-dump \
      --replace "/sbin/" ""
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  outputs = [
    "out"
    "man"
  ];

  postInstall = ''
    rm -rf $out/include/linux/i2c-dev.h # conflics with kernel headers
  '';

  meta = with lib; {
    description = "Set of I2C tools for Linux";
    homepage = "https://i2c.wiki.kernel.org/index.php/I2C_Tools";
    # library is LGPL 2.1 or later; "most tools" GPL 2 or later
    license = with licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}

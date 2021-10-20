{ lib
, stdenv
, fetchgit
, perl
, read-edid
}:

stdenv.mkDerivation rec {
  pname = "i2c-tools";
  version = "4.2";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/i2c-tools/i2c-tools.git";
    rev = "v${version}";
    sha256 = "0vqrbp10klr7ylarr6cy1q7nafiqaky4iq5my5dqy101h93vg4pg";
  };

  buildInputs = [ perl ];

  postPatch = ''
    substituteInPlace eeprom/decode-edid --replace "/usr/sbin/parse-edid" "${read-edid}/bin/parse-edid"
    substituteInPlace stub/i2c-stub-from-dump --replace "/sbin/" ""
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  outputs = [ "out" "man" ];

  postInstall = ''
    rm -rf $out/include # Installs include/linux/i2c-dev.h that conflics with kernel headers
  '';

  meta = with lib; {
    description = "Set of I2C tools for Linux";
    homepage = "https://i2c.wiki.kernel.org/index.php/I2C_Tools";
    # library is LGPL 2.1 or later; "most tools" GPL 2 or later
    license = with licenses; [ lgpl21Plus gpl2Plus ];
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}

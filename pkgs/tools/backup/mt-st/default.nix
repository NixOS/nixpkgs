{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mt-st-1.3";

  src = fetchurl {
    url = "https://github.com/iustin/mt-st/releases/download/${name}/${name}.tar.gz";
    sha256 = "b552775326a327cdcc076c431c5cbc4f4e235ac7c41aa931ad83f94cccb9f6de";
  };

  installFlags = [ "PREFIX=$(out)" "EXEC_PREFIX=$(out)" ];

  meta = {
    description = "Magnetic Tape control tools for Linux";
    longDescription = ''
      Fork of the standard "mt" tool with additional Linux-specific IOCTLs.
    '';
    homepage = https://github.com/iustin/mt-st;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.redvers ];
    platforms = stdenv.lib.platforms.linux;
  };
}

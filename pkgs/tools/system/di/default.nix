{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "di";
  version = "4.47.1";

  src = fetchurl {
    url = "https://gentoo.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1bdbl9k3gqf4h6g21difqc0w17pjid6r587y19wi37vx36aava7f";
  };

  makeFlags = [ "INSTALL_DIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = https://gentoo.com/di/;
    license = licenses.zlib;
    updateWalker = true;
    maintainers = with maintainers; [ manveru ndowens ];
    platforms = platforms.all;
  };
}

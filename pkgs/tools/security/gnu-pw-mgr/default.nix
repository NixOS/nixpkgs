{ stdenv, lib, fetchurl, gnulib }:

stdenv.mkDerivation rec {
  name = "gnu-pw-mgr-${version}";
  version = "2.3.3";
  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/gnu-pw-mgr/${name}.tar.xz";
    sha256 = "04xh38j7l0sfnb01kp05xc908pvqfc0lph94k7n9bi46zy3qy7ma";
  };

  buildInputs = [ gnulib ];

  meta = with lib; {
    homepage = https://www.gnu.org/software/gnu-pw-mgr/;
    description = "A password manager designed to make it easy to reconstruct difficult passwords";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ qoelet ];
  };
}

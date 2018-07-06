{ stdenv, lib, fetchurl, gnulib }:

stdenv.mkDerivation rec {
  name = "gnu-pw-mgr-${version}";
  version = "2.3.2";
  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/gnu-pw-mgr/${name}.tar.xz";
    sha256 = "0x60g0syqpd107l8w4bl213imy2lspm4kz1j18yr1sh10rdxlgxd";
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

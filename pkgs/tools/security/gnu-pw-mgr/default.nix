{ stdenv, lib, fetchurl, gnulib }:

stdenv.mkDerivation rec {
  name = "gnu-pw-mgr-${version}";
  version = "2.4.2";
  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/gnu-pw-mgr/${name}.tar.xz";
    sha256 = "1yvdzc5w37qrjrkby5699ygj9bhkvgi3zk9k9jcjry1j6b7wdl17";
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

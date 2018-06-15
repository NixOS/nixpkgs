{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "uftp-${version}";
  version = "4.9.7";

  src = fetchurl {
    url = "mirror://sourceforge/uftp-multicast/source-tar/uftp-${version}.tar.gz";
    sha256 = "1gh1zpc6dh690xjhfp5x2ajhwjkchyh5wazr8agm6axxwqhd9gn8";
  };

  buildInputs = [ openssl ];

  outputs = [ "out" "man" ];

  patchPhase = ''
    substituteInPlace makefile --replace gcc cc
  '';

  installPhase = ''
    mkdir -p $out/bin $man/share/man/man1
    cp {uftp,uftpd,uftp_keymgt,uftpproxyd} $out/bin/
    cp {uftp.1,uftpd.1,uftp_keymgt.1,uftpproxyd.1} $man/share/man/man1
  '';

  meta = {
    description = "Encrypted UDP based FTP with multicast";
    homepage = http://uftp-multicast.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}

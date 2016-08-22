{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "uftp-${version}";
  version = "4.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/uftp-multicast/source-tar/uftp-${version}.tar.gz";
    sha256 = "0pra2sm8rdscyqkagi2v99az1vxbcch47wkdnz9wv4qg1x5phpmr";
  };

  buildInputs = [
    openssl
  ];

  outputs = [ "out" "doc" ];

  patchPhase = ''
    substituteInPlace makefile --replace gcc cc
  '';

  installPhase = ''
    mkdir -p $out/bin $doc/share/man/man1
    cp {uftp,uftpd,uftp_keymgt,uftpproxyd} $out/bin/
    cp {uftp.1,uftpd.1,uftp_keymgt.1,uftpproxyd.1} $doc/share/man/man1
  '';

  meta = {
    description = "Encrypted UDP based FTP with multicast";
    homepage = http://uftp-multicast.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}

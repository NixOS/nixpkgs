{ stdenv, lib, fetchFromGitHub, pkgconfig, openssl, makeWrapper, python, coreutils }:

stdenv.mkDerivation rec {
  name = "cipherscan-${version}";
  version = "2016-08-16";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cipherscan";
    rev = "74dd82e8ad994a140daf79489d3bd1c5ad928d38";
    sha256 = "16azhlmairnvdz7xmwgvfpn2pzw1p8z7c9b27m07fngqjkpx0mhh";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python ];

  buildPhase = ''
    substituteInPlace cipherscan --replace '$0' 'cipherscan'
  '';

  installPhase = ''
    mkdir -p $out/bin

    cp cipherscan $out/bin
    cp openssl.cnf $out/bin
    cp analyze.py $out/bin/cipherscan-analyze

    wrapProgram $out/bin/cipherscan \
      --set NOAUTODETECT 1 \
      --set TIMEOUTBIN "${coreutils}/bin/timeout" \
      --set OPENSSLBIN "${openssl}/bin/openssl"
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Very simple way to find out which SSL ciphersuites are supported by a target";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ cstrahan fpletz ];
  };
}

{ stdenv, lib, fetchFromGitHub, pkgconfig, openssl, makeWrapper, python, coreutils }:

stdenv.mkDerivation rec {
  name = "cipherscan-${version}";
  version = "2015-12-17";
  src = fetchFromGitHub {
    owner = "jvehent";
    repo = "cipherscan";
    rev = "18b0d1b952d027d20e38f07329817873ec077d26";
    sha256 = "0b6fkfm2y8w04am4krspmapcc5ngn603n5rlwyjly92z2dawc7h8";
  };
  buildInputs = [ makeWrapper python ];
  patches = [ ./path.patch ];
  buildPhase = ''
    substituteInPlace cipherscan \
      --replace "@OPENSSLBIN@" \
                "${openssl}/bin/openssl" \
      --replace "@TIMEOUTBIN@" \
                "${coreutils}/bin/timeout" \
      --replace "@READLINKBIN@" \
                "${coreutils}/bin/readlink"

    substituteInPlace analyze.py \
      --replace "@OPENSSLBIN@" \
                "${openssl}/bin/openssl"
  '';
  installPhase = ''
    mkdir -p $out/bin

    cp cipherscan $out/bin
    cp openssl.cnf $out/bin
    cp analyze.py $out/bin

    wrapProgram $out/bin/analyze.py --set PYTHONPATH "$PYTHONPATH"
  '';
  meta = with lib; {
    description = "Very simple way to find out which SSL ciphersuites are supported by a target";
    homepage = "https://github.com/jvehent/cipherscan";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ cstrahan ];
  };
}

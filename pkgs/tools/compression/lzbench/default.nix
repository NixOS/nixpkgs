{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lzbench";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "inikep";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gxw9b3yjj3z2b1y9mx3yfhklyxpfmb8fjf9mfpg9hlbr9mcpff3";
  };

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp lzbench $out/bin
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "In-memory benchmark of open-source LZ77/LZSS/LZMA compressors";
    license = licenses.free;
    platforms = platforms.all;
  };
}

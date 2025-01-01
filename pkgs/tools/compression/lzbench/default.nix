{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lzbench";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "inikep";
    repo = pname;
    rev = "v${version}";
    sha256 = "19zlvcjb1qg4fx30rrp6m650660y35736j8szvdxmqh9ipkisyia";
  };

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp lzbench $out/bin
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "In-memory benchmark of open-source LZ77/LZSS/LZMA compressors";
    license = licenses.free;
    platforms = platforms.all;
    mainProgram = "lzbench";
  };
}

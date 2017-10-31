{ stdenv, fetchFromGitHub, glibc }:

stdenv.mkDerivation rec {
  name = "lzbench-20170208";

  src = fetchFromGitHub {
    owner = "inikep";
    repo = "lzbench";
    rev = "d5e9b58";
    sha256 = "16xj5fldwl639f0ys5rx54csbfvf35ja34bdl5m068hdn6dr47r5";
  };

  enableParallelBuilding = true;

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ stdenv.glibc.static ];

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

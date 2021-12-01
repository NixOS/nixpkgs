{ lib, stdenv, fetchFromGitHub, xz }:

stdenv.mkDerivation rec {
  pname = "pxz";
  version = "4.999.9beta+git";

  src = fetchFromGitHub {
    owner = "jnovy";
    repo = "pxz";
    rev = "124382a6d0832b13b7c091f72264f8f3f463070a";
    sha256 = "15mmv832iqsqwigidvwnf0nyivxf0y8m22j2szy4h0xr76x4z21m";
  };

  buildInputs = [ xz ];

  buildPhase = ''
    gcc -o pxz pxz.c -llzma \
        -fopenmp -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -O2 \
        -DPXZ_BUILD_DATE=\"nixpkgs\" \
        -DXZ_BINARY=\"${xz.bin}/bin/xz\" \
        -DPXZ_VERSION=\"${version}\"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp pxz $out/bin
    cp pxz.1 $out/share/man/man1
  '';

  meta = with lib; {
    homepage = "https://jnovy.fedorapeople.org/pxz/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pashev ];
    description = "compression utility that runs LZMA compression of different parts on multiple cores simultaneously";
    longDescription = ''
      Parallel XZ is a compression utility that takes advantage of
      running LZMA compression of different parts of an input file on multiple
      cores and processors simultaneously. Its primary goal is to utilize all
      resources to speed up compression time with minimal possible influence
      on compression ratio
    '';
    platforms = with platforms; linux;
  };
}

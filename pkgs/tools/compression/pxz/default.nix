{ stdenv, fetchFromGitHub, xz, lzma }:

stdenv.mkDerivation rec {
  pname = "pxz";
  version = "4.999.9beta";

  src = fetchFromGitHub {
    owner = "jnovy";
    repo = "pxz";
    rev = "124382a6d0832b13b7c091f72264f8f3f463070a";
    sha256 = "15mmv832iqsqwigidvwnf0nyivxf0y8m22j2szy4h0xr76x4z21m";
  };

  buildInputs = [ lzma ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp pxz $out/bin
    cp pxz.1 $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    homepage = "https://jnovy.fedorapeople.org/pxz/";
    description = "Parallel LZMA compressor using liblzma";
    longDescription = "Parallel XZ is a compression utility that takes advantage of
      running LZMA compression of different parts of an input file on multiple
      cores and processors simultaneously. Its primary goal is to utilize all
      resources to speed up compression time with minimal possible influence
      on compression ratio";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pashev ];
    platforms = platforms.linux;
  };
}

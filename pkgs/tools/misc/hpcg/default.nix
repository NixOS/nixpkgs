{ lib, stdenv, fetchurl, mpi } :

stdenv.mkDerivation rec {
  pname = "hpcg";
  version = "3.1";

  src = fetchurl {
    url = "http://www.hpcg-benchmark.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "197lw2nwmzsmfsbvgvi8z7kj69n374kgfzzp8pkmk7mp2vkk991k";
  };

  dontConfigure = true;

  enableParallelBuilding = true;

  buildInputs = [ mpi ];

  makeFlags = [ "arch=Linux_MPI" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/hpcg

    cp bin/xhpcg $out/bin
    cp bin/hpcg.dat $out/share/hpcg
  '';

  meta = with lib; {
    description = "HPC conjugate gradient benchmark";
    homepage = "https://www.hpcg-benchmark.org";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    mainProgram = "xhpcg";
  };
}


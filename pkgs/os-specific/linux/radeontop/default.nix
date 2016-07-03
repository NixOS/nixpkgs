{ stdenv, fetchFromGitHub, pkgconfig, gettext, ncurses, libdrm, libpciaccess }:

stdenv.mkDerivation rec {
  name = "radeontop-${version}";
  version = "2016-07-03";

  src = fetchFromGitHub {
    sha256 = "0achjjhq1fnka8fvn78jbd7zjnra2wcalvr7k4lj3c28x15k1iv8";
    rev = "761ffe28696cdadc96c8cf302b58c9ef71a2eae1";
    repo = "radeontop";
    owner = "clbr";
  };

  buildInputs = [ ncurses libdrm libpciaccess ];
  nativeBuildInputs = [ pkgconfig gettext ];

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace getver.sh --replace ver=unknown ver=${version}
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Top-like tool for viewing AMD Radeon GPU utilization";
    longDescription = ''
      View GPU utilization, both for the total activity percent and individual
      blocks. Supports R600 and later cards: even Southern Islands should work.
      Works with both the open drivers and AMD Catalyst. Total GPU utilization
      is also valid for OpenCL loads; the other blocks are only useful for GL
      loads. Requires root rights or other permissions to read /dev/mem.
    '';
    homepage = https://github.com/clbr/radeontop;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ rycee nckx ];
  };
}

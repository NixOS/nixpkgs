{ stdenv, fetchFromGitHub, pkgconfig, gettext, ncurses, libdrm, libpciaccess }:

let version = "v0.8-8-g2499679"; in
stdenv.mkDerivation {
  name = "radeontop-${version}";

  src = fetchFromGitHub {
    sha256 = "112zf6ms0qpmr9h3l4lg5wik5j206mgij0nypba5lnqzksxh2f88";
    rev = "2499679fda60c3f6239886296fd2a74155f45f77";
    repo = "radeontop";
    owner = "clbr";
  };

  buildInputs = [ pkgconfig gettext ncurses libdrm libpciaccess ];

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace getver.sh --replace ver=unknown ver=${version}
  '';

  makeFlags = "PREFIX=$(out)";

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

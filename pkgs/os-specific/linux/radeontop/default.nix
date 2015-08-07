{ stdenv, fetchFromGitHub, pkgconfig, gettext, ncurses, libdrm, libpciaccess }:

let version = "2015-08-06"; in
stdenv.mkDerivation {
  name = "radeontop-${version}";

  src = fetchFromGitHub {
    sha256 = "01s0j28lk66wb46qymkk1nyk91iv22y3m56z4lqd16yaxmhl0v2f";
    rev = "93c8ff2f07da8d4c204ee4872aed7eec834ff57d";
    repo = "radeontop";
    owner = "clbr";
  };

  buildInputs = [ ncurses libdrm libpciaccess ];
  nativeBuildInputs = [ pkgconfig gettext ];

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

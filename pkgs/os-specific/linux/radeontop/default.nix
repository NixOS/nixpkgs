{ stdenv, fetchFromGitHub, pkgconfig, gettext, ncurses, libdrm, libpciaccess }:

let version = "2015-06-24"; in
stdenv.mkDerivation {
  name = "radeontop-${version}";

  src = fetchFromGitHub {
    sha256 = "06cn7lixxx94c1fki0plg9f4rdy459mgi9yl80m0k1a20jqykz2a";
    rev = "976cae0be0ffb9142d5e63e435960c6b2bb0eb34";
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

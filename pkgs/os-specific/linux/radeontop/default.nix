{ stdenv, fetchgit, pkgconfig, gettext, ncurses, libdrm, libpciaccess }:

stdenv.mkDerivation rec {
  name = "radeontop-${version}";
  version = "v0.8-8-g575a416";

  src = fetchgit {
    url = git://github.com/clbr/radeontop.git;
    rev = "575a416596dbedb25bc6f3f0b16a0e2296fbb9bb";
    sha256 = "6100a7159384cfcd71e59ef7096450e975d01786ee4e3a7cf9c0e56045c4ac91";
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

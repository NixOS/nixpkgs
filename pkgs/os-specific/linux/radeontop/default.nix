{ stdenv, fetchgit, gettext, libdrm, ncurses, pkgconfig, xlibs }:

stdenv.mkDerivation rec {
  version = "0.8-6-g5ddd37b";
  name = "radeontop-${version}";

  src = fetchgit {
    url = git://github.com/clbr/radeontop.git;
    rev = "5ddd37bee0476ebf51e9f58edf814c366339d8a6";
    sha256 = "6fabfe17ab5968a32aeeffac0891ba6dd65245705e3657019ff28728cfdb605b";
  };

  buildInputs = [ gettext libdrm ncurses pkgconfig xlibs.libpciaccess ];

  makeFlagsArray = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Monitor utilization of AMD Radeon R600 and later GPUs";
    longDescription = ''
      View GPU utilization, both for the total activity percent and individual
      blocks. Supports R600 and later cards: even Southern Islands should work.
      Works with both the open drivers and AMD Catalyst. Total GPU utilization
      is also valid for OpenCL loads; the other blocks are only useful for GL
      loads. Requires root rights or other permissions to /dev/mem.
    '';
    homepage = https://github.com/clbr/radeontop;
    license = with licenses; gpl3;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}

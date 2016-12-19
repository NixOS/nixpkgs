{ stdenv, fetchFromGitHub, pkgconfig, gettext, makeWrapper
, ncurses, libdrm, libpciaccess, libxcb }:

stdenv.mkDerivation rec {
  name = "radeontop-${version}";
  version = "2016-07-04";

  src = fetchFromGitHub {
    sha256 = "07pj5c3shnxljwq0hkksw7qnp8kb3n5ngihdmi4fqbmyz8in2vm5";
    rev = "bb3ed18aa8877f2816348ca9f016bb61d67e636f";
    repo = "radeontop";
    owner = "clbr";
  };

  buildInputs = [ ncurses libdrm libpciaccess libxcb ];
  nativeBuildInputs = [ pkgconfig gettext makeWrapper ];

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace getver.sh --replace ver=unknown ver=${version}
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/sbin/radeontop \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

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

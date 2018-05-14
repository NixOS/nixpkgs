{ stdenv, fetchFromGitHub, pkgconfig, gettext, makeWrapper
, ncurses, libdrm, libpciaccess, libxcb }:

stdenv.mkDerivation rec {
  name = "radeontop-${version}";
  version = "2018-03-25";

  src = fetchFromGitHub {
    sha256 = "0s41xy9nrzxmimkdg23fr86rqcfiw6iqh99zpph0j990l8yzmv9b";
    rev = "v1.1";
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
    maintainers = with maintainers; [ rycee ];
  };
}

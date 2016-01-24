{ stdenv, fetchFromGitHub, pkgconfig, gettext, ncurses, libdrm, libpciaccess }:

stdenv.mkDerivation rec {
  name = "radeontop-${version}";
  version = "2015-11-24";

  src = fetchFromGitHub {
    sha256 = "0irwq6rps5mnban8cxbrm59wpyv4j80q3xdjm9fxvfpiyys2g2hz";
    rev = "0e82272f3e8f2287c1bc1d8a0c7bdbd5c4818b37";
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

{ lib, stdenv, fetchFromGitHub, pkg-config, gettext, makeWrapper
, ncurses, libdrm, libpciaccess, libxcb }:

stdenv.mkDerivation rec {
  pname = "radeontop";
  version = "1.4";

  src = fetchFromGitHub {
    sha256 = "0kwqddidr45s1blp0h8r8h1dd1p50l516yb6mb4s6zsc827xzgg3";
    rev = "v${version}";
    repo = "radeontop";
    owner = "clbr";
  };

  buildInputs = [ ncurses libdrm libpciaccess libxcb ];
  nativeBuildInputs = [ pkg-config gettext makeWrapper ];

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace getver.sh --replace ver=unknown ver=${version}
    substituteInPlace Makefile --replace pkg-config "$PKG_CONFIG"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/radeontop \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = with lib; {
    description = "Top-like tool for viewing AMD Radeon GPU utilization";
    mainProgram = "radeontop";
    longDescription = ''
      View GPU utilization, both for the total activity percent and individual
      blocks. Supports R600 and later cards: even Southern Islands should work.
      Works with both the open drivers and AMD Catalyst. Total GPU utilization
      is also valid for OpenCL loads; the other blocks are only useful for GL
      loads.
    '';
    homepage = "https://github.com/clbr/radeontop";
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}

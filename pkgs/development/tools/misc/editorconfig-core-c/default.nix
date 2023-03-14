{ lib, stdenv, fetchpatch, fetchFromGitHub, cmake, pcre2, doxygen }:

stdenv.mkDerivation rec {
  pname = "editorconfig-core-c";
  version = "0.12.5";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "editorconfig";
    repo = "editorconfig-core-c";
    rev = "v${version}";
    sha256 = "sha256-4p8bomeXtA+zJ3IvWW0UZixdMnjYWYu7yeA6JUwwRb8=";
    fetchSubmodules = true;
  };

  patches = [
    # Fox broken paths in pkg-config.
    # https://github.com/editorconfig/editorconfig-core-c/pull/81
    (fetchpatch {
      url = "https://github.com/editorconfig/editorconfig-core-c/commit/e0ead79d3bb4179fe9bccd3e5598ed47cc0863a3.patch";
      sha256 = "t/DiPVyyYoMwFpNG6sD+rLWHheFCbMaILXyey6inGdc=";
    })
  ];

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  buildInputs = [
    pcre2
  ];

  # Multiple doxygen can not generate man pages in the same base directory in
  # parallel: https://github.com/doxygen/doxygen/issues/6293
  enableParallelBuilding = false;

  meta = with lib; {
    homepage = "https://editorconfig.org/";
    description = "EditorConfig core library written in C";
    longDescription = ''
      EditorConfig makes it easy to maintain the correct coding style when
      switching between different text editors and between different
      projects. The EditorConfig project maintains a file format and plugins
      for various text editors which allow this file format to be read and used
      by those editors. For information on the file format and supported text
      editors, see the EditorConfig website.
    '';
    downloadPage = "https://github.com/editorconfig/editorconfig-core-c";
    license = with licenses; [ bsd2 bsd3 ];
    maintainers = with maintainers; [ dochang ];
    platforms = platforms.unix;
    mainProgram = "editorconfig";
  };
}

{ lib, stdenv, fetchgit, cmake, pcre, doxygen }:

stdenv.mkDerivation rec {
  pname = "editorconfig-core-c";
  version = "0.12.1";

  src = fetchgit {
    url = "https://github.com/editorconfig/editorconfig-core-c.git";
    rev = "v${version}";
    sha256 = "0awpb63ci85kal3pnlj2b54bay8igj1rbc13d8gqkvidlb51nnx4";
    fetchSubmodules = true;
  };

  buildInputs = [ pcre ];
  nativeBuildInputs = [ cmake doxygen ];

  # Multiple doxygen can not generate man pages in the same base directory in
  # parallel: https://bugzilla.gnome.org/show_bug.cgi?id=791153
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

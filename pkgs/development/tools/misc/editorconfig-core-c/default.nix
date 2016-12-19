{ stdenv, fetchgit, cmake, pcre, doxygen }:

stdenv.mkDerivation rec {

  name = "editorconfig-core-c-${meta.version}";

  src = fetchgit {
    url = "https://github.com/editorconfig/editorconfig-core-c.git";
    rev = "d1c2c881158dfb9faa4498a0b19593dcd105d6b8";
    fetchSubmodules = true;
    sha256 = "0awpb63ci85kal3pnlj2b54bay8igj1rbc13d8gqkvidlb51nnx4";
    inherit name;
  };

  buildInputs = [ cmake pcre doxygen ];

  meta = with stdenv.lib; {
    homepage = "http://editorconfig.org/";
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
    version = "0.12.1";
    maintainers = [ maintainers.dochang ];
    platforms = platforms.unix;
  };

}

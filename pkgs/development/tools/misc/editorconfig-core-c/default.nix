{ stdenv, fetchgit, cmake, pcre, doxygen }:

stdenv.mkDerivation rec {

  name = "editorconfig-core-c-${meta.version}";

  src = fetchgit {
    url = "https://github.com/editorconfig/editorconfig-core-c.git";
    rev = "99d09270c58b817ea218979d513a90099ade6277";
    fetchSubmodules = true;
    sha256 = "0s35dzf2180205xq2xpfmmlfw112j3h87swnisza85qwwz8bf2k9";
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
    version = "0.12.0";
    maintainers = [ maintainers.dochang ];
  };

}

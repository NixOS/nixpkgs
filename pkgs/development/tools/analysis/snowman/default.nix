{ lib, mkDerivation, fetchFromGitHub, cmake, boost, qtbase }:

mkDerivation rec {
  pname = "snowman";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "yegord";
    repo = "snowman";
    rev = "v${version}";
    sha256 = "1mrmhj2nddi0d47c266vsg5vbapbqbcpj5ld4v1qcwnnk6z2zn0j";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost qtbase ];

  postUnpack = ''
    export sourceRoot=$sourceRoot/src
  '';

  meta = with lib; {
    description = "Native code to C/C++ decompiler";
    homepage = "http://derevenets.com/";

    # https://github.com/yegord/snowman/blob/master/doc/licenses.asciidoc
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}

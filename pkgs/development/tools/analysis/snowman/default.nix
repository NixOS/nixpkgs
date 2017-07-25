{ stdenv, fetchFromGitHub, cmake, boost, qt4 ? null, qtbase ? null }:

# Only one qt
assert qt4 != null -> qtbase == null;
assert qtbase != null -> qt4 == null;

stdenv.mkDerivation rec {
  name = "snowman-${version}";
  version = "2017-07-22";

  src = fetchFromGitHub {
    owner = "yegord";
    repo = "snowman";
    rev = "6c4d9cceb56bf2fd0f650313131a2240579d1bea";
    sha256 = "1d0abh0fg637jksk7nl4yl54b4cadinj93qqvsm138zyx7h57xqf";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost qt4 qtbase ];

  postUnpack = ''
    export sourceRoot=$sourceRoot/src
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Native code to C/C++ decompiler";
    homepage = "http://derevenets.com/";

    # https://github.com/yegord/snowman/blob/master/doc/licenses.asciidoc
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

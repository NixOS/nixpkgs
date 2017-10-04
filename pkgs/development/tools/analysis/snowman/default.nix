{ stdenv, fetchFromGitHub, cmake, boost, qt4 ? null, qtbase ? null }:

# Only one qt
assert qt4 != null -> qtbase == null;
assert qtbase != null -> qt4 == null;

stdenv.mkDerivation rec {
  name = "snowman-${version}";
  version = "2017-08-13";

  src = fetchFromGitHub {
    owner = "yegord";
    repo = "snowman";
    rev = "cd9edcddf873fc40d7bcb1bb1eae815faedd3a03";
    sha256 = "10f3kd5m5xw7hqh92ba7dcczwbznxvk1qxg0yycqz7y9mfr2282n";
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

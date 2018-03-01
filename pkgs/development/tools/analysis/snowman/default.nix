{ stdenv, fetchFromGitHub, cmake, boost, qtbase }:

stdenv.mkDerivation rec {
  name = "snowman-${version}";
  version = "2017-11-19";

  src = fetchFromGitHub {
    owner = "yegord";
    repo = "snowman";
    rev = "d03c2d6ffbf262c0011584df59d6bd69c020e08e";
    sha256 = "0bzqp3zc100dzvybf57bj4dvnybvds0lmn1w2xjb19wkzm9liskn";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost qtbase ];

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

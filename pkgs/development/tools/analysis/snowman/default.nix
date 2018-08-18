{ stdenv, fetchFromGitHub, cmake, boost, qtbase }:

stdenv.mkDerivation rec {
  name = "snowman-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "yegord";
    repo = "snowman";
    rev = "v${version}";
    sha256 = "1ry14n8jydg6rzl52gyn0qhmv6bvivk7iwssp89lq5qk8k183x3k";
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

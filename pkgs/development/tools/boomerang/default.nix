{ stdenv, fetchFromGitHub, cmake, qtbase }:

stdenv.mkDerivation rec {
  pname = "boomerang";
  version = "0.4.0-alpha-2018-07-03";

  src = fetchFromGitHub {
    owner = "ceeac";
    repo = "boomerang";
    rev = "377ff2d7db93d892c925e2d3e61aef818371ce7d";
    sha256 = "1ljbyj3b8xckr1wihyii3h576zgq0q88vli0ylpr3p4jxy5sm57j";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase ];

  postPatch =
  # Look in installation directory for required files, not relative to working directory
  ''
    substituteInPlace src/boomerang/core/Settings.cpp \
      --replace "setDataDirectory(\"../share/boomerang\");" \
                "setDataDirectory(\"$out/share/boomerang\");" \
      --replace "setPluginDirectory(\"../lib/boomerang/plugins\");" \
                "setPluginDirectory(\"$out/lib/boomerang/plugins\");"
  ''
  # Fixup version:
  # * don't try to inspect with git
  #   (even if we kept .git and such it would be "dirty" because of patching)
  # * use date so version is monotonically increasing moving forward
  + ''
    sed -i cmake-scripts/boomerang-version.cmake \
      -e 's/set(\(PROJECT\|BOOMERANG\)_VERSION ".*")/set(\1_VERSION "${version}")/'
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://boomerang.sourceforge.net/;
    license = licenses.bsd3;
    description = "A general, open source, retargetable decompiler";
    maintainers = with maintainers; [ dtzWill ];
  };
}

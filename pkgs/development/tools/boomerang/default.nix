{ stdenv, fetchFromGitHub, cmake, qtbase, capstone, bison, flex }:

stdenv.mkDerivation rec {
  pname = "boomerang";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "BoomerangDecompiler";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "1q8qg506c39fidihqs8rbmqlr7bgkayyp5sscszgahs34cyvqic7";
  };

  nativeBuildInputs = [ cmake bison flex ];
  buildInputs = [ qtbase capstone ];

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

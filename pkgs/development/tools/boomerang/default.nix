{ stdenv, fetchFromGitHub, cmake, qtbase }:

stdenv.mkDerivation rec {
  name = "boomerang-${version}";
  version = "0.4.0-alpha-2018-01-18";

  src = fetchFromGitHub {
    owner = "ceeac";
    repo = "boomerang";
    rev = "b4ff8d573407a8ed6365d4bfe53d2d47d983e393";
    sha256 = "0x17vlm6y1paa49fi3pmzz7vzdqms19qkr274hkq32ql342b6i6x";
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

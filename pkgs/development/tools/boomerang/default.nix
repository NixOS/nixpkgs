{ stdenv, fetchgit, cmake, expat, qt5, boost }:

stdenv.mkDerivation rec {
  name = "boomerang-${version}";
  version = "0.3.99-alpha-2016-11-02";

  src = fetchgit {
    url = "https://github.com/nemerle/boomerang.git";
    rev = "f95d6436845e9036c8cfbd936731449475f79b7a";
    sha256 = "1q3q92lfj24ij5sxdbdhcqyan28r6db1w80yrks4csf9zjij1ixh";
  };

  buildInputs = [ cmake expat qt5.qtbase boost ];

  patches = [ ./fix-install.patch ./fix-output.patch ];

  postPatch = ''
    substituteInPlace loader/BinaryFileFactory.cpp \
      --replace '"lib"' '"../lib"'

    substituteInPlace ui/DecompilerThread.cpp \
      --replace '"output"' '"./output"'

    substituteInPlace boomerang.cpp \
      --replace 'progPath("./")' "progPath(\"$out/share/boomerang/\")"

    substituteInPlace ui/commandlinedriver.cpp \
      --replace "QFileInfo(args[0]).absolutePath()" "\"$out/share/boomerang/\""
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://boomerang.sourceforge.net/;
    license = stdenv.lib.licenses.bsd3;
    description = "A general, open source, retargetable decompiler";
  };
}

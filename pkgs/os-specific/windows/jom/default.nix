{ stdenv, fetchgit, qt48, qmake4Hook, flex }:

# At the time of committing this, the expression fails for me to cross-build in
# both mingw32 and mingw64.

stdenv.mkDerivation {
  name = "jom-1.0.11";

  src = fetchgit {
    url = git://gitorious.org/qt-labs/jom.git;
    rev = "c91a204b05f97eef3c73aaaba3036e20f79fd487";
    sha256 = "6d3ac84f83bb045213903d9d5340c0447c8fe41671d1dcdeae5c40b66d62ccbf";
  };

  buildInputs = [ qt48 ];
  nativeBuildInputs = [ flex qmake4Hook ];

  QTDIR = qt48;
  
  crossAttrs = {
    # cmakeFlags = "-DWIN32=1 -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_RC_COMPILER=${stdenv.cross.config}-windres";
    QTDIR = qt48.crossDrv;
    preBuild = ''
      export NIX_CROSS_CFLAGS_COMPILE=-fpermissive
    '';
  };

  meta = {
    homepage = http://qt-project.org/wiki/jom;
    description = "Clone of nmake supporting multiple independent commands in parallel";
    license = stdenv.lib.licenses.gpl2Plus; # Explicitly, GPLv2 or GPLv3, but not later.
  };
}

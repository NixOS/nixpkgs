{
  lib,
  stdenv,
  binutils-unwrapped-all-targets,
}:

stdenv.mkDerivation {
  pname = "libopcodes";
  inherit (binutils-unwrapped-all-targets) version;

  dontUnpack = true;
  dontBuild = true;
  dontInstall = true;
  propagatedBuildInputs = [
    binutils-unwrapped-all-targets.dev
    binutils-unwrapped-all-targets.lib
  ];

  passthru = {
    inherit (binutils-unwrapped-all-targets) dev;
  };

  meta = with lib; {
    description = "Library from binutils for manipulating machine code";
    homepage = "https://www.gnu.org/software/binutils/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericson2314 ];
    platforms = platforms.unix;
  };
}

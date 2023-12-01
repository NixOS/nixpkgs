{ stdenv, file, lib, fetchFromGitHub, autoreconfHook, bison, flex, pkg-config
, pythonSupport ? false, swig ? null, python ? null}:

stdenv.mkDerivation rec {
  pname = "libnl";
  version = "3.7.0";

  src = fetchFromGitHub {
    repo = "libnl";
    owner = "thom311";
    rev = "libnl${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-Ty9NdWKWB29MTRfG5OJlSE0mSTN3Wy+sR4KtuExXcB4=";
  };

  outputs = [ "bin" "dev" "out" "man" ] ++ lib.optional pythonSupport "py";

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook bison flex pkg-config file ]
    ++ lib.optional pythonSupport swig;

  postBuild = lib.optionalString (pythonSupport) ''
      cd python
      ${python.pythonOnBuildForHost.interpreter} setup.py install --prefix=../pythonlib
      cd -
  '';

  postFixup = lib.optionalString pythonSupport ''
    mv "pythonlib/" "$py"
  '';

  passthru = {
    inherit pythonSupport;
  };

  meta = with lib; {
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux Netlink interface library suite";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}

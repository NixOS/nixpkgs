{ stdenv
, file
, lib
, fetchFromGitHub
, autoreconfHook
, bison
, flex
, pkg-config
, doxygen
, graphviz
, mscgen
, asciidoc
, sourceHighlight
, pythonSupport ? false
, swig ? null
, python ? null
}:

stdenv.mkDerivation rec {
  pname = "libnl";
  version = "3.10.0";

  src = fetchFromGitHub {
    repo = "libnl";
    owner = "thom311";
    rev = "libnl${lib.replaceStrings ["."] ["_"] version}";
    hash = "sha256-QwDn7S9lyU+/Pc9daqy1qDZFU03dUQF5PDqFEn03WWc=";
  };

  outputs = [ "bin" "dev" "out" "man" ] ++ lib.optional pythonSupport "py";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
    file
    doxygen
    graphviz
    mscgen
    asciidoc
    sourceHighlight
  ] ++ lib.optional pythonSupport swig;

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

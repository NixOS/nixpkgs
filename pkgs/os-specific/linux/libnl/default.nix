{ stdenv, file, lib, fetchFromGitHub, autoreconfHook, bison, flex, pkgconfig
, pythonSupport ? false, swig ? null, python}:

stdenv.mkDerivation rec {
  pname = "libnl";
  version = "3.5.0";

  src = fetchFromGitHub {
    repo = "libnl";
    owner = "thom311";
    rev = "libnl${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "1ak30jcx52gl5yz1691qq0b76ldbcp2z6vsvdr2mrrwqiplqbcs2";
  };

  outputs = [ "bin" "dev" "out" "man" ] ++ lib.optional pythonSupport "py";

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook bison flex pkgconfig file ]
    ++ lib.optional pythonSupport swig;

  postBuild = lib.optionalString (pythonSupport) ''
      cd python
      ${python}/bin/python setup.py install --prefix=../pythonlib
      cd -
  '';

  postFixup = lib.optionalString pythonSupport ''
    mv "pythonlib/" "$py"
  '';

  passthru = {
    inherit pythonSupport;
  };

  meta = with lib; {
    inherit version;
    homepage = http://www.infradead.org/~tgr/libnl/;
    description = "Linux Netlink interface library suite";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}

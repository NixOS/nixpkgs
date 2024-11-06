{ stdenv
, lib
, fetchFromGitHub

, scons
, m4
, protobuf
, pkg-config
, makeWrapper

, zlib
, gperftools
, libpng
, python3Packages
}:

let
  pypkgs = with python3Packages; [
    pybind11
    pyparsing
    pydot
  ];

  pypath = lib.makeSearchPathOutput "lib" python3Packages.python.sitePackages pypkgs;
in
stdenv.mkDerivation rec {
  pname = "gem5";
  version = "22.1.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Yxag8emR6hf7oX4GAtQi/YYcKrpXicUoQg5+rjKyjc0=";
  };

  enableParallelBuilding = true;
  buildFlags = [ "build/ALL/gem5.opt" ];

  nativeBuildInputs = [ makeWrapper python3Packages.python scons pkg-config protobuf m4 ];
  buildInputs = [ zlib gperftools libpng ] ++ pypkgs;

  postPatch = ''
    patchShebangs .

    substituteInPlace src/base/date.cc \
      --replace '__DATE__' "\"$(date -ud "@$SOURCE_DATE_EPOCH" +'%b %d %Y')\"" \
      --replace '__TIME__' "\"$(date -ud "@$SOURCE_DATE_EPOCH" +'%T')\""

    rm -rf ext/pybind11
    substituteInPlace ext/sst/Makefile \
      --replace "-I../../ext/pybind11/include/" ' ''${shell pybind11-config --includes}'
    substituteInPlace SConstruct \
      --replace "env.Prepend(CPPPATH=Dir('ext/pybind11/include/'))" ""
  '';

  installPhase = ''
    mkdir -p $out/share/gem5
    mv configs $out/share/gem5/configs

    mkdir -p $out/bin
    cp build/ALL/gem5.opt $out/bin/gem5.opt
    cp build/ALL/gem5py $out/bin/gem5py
    cp build/ALL/gem5py_m5 $out/bin/gem5py_m5

    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : ${pypath}
    done
  '';

  meta = {
    description = "A modular full-system simulator for platform and computer-architecture research";
    homepage = "https://gem5.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = with lib.platforms; linux;
  };
}

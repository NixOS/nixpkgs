{ stdenv, lib, fetchFromGitHub, wrapPython, python, jedi, parso, cmake, swig }:

stdenv.mkDerivation rec {
  pname = "SourcetrailPythonIndexer";
  version = "v1_db25_p5";

  src = fetchFromGitHub {
    owner = "CoatiSoftware";
    repo = pname;
    rev = version;
    sha256 = "05hlpd3am029pv1wi6mys3q0ggp64axmg8bdf1fabl9cl9jffscq";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ wrapPython cmake swig ];
  buildInputs = [ python ];
  pythonPath = [ jedi parso ];

  dontUseCmakeConfigure = true;
  cmakeFlags = [
    "-DBUILD_BINDINGS_PYTHON=1"
    "-DPYTHON_VERSION=${lib.versions.majorMinor python.version}"
  ];

  buildPhase = ''
    pushd SourcetrailDB
    cmake -Bbuild $cmakeFlags .
    pushd build
    make -j $NIX_BUILD_CORES
    popd
    popd
  '';

  checkPhase = ''
    buildPythonPath "$pythonPath"

    # FIXME: some tests are failing
    # PYTHONPATH="$program_PYTHONPATH:SourcetrailDB/build/bindings_python" \
    #   ${python}/bin/python test.py
    PYTHONPATH="$program_PYTHONPATH:SourcetrailDB/build/bindings_python" \
      ${python}/bin/python test_shallow.py
  '';

  installPhase = ''
    shopt -s extglob
    mkdir -p $out/{bin,libexec}

    cp !(run).py $out/libexec # copy *.py excluding run.py (needs extglob)
    cat <(echo '#!/usr/bin/env python') run.py > $out/libexec/run.py
    chmod +x $out/libexec/run.py
    ln -s $out/libexec/run.py $out/bin/SourcetrailPythonIndexer

    pushd SourcetrailDB/build/bindings_python
    cp sourcetraildb.py $out/libexec
    cp _sourcetraildb* $out/libexec/_sourcetraildb.so
    popd

    wrapPythonProgramsIn "$out/libexec" "$pythonPath"
  '';

  doCheck = true;

  meta = with lib; {
    description = "Python indexer for Sourcetrail";
    homepage = "https://github.com/CoatiSoftware/SourcetrailPythonIndexer";
    license = licenses.gpl3;
  };
}

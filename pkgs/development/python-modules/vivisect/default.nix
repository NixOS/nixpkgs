{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, pyasn1
, pyasn1-modules
, cxxfilt
, msgpack
, pycparser
}:
buildPythonPackage rec {
  pname = "vivisect";
  version = "0.2.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fc4d2097a1d0d8d97aa8c540984cb52432df759f04f2281a21a4e1b7d1a95a7";
  };

  propagatedBuildInputs = [
    pyasn1
    pyasn1-modules
    cxxfilt
    msgpack
    pycparser
  ];

  preBuild = ''
    sed "s@==.*'@'@" -i setup.py
  '';

  # requires another repo for test files
  doCheck = false;

  pythonImportsCheck = [
    "vivisect"
  ];

  meta = with lib; {
    description = "Pure python disassembler, debugger, emulator, and static analysis framework";
    homepage = "https://github.com/vivisect/vivisect";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}

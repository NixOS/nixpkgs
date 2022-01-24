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
  version = "1.0.5";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f629dc0143656b06b64e2da1772deda67d37a3e048e74bd728de4a4f24bf877b";
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

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
  version = "1.0.4";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd47b2cf5874cd2f74e6c36b8a97bf301785bacf9ac0297bbe78ec1b8c86c755";
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

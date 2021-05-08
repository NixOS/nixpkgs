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
  version = "0.1.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed5e8c24684841d30dc7b41f2bee87c0198816a453417ae2e130b7845ccb2629";
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

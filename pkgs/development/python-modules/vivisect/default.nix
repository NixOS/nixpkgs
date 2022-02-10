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
  version = "1.0.7";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "727a27ac1eb95d5a41f4430f6912e79940525551314fe68a2811fc9d51eaf2e9";
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

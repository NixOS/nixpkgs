{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, six
, pyyaml
, rdflib
, ply
, xmltodict
, pytestCheckHook
, pythonAtLeast
}:
buildPythonPackage rec {
  pname = "spdx-tools";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a1aaae051771e865705dd2fd374c3f73d0ad595c1056548466997551cbd7a81";
  };

  patches = lib.optionals (pythonAtLeast "3.9") [
    # https://github.com/spdx/tools-python/pull/159
    # fixes tests on Python 3.9
    (fetchpatch {
      name = "drop-encoding-argument.patch";
      url = "https://github.com/spdx/tools-python/commit/6c8b9a852f8a787122c0e2492126ee8aa52acff0.patch";
      sha256 = "RhvLhexsQRjqYqJg10SAM53RsOW+R93G+mns8C9g5E8=";
    })
  ];

  propagatedBuildInputs = [
    six
    pyyaml
    rdflib
    ply
    xmltodict
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "spdx"
  ];

  meta = with lib; {
    description = "SPDX parser and tools";
    homepage = "https://github.com/spdx/tools-python";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}

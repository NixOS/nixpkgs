{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, setuptools-scm
, attrs
, packaging
, pyparsing
, semantic-version
, semver
, commoncode
, pytestCheckHook
, saneyaml
}:

buildPythonPackage rec {
  pname = "univers";
  version = "30.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yM0SDBpkiZEbaZ0ugjiMwwUFKqZGbmh1JNlv5qvPAYo=";
  };

  patches = [
    # Make tests work when not using virtualenv, can be dropped with the next version
    # Upstream PR (already merged): https://github.com/nexB/univers/pull/77
    (fetchpatch {
      url = "https://github.com/nexB/univers/commit/b74229cc1c8790287633cd7220d6b2e97c508302.patch";
      sha256 = "sha256-i6zWv9rAlwCMghd9g5FP6WIQLLDLYvp+6qJ1E7nfTSY=";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ attrs packaging pyparsing semantic-version semver ];
  nativeCheckInputs = [ commoncode pytestCheckHook saneyaml ];

  dontConfigure = true; # ./configure tries to setup virtualenv and downloads dependencies

  disabledTests = [ "test_codestyle" ];

  pythonImportsCheck = [ "univers" ];

  meta = with lib; {
    description = "Library for parsing version ranges and expressions";
    homepage = "https://github.com/nexB/univers";
    license = with licenses; [ asl20 bsd3 mit ];
    maintainers = with maintainers; [ armijnhemel sbruder ];
  };
}

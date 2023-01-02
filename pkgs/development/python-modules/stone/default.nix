{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, ply
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "stone";
  version = "3.3.1";

  # pypi sdist misses requirements.txt
  src = fetchFromGitHub {
    owner = "dropbox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0FWdYbv+paVU3Wj6g9OrSNUB0pH8fLwTkhVIBPeFB/U=";
  };

  postPatch = ''
    sed -i '/pytest-runner/d' setup.py
  '';

  propagatedBuildInputs = [ ply six ];

  checkInputs = [ pytestCheckHook mock ];

  # try to import from `test` directory, which is exported by the python interpreter
  # and cannot be overridden without removing some py3 to py2 support
  disabledTestPaths = [
    "test/test_tsd_types.py"
    "test/test_js_client.py"
  ];
  disabledTests = [
    "test_type_name_with_module"
  ];

  pythonImportsCheck = [ "stone" ];

  meta = with lib; {
    description = "Official Api Spec Language for Dropbox";
    homepage = "https://github.com/dropbox/stone";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}

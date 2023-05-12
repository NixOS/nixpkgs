{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage {
  pname = "takethetime";
  version = "0.3.1";

  # pypi distribution doesn't include tests, so build from source instead
  src = fetchFromGitHub {
    owner = "ErikBjare";
    repo = "TakeTheTime";
    rev = "b0042ac5b1cc9d3b70ef59167b094469ceb660dd";
    sha256 = "sha256-DwsMnP6G3BzOnINttaSC6QKkIKK5qyhUz+lN1DSvkw0=";
  };

  disabled = pythonOlder "3.6";

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/tests.py" ];

  pythonImportsCheck = [ "takethetime" ];

  # Latest release is v0.3.1 on pypi, but this version was not bumped in
  # the setup.py, causing packages that depend on v0.3.1 to fail to build.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "version='0.3'" "version='0.3.1'"
  '';

  meta = with lib; {
    description = "Simple time taking library using context managers";
    homepage = "https://github.com/ErikBjare/TakeTheTime";
    maintainers = with maintainers; [ huantian ];
    license = licenses.mit;
  };
}

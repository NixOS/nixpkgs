{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "supervisor";
  version = "4.2.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NHYbrhojxYGSKBpRFfsH+/IsmwEzwIFmvv/HD+0+vBI=";
  };

  patches = [
    # adapted from 49b74cafb6e72e0e620e321711c1b81a0823be12
    ./fix-python313-unittest.patch
    # Fix SubprocessTests.test_getProcessStateDescription on python 3.13
    (fetchpatch {
      url = "https://github.com/Supervisor/supervisor/commit/27efcd59b454e4f3a81e5e1b02ab0d8d0ff2f45f.patch";
      hash = "sha256-9KNcdRJwnZJA00dDy/mAS7RJuBei60YzVhWkeQgmJ8c=";
    })
  ];

  propagatedBuildInputs = [ setuptools ];

  # wants to write to /tmp/foo which is likely already owned by another
  # nixbld user on hydra
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "supervisor" ];

  meta = with lib; {
    description = "System for controlling process state under UNIX";
    homepage = "https://supervisord.org/";
    changelog = "https://github.com/Supervisor/supervisor/blob/${version}/CHANGES.rst";
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with maintainers; [ zimbatm ];
  };
}

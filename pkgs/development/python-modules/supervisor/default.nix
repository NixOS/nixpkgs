{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
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
    homepage = "http://supervisord.org/";
    changelog = "https://github.com/Supervisor/supervisor/blob/${version}/CHANGES.rst";
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with maintainers; [ zimbatm ];
  };
}

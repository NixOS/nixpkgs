{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "bashate";
  version = "2.1.1";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S6tul3+DBacgU1+Pk/H7QsUh/LxKbCs9PXZx9C8iH0w=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    babel
    pbr
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    fixtures
    mock
    stestr
    testtools
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "bashate" ];

  meta = with lib; {
    description = "Style enforcement for bash programs";
    mainProgram = "bashate";
    homepage = "https://opendev.org/openstack/bashate";
    license = with licenses; [ asl20 ];
    maintainers = teams.openstack.members ++ (with maintainers; [ fab ]);
  };
}

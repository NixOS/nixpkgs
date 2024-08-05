{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  sopel,
  requests,
}:

buildPythonPackage rec {
  pname = "sopel-help";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sopel-irc";
    repo = "sopel-help";
    rev = "refs/tags/${version}";
    hash = "sha256-JcL12pt3KAv3Jr7SNVjEB5d5fL6kNTYOX3EWu+V3Rgw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sopel
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sopel_help" ];

  meta = with lib; {
    description = "Simple and extensible IRC bot";
    homepage = "https://sopel.chat";
    license = licenses.efl20;
    maintainers = with maintainers; [ mog ];
  };
}

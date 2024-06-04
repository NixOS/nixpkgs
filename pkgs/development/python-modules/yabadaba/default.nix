{
  lib,
  buildPythonPackage,
  cdcs,
  datamodeldict,
  fetchFromGitHub,
  ipython,
  lxml,
  numpy,
  pandas,
  pymongo,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tqdm,
}:

buildPythonPackage rec {
  pname = "yabadaba";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "yabadaba";
    rev = "refs/tags/v${version}";
    hash = "sha256-NfvnUrTnOeNfiTMrcRtWU3a/Wb6qsDeQlk5jwZ1OpgI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cdcs
    datamodeldict
    ipython
    lxml
    numpy
    pandas
    pymongo
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yabadaba" ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  meta = with lib; {
    description = "Abstraction layer allowing for common interactions with databases and records";
    homepage = "https://github.com/usnistgov/yabadaba";
    changelog = "https://github.com/usnistgov/yabadaba/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  git, # shells out to git
  hatchling,
  importlib-resources,
  incremental,
  jinja2,
  mock,
  pytestCheckHook,
  pythonOlder,
  tomli,
  twisted,
}:

buildPythonPackage rec {
  pname = "towncrier";
  version = "23.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E5N8JH4/iuIKxE2JXPX5amCtRs/cwWcXWVMNeDfZ7l0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "hatchling ~= 1.17.1" "hatchling"
  '';

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs =
    [
      click
      incremental
      jinja2
    ]
    ++ lib.optionals (pythonOlder "3.10") [ importlib-resources ]
    ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs = [
    git
    mock
    twisted
    pytestCheckHook
  ];

  pythonImportsCheck = [ "towncrier" ];

  meta = with lib; {
    description = "Utility to produce useful, summarised news files";
    mainProgram = "towncrier";
    homepage = "https://github.com/twisted/towncrier/";
    changelog = "https://github.com/twisted/towncrier/blob/${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

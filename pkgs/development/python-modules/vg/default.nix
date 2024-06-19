{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  poetry-core,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "vg";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lace";
    repo = "vg";
    rev = "refs/tags/${version}";
    hash = "sha256-ZNUAfkhjmsxD8cH0fR8Htjs+/F/3R9xfe1XgRyndids=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'requires = ["setuptools", "poetry-core>=1.0.0"]' 'requires = ["poetry-core>=1.0.0"]'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "vg" ];

  meta = with lib; {
    description = "Linear algebra for humans: a very good vector-geometry and linear-algebra toolbelt";
    homepage = "https://github.com/lace/vg";
    changelog = "https://github.com/lace/vg/blob/${version}/CHANGELOG.md";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ clerie ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "single-version";
  version = "1.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hongquan";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dUmJhNCPuq/7WGzFQXLjb8JrQgQn7qyBqzPWaKzD9hc=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "single_version" ];

  meta = with lib; {
    description = "Utility to let you have a single source of version in your code base";
    homepage = "https://github.com/hongquan/single-version";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}

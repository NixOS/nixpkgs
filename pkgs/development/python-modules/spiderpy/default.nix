{
  lib,
  buildPythonPackage,
  isPy27,
  fetchFromGitHub,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "spiderpy";
  version = "1.7.2";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "peternijssen";
    repo = "spiderpy";
    rev = version;
    hash = "sha256-Yujy8HSMbK2DQ/913r2c74hKPYDfcHFKq04ysqxG+go=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ requests ];

  # tests don't mock remote resources
  doCheck = false;

  pythonImportsCheck = [ "spiderpy.spiderapi" ];

  meta = {
    description = "Unofficial Python wrapper for the Spider API";
    homepage = "https://www.github.com/peternijssen/spiderpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

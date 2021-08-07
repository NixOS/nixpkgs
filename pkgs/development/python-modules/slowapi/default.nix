{ lib
, buildPythonPackage
, fastapi
, fetchFromGitHub
, fetchpatch
, limits
, mock
, hiro
, poetry-core
, pytestCheckHook
, pythonOlder
, redis
, starlette
}:

buildPythonPackage rec {
  pname = "slowapi";
  version = "0.1.4";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "laurentS";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bnnzgv2wy145sdab54hljwv1b5029ndrr0y9rc2q0mraz8lf8lm";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    limits
    redis
  ];

  checkInputs = [
    fastapi
    hiro
    mock
    pytestCheckHook
    starlette
  ];

  patches = [
    # Switch to poetry-core, https://github.com/laurentS/slowapi/pull/54
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/laurentS/slowapi/commit/fe165f2d479f4f8e4b7dd9cd88ec0ae847b490c5.patch";
      sha256 = "16vjxdjjiyg8zjrgfyg9q2ym2lmnms2zy5d2cg3ccg51cfl715fi";
    })
  ];

  pythonImportsCheck = [ "slowapi" ];

  meta = with lib; {
    description = "Python library for API rate limiting";
    homepage = "https://github.com/laurentS/slowapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

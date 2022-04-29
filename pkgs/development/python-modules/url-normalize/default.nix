{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest-flakes
, pytest-mock
, pytest-socket
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "url-normalize";
  version = "1.4.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "niksite";
    repo = pname;
    rev = version;
    hash = "sha256-WE3MM9B/voI23taFbLp2FYhl0uxOfuUWsaCTBG1hyiY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytest-flakes
    pytest-mock
    pytest-socket
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/niksite/url-normalize/pull/28
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/niksite/url-normalize/commit/b8557b10c977b191cc9d37e6337afe874a24ad08.patch";
      sha256 = "sha256-SVCQATV9V6HbLmjOHs7V7eBagO0PuqZLubIJghBYfQQ=";
    })
  ];

  postPatch = ''
    sed -i "/--cov/d" tox.ini
    sed -i "/--flakes/d" tox.ini
  '';

  pythonImportsCheck = [
    "url_normalize"
  ];

  meta = with lib; {
    description = "URL normalization for Python";
    homepage = "https://github.com/niksite/url-normalize";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lib,
  mock,
  packaging,
  ply,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "stone";
  version = "3.3.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  patches = [
    # fix distutils issue
    # fix versions in tests to conform pep 440
    # See https://github.com/dropbox/stone/pull/334
    (fetchpatch {
      name = "no-distutils.patch";
      url = "https://github.com/dropbox/stone/commit/f772d8d3b7e2ce62b14b4fb208a478bc8e54c7f2.patch";
      hash = "sha256-SH4gG5S13n/pXppm62LvH9poGfeQGGonW7bkzdYh73Q=";
    })
    (fetchpatch {
      name = "fix-test-pep-440.patch";
      url = "https://github.com/dropbox/stone/commit/f36de56b1f87eae61829258b2f16aa8319bbcc5c.patch";
      hash = "sha256-sBJukNk02RmQQza1qhLAkyx1OJRck0/zQOeRaXD9tkY=";
    })
  ];

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "stone";
    rev = "refs/tags/v${version}";
    hash = "sha256-Og0hUUCCd9wRdHUhZBl62rDAunP2Bph5COsCw/T1kUA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner == 5.3.2'," ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    ply
    six
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "stone" ];

  meta = with lib; {
    description = "Official Api Spec Language for Dropbox";
    homepage = "https://github.com/dropbox/stone";
    changelog = "https://github.com/dropbox/stone/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
    mainProgram = "stone";
  };
}

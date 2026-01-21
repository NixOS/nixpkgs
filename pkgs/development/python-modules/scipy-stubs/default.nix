{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  uv-build,
  optype,
  scipy,
}:

buildPythonPackage rec {
  pname = "scipy-stubs";
  version = "1.17.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipy";
    repo = "scipy-stubs";
    tag = "v${version}";
    hash = "sha256-wzXRnTaSYOePt3XvZ/OeBOQCKObuCL1rWrVDo73yM1I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.0,<0.10.0" "uv_build"
  '';

  disabled = pythonOlder "3.11";

  build-system = [
    uv-build
  ];

  dependencies = [
    optype
  ];

  optional-dependencies = {
    scipy = [
      scipy
    ];
  };

  nativeCheckInputs = [
    scipy
  ];

  meta = {
    description = "Typing Stubs for SciPy";
    homepage = "https://github.com/scipy/scipy-stubs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jolars ];
  };
}

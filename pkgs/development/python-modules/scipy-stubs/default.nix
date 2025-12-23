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
  version = "1.16.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipy";
    repo = "scipy-stubs";
    tag = "v${version}";
    hash = "sha256-TLqLJirbOGIm718cLhWcEi4VHms9imIJZadGfYphXBk=";
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

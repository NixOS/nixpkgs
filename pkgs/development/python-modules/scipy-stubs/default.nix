{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  optype,
  scipy,
}:
buildPythonPackage (finalAttrs: {
  pname = "scipy-stubs";
  version = "1.18.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipy";
    repo = "scipy-stubs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-manM9kHSk7+iSytce0ZEwE2oN4KJYsc1JVh/1CPHNHI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.5,<0.13" "uv_build"
  '';

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
})

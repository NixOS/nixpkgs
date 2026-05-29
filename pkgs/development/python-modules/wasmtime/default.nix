{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pkgs,
  pycparser,
  pytestCheckHook,
  setuptools-git-versioning,
  setuptools,
  writableTmpDirAsHomeHook,
  stdenvNoCC,
}:
let
  inherit (stdenvNoCC) targetPlatform;
  systemDir = "${targetPlatform.parsed.kernel.name}-${targetPlatform.parsed.cpu.name}";
  libExt = targetPlatform.extensions.sharedLibrary;
in
buildPythonPackage (finalAttrs: {
  pname = "wasmtime";
  version = "44.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime-py";
    tag = finalAttrs.version;
    hash = "sha256-7K0j4jMsRB7/wNIj0pXxFTy0y7aN37wgCD1XKM92Ayw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-git-versioning>=2.0,<3" "setuptools-git-versioning" \
      --replace-fail 'build-backend = "backend"' 'build-backend = "setuptools.build_meta"'

    substituteInPlace ci/cbindgen.py \
      --replace-fail "'-D__builtin_va_list=int'," "'-D__builtin_va_list=int', '-Dnullptr_t=void*',"

    # Don't run mypy via pytest-mypy (type checking breaks easily)
    substituteInPlace pytest.ini \
      --replace-fail 'addopts = --doctest-modules --mypy' 'addopts = --doctest-modules'

    sed -i '/^backend-path = \[/,/^\]/d' pyproject.toml

    # Use nixpkgs' wasmtime instead of downloading prebuilt C API artifacts.
    mkdir -p wasmtime/${systemDir}
    ln -s ${lib.getLib pkgs.wasmtime}/lib/libwasmtime${libExt} wasmtime/${systemDir}/_libwasmtime${libExt}
  '';

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  buildInputs = [ pkgs.wasmtime ];

  postInstall = ''
    # Ensure the installed module can find the shared library at runtime
    mkdir -p "$out/${python.sitePackages}/wasmtime/${systemDir}"
    ln -sf ${lib.getLib pkgs.wasmtime}/lib/libwasmtime${libExt} "$out/${python.sitePackages}/wasmtime/${systemDir}/_libwasmtime${libExt}"
  '';

  nativeCheckInputs = [
    pycparser
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    "ci/cbindgen.py"
  ];

  pythonImportsCheck = [ "wasmtime" ];

  preCheck = ''
    # cbindgen.py checks bindings against C headers during test collection.
    ln -s ${lib.getDev pkgs.wasmtime}/include wasmtime/include
  '';

  meta = {
    description = "Python WebAssembly runtime powered by Wasmtime";
    homepage = "https://github.com/bytecodealliance/wasmtime-py";
    changelog = "https://github.com/bytecodealliance/wasmtime-py/releases/tag/${finalAttrs.src.tag}";
    license = [
      lib.licenses.asl20
      lib.licenses.llvm-exception
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})

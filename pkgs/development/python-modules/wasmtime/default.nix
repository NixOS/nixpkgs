{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pkgs,
  pycparser,
  pytest-mypy,
  pytestCheckHook,
  setuptools-git-versioning,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wasmtime";
  version = "45.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime-py";
    tag = finalAttrs.version;
    hash = "sha256-XlAWPJB34uE+hbEMGZ46Ll6kXP+/lZ2amTKdjslGrP4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-git-versioning>=2.0,<3" "setuptools-git-versioning" \
      --replace-fail 'build-backend = "backend"' 'build-backend = "setuptools.build_meta"'

    # `wasmtime/_{extern,types,value}.py` erroneously report unreachable statements
    substituteInPlace mypy.ini \
      --replace-fail "warn_unreachable = True" "warn_unreachable = False"

    sed -i '/^backend-path = \[/,/^\]/d' pyproject.toml

    # Use nixpkgs' wasmtime instead of downloading prebuilt C API artifacts.
    mkdir -p wasmtime/linux-x86_64 wasmtime/linux-aarch64
    ln -s ${lib.getLib pkgs.wasmtime}/lib/libwasmtime.so wasmtime/linux-x86_64/_libwasmtime.so
    ln -s ${lib.getLib pkgs.wasmtime}/lib/libwasmtime.so wasmtime/linux-aarch64/_libwasmtime.so
  '';

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  buildInputs = [ pkgs.wasmtime ];

  postInstall = ''
    # Ensure the installed module can find the shared library at runtime
    mkdir -p "$out/${python.sitePackages}/wasmtime/linux-x86_64"
    mkdir -p "$out/${python.sitePackages}/wasmtime/linux-aarch64"
    ln -sf ${lib.getLib pkgs.wasmtime}/lib/libwasmtime.so "$out/${python.sitePackages}/wasmtime/linux-x86_64/_libwasmtime.so"
    ln -sf ${lib.getLib pkgs.wasmtime}/lib/libwasmtime.so "$out/${python.sitePackages}/wasmtime/linux-aarch64/_libwasmtime.so"
  '';

  nativeCheckInputs = [
    pycparser
    pytest-mypy
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "wasmtime" ];

  preCheck = ''
    # cbindgen.py checks bindings against C headers during test collection.
    ln -s ${lib.getDev pkgs.wasmtime}/include wasmtime/include

    # hardening options interfere with pycparser's CC call
    export NIX_HARDENING_ENABLE=""

    # $out is first in path which causes "import file mismatch"
    export PYTHONPATH="$PWD:$PYTHONPATH"
  '';

  meta = {
    description = "Python WebAssembly runtime powered by Wasmtime";
    homepage = "https://github.com/bytecodealliance/wasmtime-py";
    changelog = "https://github.com/bytecodealliance/wasmtime-py/releases/tag/{${finalAttrs.src.tag}}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})

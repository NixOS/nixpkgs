{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  hatchling,
  requests,

  # preBuild
  wgpu-native,

  # dependencies
  cffi,
  rubicon-objc,
  sniffio,

  # optional dependency
  glfw,

  # docs
  sphinx-rtd-theme,
  sphinxHook,

  # tests
  anyio,
  imageio,
  numpy,
  psutil,
  pytest,
  ruff,
  trio,

  # passthru
  wgpu-py,
  testers,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "wgpu-py";
  version = "0.19.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygfx";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-y4uRTTWwoTtV0azl+OIxsSeLXFJAM0ioSuBNwPVlLXo=";
  };

  patches = [
    ## -- codegen/tests/test_codegen_z.py::test_that_code_is_up_to_date --
    # Fix snapshot test failing due to ruff formatting the file
    (fetchpatch {
      name = "snapshot-ruff-format-fix";
      url = "https://github.com/pygfx/wgpu-py/commit/0cb6a48e3662f21a9fc1b54abcb028b6cd928953.patch";
      hash = "sha256-DQFJ1fXHEgI87l53LDSpH8MqA6Z8YYi5wxVH3PcuQUY=";
      includes = [ "wgpu/backends/wgpu_native/_api.py" ];
    })
  ];

  # wgpu-py expects to have an appropriately named wgpu-native library in wgpu/resources
  preBuild = ''
    cp ${wgpu-native}/lib/libwgpu_native${stdenv.hostPlatform.extensions.library} \
      wgpu/resources/libwgpu_native-release${stdenv.hostPlatform.extensions.library}
  '';

  nativeBuildInputs = [
    requests
  ];

  build-system = [ hatchling ] ++ optional-dependencies.docs;

  dependencies =
    [
      cffi
      sniffio
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      rubicon-objc
    ];

  optional-dependencies = {
    # jupyter = [ jupyter_rfb ] not in nixpkgs
    glfw = [ glfw ];
    # imgui = ["imgui-bundle>=1.2.1"] not in nixpkgs

    docs = [
      sphinxHook
      sphinx-rtd-theme
    ];
  };

  pythonImportsCheck = [ "wgpu" ];

  nativeCheckInputs = [
    anyio
    imageio
    numpy
    psutil
    pytest
    ruff
    trio
  ];

  checkPhase = ''
    runHook preCheck

    set -e
    pytest -v tests/
    pytest -v examples/
    pytest -v codegen/
    pytest -v tests_mem/

    runHook postCheck
  '';

  outputs = [
    "out"
    "doc"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = wgpu-py;
      command = "python3 -c 'from wgpu._version import __version__; print(__version__)'";
    };
  };

  meta = {
    description = "WebGPU for Python";
    homepage = "https://github.com/pygfx/wgpu-py";
    changelog = "https://github.com/pygfx/wgpu-py/blob/v${version}/CHANGELOG.md";

    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}

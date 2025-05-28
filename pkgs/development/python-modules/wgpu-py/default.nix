{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

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
  pypng,
  pytest,
  ruff,
  trio,

  # passthru
  testers,
  wgpu-py,
}:
buildPythonPackage rec {
  pname = "wgpu-py";
  version = "0.22.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygfx";
    repo = "wgpu-py";
    tag = "v${version}";
    hash = "sha256-sjpTTOYv5FXMieUJvCQ2nJ1I0zaguyd7//vdLlt8Bmk=";
  };

  # `requests` is only used to fetch a copy of `wgpu-native` via `tools/hatch_build.py`.
  # As we retrieve `wgpu-native` from nixpkgs instead, none of this is needed, and
  # remove an extra dependency.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["requests", "hatchling"]' 'requires = ["hatchling"]' \
      --replace-fail '[tool.hatch.build.targets.wheel.hooks.custom]' "" \
      --replace-fail 'path = "tools/hatch_build.py"' ""
  '';

  # wgpu-py expects to have an appropriately named wgpu-native library in wgpu/resources
  preBuild = ''
    ln -s ${wgpu-native}/lib/libwgpu_native${stdenv.hostPlatform.extensions.library} \
      wgpu/resources/libwgpu_native-release${stdenv.hostPlatform.extensions.library}
  '';

  build-system = [ hatchling ];

  dependencies =
    # Runtime dependencies
    [
      cffi
      sniffio
    ]
    # Required only on darwin
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

  pythonRemoveDeps = [ "requests" ];

  pythonImportsCheck = [ "wgpu" ];

  nativeCheckInputs = [
    anyio
    imageio
    numpy
    psutil
    pypng
    pytest
    ruff
    trio
  ];

  # Tests break in Linux CI due to wgpu being unable to find any adapters.
  # Ordinarily, this would be fixed in an approach similar to `pkgs/by-name/wg/wgpu-native/examples.nix`'s
  # usage of `runtimeInputs` and `makeWrapperArgs`.
  # Unfortunately, as this is a Python module without a `mainProgram`, `makeWrapperArgs` will not apply here,
  # as there is no "script" to wrap.
  doCheck = stdenv.hostPlatform.isDarwin;

  installCheckPhase = ''
    runHook preInstallCheck

    for suite in tests examples codegen tests_mem; do
      pytest -v $suite
    done

    runHook postInstallCheck
  '';

  passthru.tests.version = testers.testVersion {
    package = wgpu-py;
    command = "python3 -c 'import wgpu; print(wgpu.__version__)'";
  };

  meta = {
    description = "WebGPU for Python";
    homepage = "https://github.com/pygfx/wgpu-py";
    changelog = "https://github.com/pygfx/wgpu-py/blob/${src.tag}/CHANGELOG.md";

    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}

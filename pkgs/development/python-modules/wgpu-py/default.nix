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
  pytest,
  ruff,
  trio,

  # passthru
  wgpu-py,
  testers,
}:
buildPythonPackage rec {
  pname = "wgpu-py";
  version = "0.21.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygfx";
    repo = "wgpu-py";
    tag = "v${version}";
    hash = "sha256-XlV0ovIF3w/u6f65+3c4zAfisCoQDbzMiINJJTR/I6o=";
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
    pytest
    ruff
    trio
  ];

  # Tests break due to sandboxing on everything except darwin
  # Prefer to run them in passthru
  doCheck = false;

  passthru = {
    tests =
      {
        version = testers.testVersion {
          package = wgpu-py;
          command = "python3 -c 'import wgpu; print(wgpu.__version__)'";
        };
      }
      // lib.optionalAttrs stdenv.buildPlatform.isDarwin {
        tests = testers.runCommand {
          name = "tests";
          script = ''
            WGPU_LIB_PATH=${wgpu-native}/lib/libwgpu_native${stdenv.hostPlatform.extensions.library} \
              pytest -v ${wgpu-py.src}/tests
          '';
          nativeBuildInputs = [ wgpu-py ] ++ nativeCheckInputs;
        };

        examples = testers.runCommand {
          name = "examples";
          script = ''
            WGPU_LIB_PATH=${wgpu-native}/lib/libwgpu_native${stdenv.hostPlatform.extensions.library} \
              pytest -v ${wgpu-py.src}/examples
          '';
          nativeBuildInputs = [ wgpu-py ] ++ nativeCheckInputs;
        };

        codegen = testers.runCommand {
          name = "codegen";
          script = ''
            WGPU_LIB_PATH=${wgpu-native}/lib/libwgpu_native${stdenv.hostPlatform.extensions.library} \
              pytest -v ${wgpu-py.src}/codegen
          '';
          nativeBuildInputs = [ wgpu-py ] ++ nativeCheckInputs;
        };

        tests_mem = testers.runCommand {
          name = "tests_mem";
          script = ''
            WGPU_LIB_PATH=${wgpu-native}/lib/libwgpu_native${stdenv.hostPlatform.extensions.library} \
              pytest -v ${wgpu-py.src}/tests_mem
          '';
          nativeBuildInputs = [ wgpu-py ] ++ nativeCheckInputs;
        };
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

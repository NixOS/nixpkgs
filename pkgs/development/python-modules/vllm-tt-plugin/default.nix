{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gnugrep,
  python,
  pythonAtLeast,
  runCommand,
  setuptools,
  tblib,
  pytestCheckHook,
  vllm,
}:

let
  vllmVersion = lib.versions.majorMinor vllm.version;
in

buildPythonPackage (finalAttrs: {
  pname = "vllm-tt-plugin";
  version = "0.1.0-unstable-2026-10-09";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "vllm-tt-plugin";
    rev = "c62035d8f16eb591b258a7d5f2b329495829a74c";
    hash = "sha256-Vq1RLb2+4XzxP9BGYrUaLlCo2JXH/RFL2DtNO1ndp18=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=77.0.3,<81.0.0" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [ tblib ];

  pythonImportsCheck = [ "vllm_tt_plugin" ];

  nativeCheckInputs = [
    pytestCheckHook
    vllm
  ];

  preCheck = ''
    export PYTHONPATH=$PWD/ci/host-stubs:$PYTHONPATH
  '';

  disabledTestPaths = [ "tests/tt" ];

  passthru = {
    tests = {
      vllm-tt-plugin-can-be-loaded-by-vllm =
        runCommand "vllm-tt-plugin-can-be-loaded-by-vllm"
          {
            nativeBuildInputs = [
              gnugrep
              (python.withPackages (ps: [
                ps.vllm
                finalAttrs.finalPackage
              ]))
            ];
          }
          # Note that grepping vllm's output directly
          # would kill it prematurely when a match occurs,
          # hence redirect to a file, then grep.
          ''
            (
            set -ex
            vllm --version >/tmp/vllm.log
            grep -qF -- '- tt -> vllm_tt_plugin.entrypoints:platform_plugin' /tmp/vllm.log
            touch $out
            )
          '';
    };
  };

  meta = {
    description = "Tenstorrent backend plugin for vLLM";
    homepage = "https://github.com/tenstorrent/vllm-tt-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    problems =
      let
        supportedVllmVersions = [
          "0.29.0"
        ];
        incompatibleVllm = !(lib.elem vllmVersion supportedVllmVersions);
      in
      lib.optionalAttrs incompatibleVllm {
        kind = "broken";
        message = ''
          This version of vllm (${vllmVersion}) is incompatible with vllm-tt-plugin.
          Supported versions: ${lib.concatStringsSep " " supportedVllmVersions}
        '';
      };
  };
})

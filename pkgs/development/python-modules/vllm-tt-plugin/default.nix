{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  tblib,
}:

buildPythonPackage {
  pname = "vllm-tt-plugin";
  version = "0.1.0-unstable-2026-10-02";
  pyproject = true;

  disabled = pythonOlder "3.10" || pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "vllm-tt-plugin";
    rev = "3506696ccada3881862a5fc52cebe10ab5becf4c";
    hash = "sha256-ZJw8/PEsFYMsSBAihKjHhf0lb+XT8L/PCTkK7Pu46PI=";
  };

  build-system = [ setuptools ];

  dependencies = [ tblib ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=77.0.3,<81.0.0" "setuptools"
  '';

  pythonImportsCheck = [ "vllm_tt_plugin" ];

  meta = {
    description = "Tenstorrent backend plugin for vLLM";
    homepage = "https://github.com/tenstorrent/vllm-tt-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
  };
}

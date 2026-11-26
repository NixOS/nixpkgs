{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-cmd-comp,
  prompt-toolkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-cmd-comp";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CGamesPlay";
    repo = "llm-cmd-comp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0wUM8mJdGB/Y6xs1bYd0VauI8KoTYgbODgJRtCu51XM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    prompt-toolkit
  ];

  # No Python tests upstream, only a shell-driven integration test.
  doCheck = false;

  pythonImportsCheck = [ "llm_cmd_comp" ];

  passthru.tests = llm.mkPluginTest llm-cmd-comp;

  meta = {
    description = "Use LLM to generate commands for your shell";
    homepage = "https://github.com/CGamesPlay/llm-cmd-comp";
    changelog = "https://github.com/CGamesPlay/llm-cmd-comp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
